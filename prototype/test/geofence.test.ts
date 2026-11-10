// TRD 需求覆盖: 2.3 抵达判定/围栏/置信度融合, NAV-06 乘车拦截,
//               六.2 围栏误判专项（可执行子集: GPS漂移/河对岸/低精度/乘车）
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { GeofenceEngine, serverVerifyArrival, isGpsJump } from '../src/geofence.ts';
import type { GpsFix } from '../src/geofence.ts';
import type { Poi } from '../src/types.ts';

const DEST = { lat: 31.2304, lng: 121.4737 };

function fixAt(latM: number, lngM: number, over: Partial<GpsFix> = {}): GpsFix {
  return {
    lat: DEST.lat + latM / 111_320,
    lng: DEST.lng + lngM / (111_320 * Math.cos((DEST.lat * Math.PI) / 180)),
    accuracyM: 8, speedMps: 1.3, timestampMs: 0, stepCount: 0,
    ...over,
  };
}

function walkSequence(): GpsFix[] {
  // 60s 内持续接近: 120m → 90m → 60m → 35m → 20m → 12m, 步数递增
  const dists = [120, 90, 60, 35, 20, 12];
  return dists.map((d, i) => fixAt(0, -d, {
    timestampMs: i * 10_000,
    stepCount: 100 + i * 22,
  }));
}

test('围栏: 正常步行抵达触发（置信度≥0.8）[TRD 2.3]', () => {
  let arrived = false;
  const eng = new GeofenceEngine(DEST, {
    fenceRadiusM: 30,
    onArrive: () => { arrived = true; },
  });
  for (const f of walkSequence()) eng.onLocationUpdate(f);
  assert.equal(arrived, true, '持续接近+良好精度+步数递增应触发');
});

test('围栏专项: 河对岸/GPS漂移至 40m 外绝不触发 [TRD 六.2 误判率=0]', () => {
  let arrived = false, nudged = false;
  const eng = new GeofenceEngine(DEST, {
    fenceRadiusM: 30,
    onArrive: () => { arrived = true; },
    onNudge: () => { nudged = true; },
  });
  // 45m 外的漂移轨迹（精度再好也不能判抵达）
  const drift = [80, 60, 50, 45, 44, 45].map((d, i) =>
    fixAt(0, -d, { accuracyM: 6, timestampMs: i * 10_000, stepCount: 100 + i * 20 }));
  for (const f of drift) eng.onLocationUpdate(f);
  assert.equal(arrived, false, '围栏外漂移不得触发');
  assert.equal(nudged, false, '未进围栏不应提示再靠近');
});

test('围栏专项: 低精度单点进围栏 → 只提示不揭晓（防隔栏杆误判）[TRD 六.2]', () => {
  const events: string[] = [];
  const eng = new GeofenceEngine(DEST, {
    fenceRadiusM: 30,
    onArrive: () => events.push('arrived'),
    onNudge: () => events.push('nudge'),
  });
  // 落入围栏(20m)但精度 55m, 无步数增量
  for (let i = 0; i < 4; i++) {
    eng.onLocationUpdate(fixAt(0, -20, { accuracyM: 55, timestampMs: i * 10_000, stepCount: 100 }));
  }
  assert.deepEqual(events, ['nudge', 'nudge', 'nudge', 'nudge'], '低置信度只允许 nudge');
});

test('围栏专项: 乘车进入围栏不触发揭晓 [TRD NAV-06 / 六.2]', () => {
  const events: string[] = [];
  const eng = new GeofenceEngine(DEST, {
    fenceRadiusM: 30,
    onArrive: () => events.push('arrived'),
    onVehicle: () => events.push('vehicle'),
  });
  // 41 km/h = 11.4 m/s 的定位点直接落在围栏中心
  eng.onLocationUpdate(fixAt(0, 0, { speedMps: 11.4, accuracyM: 5 }));
  assert.deepEqual(events, ['vehicle']);
});

test('围栏: 无计步器设备(步数中性 0.5)高精度仍可抵达 [兼容性]', () => {
  let arrived = false;
  const eng = new GeofenceEngine(DEST, { fenceRadiusM: 30, onArrive: () => { arrived = true; } });
  // 无 stepCount(传感器缺失), 但精度 6m 且近60s轨迹全在 2×围栏 内:
  // conf = 0.4*1 + 0.35*1 + 0.25*0.5 = 0.875 ≥ 0.8 ✓
  for (const f of [60, 40, 25, 15, 10].map((d, i) => fixAt(0, -d, { accuracyM: 6, timestampMs: i * 10_000 }))) {
    eng.onLocationUpdate(f);
  }
  assert.equal(arrived, true, '无计步器不应阻断正常抵达');
});

test('服务端二次校验: 轨迹末端 vs POI 围栏 [TRD 2.3 / fn_verify_arrival 镜像]', () => {
  const poi = {
    id: 1, lat: DEST.lat, lng: DEST.lng, name: '', nameLocal: '', category: 'park',
    description: '', source: 'seed' as const, editorScore: 3, safetyScore: 80,
    accessibility: {}, fenceRadiusM: 30, status: 'active' as const,
    open24h: false, blacklisted: false, visitCount90d: 0, arriveRate: 0.9, surpriseBoost: 1,
  } satisfies Poi;
  // 末端在围栏内 → 通过
  const good = [fixAt(0, -80, { timestampMs: 0 }), fixAt(0, -40, { timestampMs: 10_000 }), fixAt(0, -15, { timestampMs: 20_000 })];
  assert.equal(serverVerifyArrival(good, poi), true);
  // 末端 100m 外 → 拒绝
  const bad = [fixAt(0, -180, { timestampMs: 0 }), fixAt(0, -120, { timestampMs: 10_000 }), fixAt(0, -100, { timestampMs: 20_000 })];
  assert.equal(serverVerifyArrival(bad, poi), false);
  // 空轨迹 → 拒绝
  assert.equal(serverVerifyArrival([], poi), false);
});

test('isGpsJump: 物理不可能位移检测（>30km/h 点间速度）', () => {
  const p1 = fixAt(0, 0, { timestampMs: 0 });
  assert.equal(isGpsJump(undefined, p1), false);
  assert.equal(isGpsJump(p1, fixAt(0, 3, { timestampMs: 1000 })), false);   // 3 m/s
  assert.equal(isGpsJump(p1, fixAt(0, 100, { timestampMs: 1000 })), true);  // 100 m/s
});

test('补传: drainTrackBatch 批量语义（10 点批量）[TRD 2.3]', () => {
  const eng = new GeofenceEngine(DEST, { fenceRadiusM: 30 });
  for (let i = 0; i < 25; i++) eng.onLocationUpdate(fixAt(0, -1000 - i * 10, { timestampMs: i * 2000 }));
  const batch = eng.drainTrackBatch(10);
  assert.equal(batch.length, 10);
  assert.ok(eng.allTrack().length === 15, '剩余轨迹应为 15 点');
});
