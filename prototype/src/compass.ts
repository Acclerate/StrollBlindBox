// ============================================================
// WalkBox 原型 · 罗盘航向融合（TRD NAV-01 / NAV-03）
//   静止(speed<0.5km/h) → 信任 GPS course（运动学航向, 无磁干扰）
//   行走中             → 磁罗盘 + 低通滤波(圆周均值), GPS course 作回退
//   磁场强度/精度超阈值 → degraded: UI 降级为“目标在 X 点钟方向”静态指示
// ============================================================

export interface HeadingSample {
  headingDeg: number;                    // 0..360, 正北=0
  source: 'gps-course' | 'magnetometer';
  accuracyDeg?: number;                  // 罗盘精度(度), >25 视为未校准
  magneticFieldStrength?: number;        // µT, >80 视为磁干扰
  speedKmh: number;
  timestampMs: number;
}

export interface HeadingState {
  headingDeg: number;                    // 融合后航向 0..360
  degraded: boolean;
  reason?: 'magnetic-interference' | 'uncalibrated' | 'no-source';
}

const LOW_PASS_ALPHA = 0.2;              // 低通系数: 越小越平滑
const MAG_INTERFERENCE_UT = 80;
const ACCURACY_LIMIT_DEG = 25;
const STATIONARY_KMH = 0.5;

/** 圆周差(a-b) 归一到 (-180,180] — 处理 359°↔1° 跳变 */
export function angularDelta(a: number, b: number): number {
  let d = (a - b) % 360;
  if (d > 180) d -= 360;
  if (d <= -180) d += 360;
  return d;
}

/** 相对转向角: 箭头渲染用 bearing = 目标方位角 − 设备航向（NAV-01）, 归一到 (-180,180] */
export function relativeBearing(targetBearingDeg: number, headingDeg: number): number {
  return angularDelta(targetBearingDeg, headingDeg);
}

/** 把“方位角差”转成时钟方位（NAV-03 降级指示: “目标在你 2 点钟方向”） */
export function bearingToClock(relativeDeg: number): string {
  const normalized = ((relativeDeg % 360) + 360) % 360; // 0=正前, 90=右侧
  const hour = Math.round(normalized / 30) % 12;
  return `${hour === 0 ? 12 : hour} 点钟方向`;
}

export class CompassFuser {
  private smoothed: number | null = null;

  reset(): void { this.smoothed = null; }

  update(s: HeadingSample): HeadingState {
    // NAV-03: 磁干扰/未校准检测（仅罗盘来源时才适用）
    if (s.source === 'magnetometer') {
      if (s.magneticFieldStrength !== undefined && s.magneticFieldStrength > MAG_INTERFERENCE_UT) {
        return { headingDeg: this.smoothed ?? s.headingDeg, degraded: true, reason: 'magnetic-interference' };
      }
      if (s.accuracyDeg !== undefined && s.accuracyDeg > ACCURACY_LIMIT_DEG) {
        return { headingDeg: this.smoothed ?? s.headingDeg, degraded: true, reason: 'uncalibrated' };
      }
    }
    // GPS course 仅在有意义速度下有效（<0.5km/h 时 course 是噪声）
    if (s.source === 'gps-course' && s.speedKmh < STATIONARY_KMH) {
      return { headingDeg: this.smoothed ?? s.headingDeg, degraded: false };
    }

    // 低通滤波(圆周空间): heading = prev + α·(raw − prev)
    if (this.smoothed === null) this.smoothed = s.headingDeg;
    else this.smoothed = (this.smoothed + LOW_PASS_ALPHA * angularDelta(s.headingDeg, this.smoothed) + 360) % 360;
    return { headingDeg: this.smoothed, degraded: false };
  }
}
