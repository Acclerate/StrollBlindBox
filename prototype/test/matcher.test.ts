// TRD 需求覆盖: 2.1 匹配全流程（候选/硬过滤/加权/兜底/限流）, 2.6 安全过滤
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { InMemoryPoiSource } from '../src/poiSource.ts';
import { match, pickWeighted, weightOf, inDistanceWindow, OpenBoxRateLimiter, RerollLimiter } from '../src/matcher.ts';
import { checkVisibility, isNightHour, isUnreachable, DEFAULT_RULES } from '../src/safety.ts';
import { MODES } from '../src/types.ts';
import type { Poi } from '../src/types.ts';

const CENTER = { lat: 31.2304, lng: 121.4737 };

/** 以 CENTER 为原点, 东向 offsetM 米处造一个 POI */
function makePoi(offsetM: number, overrides: Partial<Poi> = {}): Poi {
  const lng = CENTER.lng + offsetM / (111_320 * Math.cos((CENTER.lat * Math.PI) / 180));
  return {
    id: overrides.id ?? Math.floor(Math.random() * 1e6),
    lat: CENTER.lat, lng,
    name: 'T', nameLocal: '测试点', category: 'park',
    description: '', source: 'seed', editorScore: 4, safetyScore: 80,
    accessibility: {}, fenceRadiusM: 30, status: 'active',
    open24h: false, blacklisted: false, visitCount90d: 0, arriveRate: 0.9,
    surpriseBoost: 1.0,
    ...overrides,
  };
}

// 确定性 LCG, 与演示一致可复现
function lcg(seed: number) {
  let s = seed >>> 0;
  return () => ((s = (s * 1664525 + 1013904223) >>> 0) / 4294967296);
}

test('inDistanceWindow: 直线×绕转系数 ∈ [0.8D, 1.3D] [TRD 2.1 硬过滤]', () => {
  // D=1km, factor=1.35: 窗口 = [800, 1300]m 修正距离
  assert.equal(inDistanceWindow(600, 1, 1.35), true);   // 修正 810 ✓
  assert.equal(inDistanceWindow(1000, 1, 1.35), false); // 修正 1350 ✗
});

test('inDistanceWindow: 边界精确性', () => {
  assert.equal(inDistanceWindow(592.7, 1, 1.35), true);  // 修正=800.1 ∈ 窗口
  assert.equal(inDistanceWindow(592.5, 1, 1.35), false); // 修正=799.9 < 下界
  assert.equal(inDistanceWindow(962.9, 1, 1.35), true);  // 修正=1299.9 ≤ 上界
  assert.equal(inDistanceWindow(963.1, 1, 1.35), false); // 修正=1300.2 > 上界
});

test('match: 距离窗口外的 POI 永不被抽取（50 次抽样）', async () => {
  const near = makePoi(600);                              // 修正 810 ∈ 窗口
  const mid = makePoi(900);                               // 修正 1215 ∈ 窗口
  const far = makePoi(1200, { id: 999 });                 // 修正 1620 ∉ 窗口
  const src = new InMemoryPoiSource([near, mid, far]);
  for (let i = 0; i < 50; i++) {
    const r = await match(src, {
      userId: 'u', center: CENTER, distanceKm: 1, mode: 'normal',
      localHour: 14, rng: lcg(1000 + i),
    });
    assert.notEqual(r.poi.id, 999, '窗口外 POI 被抽取');
    assert.ok(r.via === 'pool');
  }
});

test('match: 近 30 天去重 [TRD 2.1 硬过滤]', async () => {
  const a = makePoi(600, { id: 1 });
  const b = makePoi(900, { id: 2 });
  const src = new InMemoryPoiSource([a, b]);
  const r = await match(src, {
    userId: 'u', center: CENTER, distanceKm: 1, mode: 'normal',
    localHour: 14, visitedPoiIds: new Set([1]), rng: lcg(7),
  });
  assert.equal(r.poi.id, 2, '已抵达 POI 应被去重');
});

test('match: 不可达(ferry_gap/gated/island/rail)被硬过滤 [TRD 2.1/2.6]', async () => {
  const bad1 = makePoi(600, { id: 1, accessibility: { ferry_gap: true } });
  const bad2 = makePoi(650, { id: 2, accessibility: { gated: true } });
  const bad3 = makePoi(700, { id: 3, accessibility: { island: true } });
  const bad4 = makePoi(750, { id: 4, accessibility: { rail_within_50m: true } });
  const good = makePoi(800, { id: 5 });
  const src = new InMemoryPoiSource([bad1, bad2, bad3, bad4, good]);
  for (let i = 0; i < 20; i++) {
    const r = await match(src, {
      userId: 'u', center: CENTER, distanceKm: 1, mode: 'normal',
      localHour: 14, rng: lcg(50 + i),
    });
    assert.equal(r.poi.id, 5);
  }
});

test('match: 夜间模式只允许 24h 类别 [TRD 2.6 夜间过滤]', async () => {
  const parkClosed = makePoi(600, { id: 1, category: 'park', open24h: false, safetyScore: 90 });
  const plazaOpen = makePoi(650, { id: 2, category: 'plaza', open24h: true, safetyScore: 90 });
  const src = new InMemoryPoiSource([parkClosed, plazaOpen]);
  const r = await match(src, {
    userId: 'u', center: CENTER, distanceKm: 1, mode: 'night',
    localHour: 23, rng: lcg(9),
  });
  assert.equal(r.poi.id, 2, '夜间应只选 24h 开放 POI');
});

test('match: 安全黑名单/低安全分/低抵达率 POI 不可见 [TRD 2.6 阻断级]', () => {
  const blacklisted = makePoi(600, { blacklisted: true });
  const lowSafety = makePoi(650, { safetyScore: 40 });
  const lowRate = makePoi(700, { arriveRate: 0.5 });
  const cemetery = makePoi(750, { category: 'cemetery' });
  for (const poi of [blacklisted, lowSafety, lowRate, cemetery]) {
    const v = checkVisibility(poi, MODES.normal, DEFAULT_RULES, 14);
    assert.equal(v.ok, false, `${poi.category}/${poi.safetyScore} 应不可见`);
  }
});

test('match: 冷门优先权重分布 — 90天零访问 POI 显著占优 [TRD 2.1 加权]', async () => {
  const cold = makePoi(600, { id: 1, visitCount90d: 0, editorScore: 5 });
  const hot = makePoi(650, { id: 2, visitCount90d: 99, editorScore: 3 });
  const wCold = weightOf(cold).total;   // 1.0 * 1.0 * (5/5) = 1.0
  const wHot = weightOf(hot).total;     // (1/100) * 1.0 * (3/5) = 0.006
  assert.ok(wCold / wHot > 100, `权重比应>100, 实际 ${wCold / wHot}`);
  const src = new InMemoryPoiSource([cold, hot]);
  let coldPicked = 0;
  const rng = lcg(2026);
  for (let i = 0; i < 200; i++) {
    const r = await match(src, {
      userId: 'u', center: CENTER, distanceKm: 1, mode: 'normal', localHour: 14, rng,
    });
    if (r.poi.id === 1) coldPicked++;
  }
  assert.ok(coldPicked >= 190, `冷门被抽 ${coldPicked}/200, 应≥190`);
});

test('match: 稀有类别 serendipity 加成参与权重 [TRD 2.1 w_serp]', () => {
  const stone = makePoi(600, { category: 'landmark_stone', surpriseBoost: 1.8, visitCount90d: 0, editorScore: 5 });
  assert.ok(Math.abs(weightOf(stone).serp - 1.8) < 1e-9);
  assert.ok(Math.abs(weightOf(stone).total - 1.8) < 1e-9);
});

test('match: 候选池空 → Places 兜底路径 [TRD 2.1 第4步]', async () => {
  // 空候选源(半径内无 POI), 兜底源返回一个 auto POI
  const empty = new InMemoryPoiSource([makePoi(50_000)]); // 50km 外, 候选必空
  const src = {
    name: 'stub',
    queryCandidates: empty.queryCandidates.bind(empty),
    fallbackFetchNearby: async () => [makePoi(1500, { status: 'auto', source: 'auto', id: 42 })],
  };
  const r = await match(src, {
    userId: 'u', center: CENTER, distanceKm: 1, mode: 'normal', localHour: 14, rng: lcg(3),
  });
  assert.equal(r.via, 'fallback');
  assert.equal(r.poi.id, 42);
});

test('match: D 超界拒绝 [TRD 输入约束 0.5–10km]', async () => {
  const src = new InMemoryPoiSource([makePoi(600)]);
  await assert.rejects(() => match(src, {
    userId: 'u', center: CENTER, distanceKm: 0.3, mode: 'normal', localHour: 14,
  }), RangeError);
  await assert.rejects(() => match(src, {
    userId: 'u', center: CENTER, distanceKm: 11, mode: 'normal', localHour: 14,
  }), RangeError);
});

test('safety: 夜间窗口判定跨午夜 [TRD 2.6 22:00–05:00]', () => {
  for (const h of [22, 23, 0, 1, 2, 3, 4]) assert.equal(isNightHour(h), true, `${h}点应为夜间`);
  for (const h of [5, 6, 12, 21, 21.9]) assert.equal(isNightHour(h), false, `${h}点应非夜间`);
});

test('safety: isUnreachable 覆盖四类预计算标记', () => {
  assert.equal(isUnreachable({ ferry_gap: true }), true);
  assert.equal(isUnreachable({ gated: true }), true);
  assert.equal(isUnreachable({ island: true }), true);
  assert.equal(isUnreachable({ rail_within_50m: true }), true);
  assert.equal(isUnreachable({}), false);
});

test('limiter: 开盒 10 次/小时, 第 11 次拒绝 [TRD 四.]', () => {
  const l = new OpenBoxRateLimiter();
  const t0 = Date.now();
  for (let i = 0; i < 10; i++) assert.equal(l.allow('dev', t0 + i), true);
  assert.equal(l.allow('dev', t0 + 10_000), false);
  assert.equal(l.allow('other-dev', t0 + 10_000), true, '限流按设备隔离');
  assert.equal(l.allow('dev', t0 + 3_600_001), true, '窗口滚动后恢复');
});

test('limiter: reroll 3 次/日后拒绝 [TRD 四.]', () => {
  const l = new RerollLimiter();
  assert.deepEqual(l.tryReroll('s'), { ok: true, left: 2 });
  assert.deepEqual(l.tryReroll('s'), { ok: true, left: 1 });
  assert.deepEqual(l.tryReroll('s'), { ok: true, left: 0 });
  assert.deepEqual(l.tryReroll('s'), { ok: false, left: 0 });
});

test('pickWeighted: 确定性注入 rng 的可复现性', () => {
  const items = ['a', 'b'];
  const r1 = pickWeighted(items, (s) => (s === 'a' ? 9 : 1), lcg(42));
  const r2 = pickWeighted(items, (s) => (s === 'a' ? 9 : 1), lcg(42));
  assert.equal(r1, r2);
});
