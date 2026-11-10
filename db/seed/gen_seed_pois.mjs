// ============================================================
// WalkBox 种子 POI 生成器（① 交付物）
//
// 用途: 生成可复现（确定性 PRNG）的上海中心城区 500 个种子 POI，
//       供 DDL 验证 / 匹配算法原型 / 安全过滤回归使用。
//
//   node db/seed/gen_seed_pois.mjs [--out sql] [--out csv]
//     输出（默认同时写）:
//       db/seed/seed_pois.sql  — INSERT ... ON CONFLICT (source_ref) DO NOTHING（幂等）
//       db/seed/seed_pois.csv  — 同数据的 CSV（供 import_csv.sql 的 \copy 通道）
//
// 样本构成（共 500）:
//   410 正常 active 白名单 POI
//    20 ferry_gap（黄浦江东岸“跨江不可达”标记, 匹配期硬过滤验证）
//    30 黑名单样本: cemetery×8, highway×6（种子期直接标记）
//                 construction×8（靠 poi_safety_rule + fn_refresh_blacklist 热更新标记）
//                 island×4, rail_within_50m×4（accessibility 预计算联动标记）
//    20 status='auto' 待审核（审核队列演示）
//    20 抵达率低样本: 10 个 status='retired', 10 个 active 但 arrive_rate<0.6（v_poi_active 隐藏）
// ============================================================

import { writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = dirname(fileURLToPath(import.meta.url));
const SEED = 20261110; // 与 TRD 文档日期一致，保证可复现

// ---------- 确定性 PRNG (mulberry32) ----------
function mulberry32(seed) {
  let a = seed >>> 0;
  return function () {
    a |= 0; a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
const rng = mulberry32(SEED);
const randInt = (lo, hi) => lo + Math.floor(rng() * (hi - lo + 1));
const pick = (arr) => arr[Math.floor(rng() * arr.length)];

// ---------- 地理参考: 上海人民广场为中心 ----------
const CENTER = { lat: 31.2304, lng: 121.4737 };
const GEN_RADIUS_M = 11000; // 生成半径 11km（覆盖 10km 设定距离 × 1.2 上限）

const M_PER_DEG_LAT = 111320;
const M_PER_DEG_LNG = 111320 * Math.cos((CENTER.lat * Math.PI) / 180);

// 黄浦江简化模型: 市区段近似斜线, 东侧为浦东
function riverLngAt(lat) {
  return 121.49 + (lat - 31.2) * 0.25;
}

// 极坐标均匀撒点（密度均匀于圆盘）
function randomPointInDisc() {
  const r = GEN_RADIUS_M * Math.sqrt(rng());
  const theta = rng() * 2 * Math.PI;
  return {
    lat: CENTER.lat + (r * Math.cos(theta)) / M_PER_DEG_LAT,
    lng: CENTER.lng + (r * Math.sin(theta)) / M_PER_DEG_LNG,
  };
}
// 强制东岸点（浦东, 用于 ferry_gap 样本）
function randomEastBankPoint() {
  const p = randomPointInDisc();
  const river = riverLngAt(p.lat);
  return { lat: p.lat, lng: river + Math.max(p.lng - river, 500 / M_PER_DEG_LNG + rng() * 0.02) };
}

// ---------- 类别词典（与 db/schema/002_tables.sql poi_category 对齐） ----------
const NAME_POOLS = {
  park:            { zh: ['街心花园', '口袋公园', '梧桐绿地', '滨江小园', '社区花园'], en: 'Park' },
  shrine:          { zh: ['老城隍庙', '静安别院', '观音堂', '基督教堂', '土地庙'], en: 'Temple' },
  museum:          { zh: ['弄堂记忆馆', '纺织博物馆', '邮票博物馆', '消防博物馆', '唱片博物馆'], en: 'Museum' },
  monument:        { zh: ['城市纪念雕塑', '工人纪念碑', '抗战纪念墙', '艺术家雕像', '百年校址碑塔'], en: 'Monument' },
  landmark_stone:  { zh: ['老码头界碑', '古城墙残碑', '里坊铭牌', '桥梁奠基石', '商号旧址碑'], en: 'Stone' },
  public_facility: { zh: ['区图书馆', '市民健身中心', '社区文化中心', '科普活动站', '邻里中心'], en: 'PublicFacility' },
  plaza:           { zh: ['音乐广场', '喷泉广场', '下沉式广场', '文化广场', '站前广场'], en: 'Plaza' },
  convenience:     { zh: ['便利店聚合点', '地铁站口便利点', '夜宵街角点', '社区超市点'], en: 'Convenience' },
  cemetery:        { zh: ['陵园', '墓园', '纪念园(墓区)'], en: 'Cemetery' },
  highway:         { zh: ['高速服务区', '高架桥下空间'], en: 'Highway' },
  construction:    { zh: ['在建工地', '拆迁区块', '围挡施工区'], en: 'Construction' },
};

const FENCE_BY_CATEGORY = { park: 60, plaza: 50, landmark_stone: 20 }; // 按 POI 物理尺度配置, 其余默认 30
const NIGHT_SAFE = new Set(['public_facility', 'plaza', 'convenience']);

const whitelistDistribution = [ // 正常样本 410
  ['park', 90], ['shrine', 40], ['museum', 45], ['monument', 45],
  ['landmark_stone', 30], ['public_facility', 50], ['plaza', 40], ['convenience', 70],
];

const rows = [];
let seq = 0;
function addPoi({ category, geom, opts = {} }) {
  seq += 1;
  const pool = NAME_POOLS[category];
  const zhName = `${pick(pool.zh)} ${String(seq).padStart(3, '0')}`;
  const enName = `${pool.en}-${String(seq).padStart(3, '0')}`;

  let safety = 55 + rng() * 40;
  if (NIGHT_SAFE.has(category)) safety += 5;
  if (category === 'shrine' || category === 'landmark_stone') safety -= 5;
  safety = Math.max(40, Math.min(98, Math.round(safety)));

  // 冷门优先验证: 少数热点给高访问量
  let visitCount = rng() < 0.3 ? 0 : randInt(1, 40);
  if (rng() < 0.05) visitCount = randInt(60, 120);

  let open24h = category === 'convenience' ? true
    : category === 'plaza' ? rng() < 0.7
    : category === 'public_facility' ? rng() < 0.3
    : false;

  rows.push({
    lat: +geom.lat.toFixed(6),
    lng: +geom.lng.toFixed(6),
    name: enName,
    name_local: zhName,
    category,
    description: `${zhName}（生成种子数据，用于原型验证，非真实地点）`,
    source: opts.source ?? 'seed',
    source_ref: `seed:${String(seq).padStart(4, '0')}`,
    editor_score: opts.editor_score ?? (rng() < 0.5 ? 3 : rng() < 0.8 ? 4 : randInt(2, 5)),
    safety_score: opts.safety_score ?? safety,
    accessibility: opts.accessibility ?? {},
    fence_radius_m: opts.fence_radius_m ?? FENCE_BY_CATEGORY[category] ?? 30,
    status: opts.status ?? 'active',
    open_24h: opts.open_24h ?? open24h,
    blacklisted: opts.blacklisted ?? false,
    blacklist_reason: opts.blacklist_reason ?? null,
    visit_count_90d: opts.visit_count_90d ?? visitCount,
    arrive_rate: opts.arrive_rate ?? +(0.62 + rng() * 0.36).toFixed(2),
  });
}

// ---- 1) 正常 active 白名单 410 ----
for (const [category, n] of whitelistDistribution) {
  for (let i = 0; i < n; i++) addPoi({ category, geom: randomPointInDisc() });
}

// ---- 2) ferry_gap 20（东岸, 跨江不可达标记） ----
for (let i = 0; i < 20; i++) {
  addPoi({
    category: pick(['park', 'plaza', 'monument', 'convenience', 'museum']),
    geom: randomEastBankPoint(),
    opts: { accessibility: { ferry_gap: true } },
  });
}

// ---- 3) 黑名单 30 ----
for (let i = 0; i < 8; i++) addPoi({ // 种子期直接标记
  category: 'cemetery', geom: randomPointInDisc(),
  opts: { blacklisted: true, blacklist_reason: 'rule:blacklist_category:cemetery (pre-applied)' },
});
for (let i = 0; i < 6; i++) addPoi({
  category: 'highway', geom: randomPointInDisc(),
  opts: { blacklisted: true, blacklist_reason: 'rule:blacklist_category:highway (pre-applied)' },
});
for (let i = 0; i < 8; i++) addPoi({ // 不预标记 → 由 fn_refresh_blacklist() 依规则热更新标记
  category: 'construction', geom: randomPointInDisc(),
});
for (let i = 0; i < 4; i++) addPoi({ // accessibility 预计算联动
  category: 'park', geom: randomPointInDisc(),
  opts: { accessibility: { island: true } },
});
for (let i = 0; i < 4; i++) addPoi({
  category: 'monument', geom: randomPointInDisc(),
  opts: { accessibility: { rail_within_50m: true } },
});

// ---- 4) auto 待审核 20（审核队列演示） ----
for (let i = 0; i < 20; i++) {
  addPoi({
    category: pick(['park', 'plaza', 'convenience', 'monument']),
    geom: randomPointInDisc(),
    opts: { source: 'auto', status: 'auto' },
  });
}

// ---- 5) 抵达率低 20（10 retired + 10 active-but-hidden） ----
for (let i = 0; i < 10; i++) {
  addPoi({
    category: pick(['park', 'shrine', 'landmark_stone']),
    geom: randomPointInDisc(),
    opts: { status: 'retired', arrive_rate: +(0.35 + rng() * 0.2).toFixed(2) },
  });
}
for (let i = 0; i < 10; i++) {
  addPoi({
    category: pick(['monument', 'landmark_stone']),
    geom: randomPointInDisc(),
    opts: { arrive_rate: +(0.45 + rng() * 0.14).toFixed(2) }, // <0.6 → v_poi_active 隐藏
  });
}

// ---------- 输出 SQL ----------
const esc = (s) => String(s).replace(/'/g, "''");
const sqlHeader = `-- WalkBox 种子 POI（由 gen_seed_pois.mjs 生成, PRNG seed=${SEED}, 共 ${rows.length} 条）
-- 幂等: ON CONFLICT (source_ref) DO NOTHING
BEGIN;

-- 安全规则: blacklist_category（construction 依赖 fn_refresh_blacklist() 热更新应用）
INSERT INTO poi_safety_rule (city_code, rule_type, config, version, enabled) VALUES
  ('*', 'blacklist_category', '{"categories":["cemetery","highway","construction"]}'::jsonb, 1, true),
  ('*', 'night_allow',        '{"note":"22:00-05:00 仅 open_24h 类别, 见 fn_match_candidates"}'::jsonb, 1, true),
  ('*', 'detour_factor',      '{"urban":1.35,"suburb":1.25,"rural":1.2}'::jsonb, 1, true)
ON CONFLICT DO NOTHING;
`;

// 逐行完整 INSERT（可读性优先, 500 行规模无需多值合并）
const sqlInserts = rows.map((r) => {
  const acc = Object.keys(r.accessibility).length ? `'${esc(JSON.stringify(r.accessibility))}'::jsonb` : `'{}'::jsonb`;
  const reason = r.blacklist_reason ? `'${esc(r.blacklist_reason)}'` : 'NULL';
  return `INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(${r.lng.toFixed(6)}, ${r.lat.toFixed(6)}), 4326),
  '${esc(r.name)}', '${esc(r.name_local)}', '${r.category}', '${esc(r.description)}', '{}'::text[],
  '${r.source}', '${esc(r.source_ref)}',
  ${r.editor_score}, ${r.safety_score}, ${acc}, ${r.fence_radius_m}, '${r.status}', ${r.open_24h},
  ${r.blacklisted}, ${reason}, ${r.visit_count_90d}, ${r.arrive_rate})
ON CONFLICT (source_ref) DO NOTHING;`;
}).join('\n');

const sqlFooter = `
-- 应用黑名单规则（幂等）: 会把 construction 类与 island/rail 标记的 POI 刷成 blacklisted=true
SELECT fn_refresh_blacklist() AS blacklist_refreshed;

-- 校验汇总
SELECT count(*)                                        AS total_pois        FROM poi
UNION ALL SELECT count(*)                              FROM poi WHERE blacklisted
UNION ALL SELECT count(*)                              FROM v_poi_active
UNION ALL SELECT count(*)                              FROM poi WHERE status = 'auto';

COMMIT;
`;

const sql = `${sqlHeader}\n${sqlInserts}\n${sqlFooter}\n`;

// ---------- 输出 CSV ----------
const csvCols = ['source_ref', 'lat', 'lng', 'name', 'name_local', 'category', 'description',
  'source', 'editor_score', 'safety_score', 'accessibility', 'fence_radius_m', 'status',
  'open_24h', 'blacklisted', 'blacklist_reason', 'visit_count_90d', 'arrive_rate'];
const csvEsc = (v) => {
  const s = v === null || v === undefined ? '' : String(v);
  return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
};
const csv = [
  csvCols.join(','),
  ...rows.map((r) => [
    r.source_ref, r.lat, r.lng, r.name, r.name_local, r.category, r.description,
    r.source, r.editor_score, r.safety_score, JSON.stringify(r.accessibility), r.fence_radius_m,
    r.status, r.open_24h, r.blacklisted, r.blacklist_reason ?? '', r.visit_count_90d, r.arrive_rate,
  ].map(csvEsc).join(',')),
].join('\n') + '\n';

// ---------- 写文件 ----------
mkdirSync(HERE, { recursive: true });
writeFileSync(join(HERE, 'seed_pois.sql'), sql, 'utf8');
writeFileSync(join(HERE, 'seed_pois.csv'), csv, 'utf8');

const byStatus = rows.reduce((m, r) => ((m[r.status] = (m[r.status] ?? 0) + 1), m), {});
console.log(`✔ 生成 ${rows.length} 条种子 POI (seed=${SEED})`);
console.log('  状态分布:', JSON.stringify(byStatus));
console.log('  黑名单(预标记):', rows.filter((r) => r.blacklisted).length,
    '| ferry_gap:', rows.filter((r) => r.accessibility.ferry_gap).length,
    '| arrive_rate<0.6:', rows.filter((r) => r.arrive_rate < 0.6).length);
console.log(`  → ${join(HERE, 'seed_pois.sql')}`);
console.log(`  → ${join(HERE, 'seed_pois.csv')}`);
