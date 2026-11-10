// ============================================================
// WalkBox 原型 · 抵达判定 / 地理围栏（TRD 2.3）
//   onLocationUpdate(loc):
//     d = haversine(loc, destination)
//     if d ≤ fence: confidence = fuse(GPS精度, 近60s轨迹, 步数增量)
//       ≥ 0.8 → triggerArrival()
//       否则   → “再靠近一点确认”（防隔河/隔栏杆误判）
//   抵达事件 = 客户端触发 + 服务端二次校验（轨迹末端 vs POI 坐标）
// ============================================================

import { haversineMeters } from './geo.ts';
import { VEHICLE_KMH } from './motion.ts';
import type { LatLng, Poi } from './types.ts';

export interface GpsFix {
  lat: number;
  lng: number;
  accuracyM: number;       // GPS 水平精度; >50 触发降精度显示(TRD 定位精度策略)
  speedMps: number;
  timestampMs: number;
  stepCount?: number;      // 传感器累计步数快照(可缺省: 无计步器设备)
}

export type FenceVerdict = 'idle' | 'approaching' | 'nudge' | 'arrived' | 'vehicle';

export interface FenceEvent {
  verdict: FenceVerdict;
  distanceM: number;
  confidence?: number;     // verdict=arrived/nudge 时给出
  message?: string;
}

export interface ConfidenceBreakdown {
  gps: number;             // GPS 精度项
  track: number;           // 近 60s 轨迹项
  step: number;            // 步数增量项
  fused: number;
}

const TRACK_WINDOW_MS = 60_000;
const W_GPS = 0.4, W_TRACK = 0.35, W_STEP = 0.25;
const ARRIVE_THRESHOLD = 0.8;

export interface GeofenceOptions {
  fenceRadiusM: number;                 // 默认 30, 按 POI 物理尺度可至 80(TRD 2.3)
  onArrive?: (ev: FenceEvent) => void;
  onNudge?: (ev: FenceEvent) => void;
  onVehicle?: (ev: FenceEvent) => void;
}

export class GeofenceEngine {
  private track: GpsFix[] = [];
  private arrived = false;
  private destination: LatLng;
  private opts: GeofenceOptions;

  constructor(destination: LatLng, opts: GeofenceOptions) {
    this.destination = destination;
    this.opts = opts;
  }

  get fenceRadiusM(): number { return this.opts.fenceRadiusM; }

  /** 主入口: 每个定位更新调用一次 */
  onLocationUpdate(fix: GpsFix): FenceEvent {
    // 乘车判定优先: 乘车抵达不触发揭晓(TRD NAV-06)
    const kmh = fix.speedMps * 3.6;
    const d = haversineMeters(fix, this.destination);

    if (kmh > VEHICLE_KMH) {
      const ev: FenceEvent = { verdict: 'vehicle', distanceM: d, message: '这不像走路哦——检测到乘车，本次定位不计入' };
      this.opts.onVehicle?.(ev);
      return ev;
    }

    if (d <= this.opts.fenceRadiusM) {
      this.track.push(fix);
      const conf = this.fuse(fix, d);
      if (conf.fused >= ARRIVE_THRESHOLD && !this.arrived) {
        this.arrived = true;
        const ev: FenceEvent = { verdict: 'arrived', distanceM: d, confidence: conf.fused, message: '抵达目的地！' };
        this.opts.onArrive?.(ev);
        return ev;
      }
      const ev: FenceEvent = {
        verdict: 'nudge', distanceM: d, confidence: conf.fused,
        message: '再靠近一点确认（防止隔河/隔栏杆误判）',
      };
      this.opts.onNudge?.(ev);
      return ev;
    }

    this.track.push(fix);
    return { verdict: d <= this.opts.fenceRadiusM * 3 ? 'approaching' : 'idle', distanceM: d };
  }

  /** 近 60s 轨迹窗内的置信度（轨迹项按“距目的地≤2×围栏”占比计） */
  private fuse(fix: GpsFix, _d: number): ConfidenceBreakdown {
    const now = fix.timestampMs;
    this.track = this.track.filter((f) => now - f.timestampMs <= TRACK_WINDOW_MS);
    const recent = this.track;
    const gps = Math.max(0, Math.min(1, (50 - fix.accuracyM) / 45));
    let track = 0.5;
    if (recent.length >= 2) {
      const inside = recent.filter((f) => haversineMeters(f, this.destination) <= this.opts.fenceRadiusM * 2).length;
      track = inside / recent.length;
    }
    let step = 0.5;
    if (recent.length >= 2) {
      const first = recent[0].stepCount, last = recent[recent.length - 1].stepCount;
      if (first !== undefined && last !== undefined && last - first > 0) step = 1;
    }
    return { gps, track, step, fused: W_GPS * gps + W_TRACK * track + W_STEP * step };
  }

  /** 补传轨迹（每 60s 或 10 点批量, TRD 2.3） */
  drainTrackBatch(maxPoints = 10): GpsFix[] {
    if (this.track.length >= maxPoints) {
      const batch = this.track.splice(0, maxPoints);
      return batch;
    }
    return [];
  }

  allTrack(): GpsFix[] { return [...this.track]; }
}

/**
 * 服务端二次校验（镜像 DB fn_verify_arrival）:
 * 轨迹末端最多 10 点中至少 1 点落在围栏内 → server_verified=true。
 * 校验通过才点亮图鉴、计入排行（TRD 2.3）。
 */
export function serverVerifyArrival(track: GpsFix[], poi: Poi): boolean {
  if (track.length === 0) return false;
  const tail = track.slice(-10);
  const dest = { lat: poi.lat, lng: poi.lng };
  return tail.some((f) => haversineMeters(f, dest) <= poi.fenceRadiusM);
}

/** TRD 六.2 围栏误判专项的可执行判定辅助: GPS 漂移检测（单点跳变 > 速度上限推算距离） */
export function isGpsJump(prev: GpsFix | undefined, cur: GpsFix): boolean {
  if (!prev) return false;
  const dtSec = Math.max(1, (cur.timestampMs - prev.timestampMs) / 1000);
  const dist = haversineMeters(prev, cur);
  // 30km/h = 8.33 m/s; 超出即物理不可能的位移(漂移或传送)
  return dist / dtSec > 8.34;
}
