// TRD 需求覆盖: NAV-06 有效移动判定（速度门限/计步/乘车检测）, NAV-01/03 航向融合
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { classifySpeed, StepCounter, WALK_MIN_KMH, WALK_MAX_KMH, VEHICLE_KMH } from '../src/motion.ts';
import { CompassFuser, relativeBearing, angularDelta, bearingToClock } from '../src/compass.ts';

test('速度门限: 0.5–12 km/h 步行 / 12–30 可疑 / >30 乘车 [TRD NAV-06]', () => {
  assert.equal(classifySpeed(0.4), 'stationary');
  assert.equal(classifySpeed(0.5), 'walking');       // 下边界含
  assert.equal(classifySpeed(4.7), 'walking');
  assert.equal(classifySpeed(WALK_MAX_KMH), 'walking');       // 上边界含
  assert.equal(classifySpeed(12.1), 'suspicious');
  assert.equal(classifySpeed(30), 'suspicious');
  assert.equal(classifySpeed(30.1), 'vehicle');
  assert.equal(classifySpeed(80), 'vehicle');
});

test('计步: 仅步行区间增量计入, 乘车/可疑段丢弃 [TRD NAV-06]', () => {
  const sc = new StepCounter();
  assert.equal(sc.update(4, 30).countedDelta, 30);
  assert.equal(sc.update(0.3, 5).countedDelta, 0);   // 静止(手抖噪声)不计
  assert.equal(sc.update(11, 100).countedDelta, 100);
  assert.equal(sc.update(45, 500).countedDelta, 0);  // 公交颠簸不计
  assert.equal(sc.update(20, 200).countedDelta, 0);  // 骑行可疑段不计
  assert.equal(sc.update(5, -3).countedDelta, 0);    // 负增量防御
  assert.equal(sc.steps, 130);
});

test('angularDelta: 跨 0°/360° 归一 [NAV-01]', () => {
  assert.ok(Math.abs(angularDelta(350, 10) - (-20)) < 1e-9);
  assert.ok(Math.abs(angularDelta(10, 350) - 20) < 1e-9);
  assert.ok(Math.abs(angularDelta(180, 0) - 180) < 1e-9 || Math.abs(angularDelta(180, 0) - (-180)) < 1e-9);
});

test('relativeBearing: 目标在正右方 → +90°（箭头渲染方向）[NAV-01]', () => {
  assert.ok(Math.abs(relativeBearing(90, 0) - 90) < 1e-9);
  assert.ok(Math.abs(relativeBearing(0, 90) - (-90)) < 1e-9);
  assert.ok(Math.abs(relativeBearing(359, 1) - (-2)) < 1e-9);
});

test('bearingToClock: NAV-03 降级静态指示文案', () => {
  assert.equal(bearingToClock(0), '12 点钟方向');
  assert.equal(bearingToClock(90), '3 点钟方向');
  assert.equal(bearingToClock(-90), '9 点钟方向');
  assert.equal(bearingToClock(180), '6 点钟方向');
});

test('CompassFuser: 低通收敛与磁干扰降级 [NAV-01/NAV-03]', () => {
  const f = new CompassFuser();
  // 首个样本初始化为原值; 第二个样本起低通(α=0.2)部分收敛
  const s1 = f.update({ headingDeg: 100, source: 'magnetometer', accuracyDeg: 10, speedKmh: 5, timestampMs: 0 });
  assert.ok(Math.abs(s1.headingDeg - 100) < 1e-9, '首个样本直接初始化');
  assert.equal(s1.degraded, false);
  const s2 = f.update({ headingDeg: 120, source: 'magnetometer', accuracyDeg: 10, speedKmh: 5, timestampMs: 100 });
  assert.ok(s2.headingDeg > 100 && s2.headingDeg < 120, `第二样本应部分收敛, got ${s2.headingDeg}`);
  let last = s1;
  for (let i = 1; i <= 30; i++) {
    last = f.update({ headingDeg: 100, source: 'magnetometer', accuracyDeg: 10, speedKmh: 5, timestampMs: i * 100 });
  }
  assert.ok(Math.abs(last.headingDeg - 100) < 1, '多次输入应收敛到 100°');

  // 磁场强度超阈值 → degraded 且冻结平滑值
  const d1 = f.update({ headingDeg: 40, source: 'magnetometer', accuracyDeg: 10, magneticFieldStrength: 120, speedKmh: 5, timestampMs: 4000 });
  assert.equal(d1.degraded, true);
  assert.equal(d1.reason, 'magnetic-interference');
  assert.ok(Math.abs(d1.headingDeg - 100) < 1, '干扰期间应保持上一有效值');

  // 精度差(未校准) → degraded
  const d2 = f.update({ headingDeg: 100, source: 'magnetometer', accuracyDeg: 40, speedKmh: 5, timestampMs: 5000 });
  assert.equal(d2.degraded, true);
  assert.equal(d2.reason, 'uncalibrated');

  // 静止时的 GPS course 是噪声 → 忽略, 不更新
  const f2 = new CompassFuser();
  f2.update({ headingDeg: 50, source: 'magnetometer', accuracyDeg: 5, speedKmh: 4, timestampMs: 0 });
  const keep = f2.update({ headingDeg: 300, source: 'gps-course', accuracyDeg: 5, speedKmh: 0.2, timestampMs: 100 });
  assert.ok(Math.abs(keep.headingDeg - 50) < 1e-6, '静止 GPS course 应被忽略');
});
