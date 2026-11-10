// ============================================================
// WalkBox 原型 · 盲盒匹配服务（TRD 2.1 核心领域）
//
//   match(P, D, mode):
//     1. 候选查询   半径 D*1.2, 安全/类别/夜间过滤（= DB fn_match_candidates）
//     2. 硬过滤     30天去重 / 不可达(accessibility) / 距离修正(直线×绕转系数∈[0.8D,1.3D])
//     3. 加权随机   w = w_cold × w_serp × w_quality
//     4. 兜底       候选空 → Places 抓取 → 同一过滤 → status='auto'
//     5. 输出       会话: 方位角+直线距离（不揭晓名称/坐标, 目的地加密存储）
// ============================================================

import { haversineMeters, initialBearing } from './geo.ts';
import { isUnreachable, offWalkNetwork, DEFAULT_RULES } from './safety.ts';
import type { SafetyRuleSet } from './safety.ts';
import type { CandidatePoi, LatLng, MatchMode, ModeConfig, Poi } from './types.ts';
import { MODES } from './types.ts';
import type { PoiSource } from './poiSource.ts';

export interface MatchRequest {
  userId: string;
  center: LatLng;              // 用户 GPS 坐标 P
  distanceKm: number;          // 设定距离 D (0.5–10)
  mode: MatchMode;
  localHour: number;           // 用户本地小时(0–23), 决定夜间规则
  /** 近 30 天已抵达 POI 集（DB: v_user_visited_30d） */
  visitedPoiIds?: Set<number>;
  rules?: SafetyRuleSet;
  /** 注入随机源以便测试确定性复现 */
  rng?: () => number;
}

export interface MatchWeights { cold: number; serp: number; quality: number; total: number }

export interface MatchResult {
  poi: Poi;
  bearing: number;             // 目的地方位角(度)
  straightM: number;           // 直线距离
  correctedM: number;          // 直线 × 绕转系数
  via: 'pool' | 'fallback';    // 候选池命中 / Places 兜底
  weights?: MatchWeights;
  /** 候选池规模（兜底触发率监控用: 触发率>5% 告警, TRD 五.可观测） */
  candidatePoolSize: number;
}

/** 加权随机抽取（累积权重法） */
export function pickWeighted<T>(items: T[], weightOf: (t: T) => number, rng: () => number): T {
  const weights = items.map(weightOf);
  const total = weights.reduce((s, w) => s + w, 0);
  if (total <= 0) return items[Math.floor(rng() * items.length)];
  let r = rng() * total;
  for (let i = 0; i < items.length; i++) {
    r -= weights[i];
    if (r <= 0) return items[i];
  }
  return items[items.length - 1];
}

/** TRD 2.1 第 3 步权重: 冷门优先 × 稀有加成 × 编辑质量 */
export function weightOf(poi: Poi): MatchWeights {
  const cold = 1 / (1 + poi.visitCount90d);        // 90 天被抵达越多越冷
  const serp = poi.surpriseBoost;                  // 石碑/秘境类 1.8 等
  const quality = poi.editorScore / 5;             // 编辑质量分
  return { cold, serp, quality, total: cold * serp * quality };
}

/** 距离修正窗口: 直线×绕转系数 ∈ [0.8D, 1.3D]（TRD 2.1 硬过滤第 3 条） */
export function inDistanceWindow(straightM: number, targetKm: number, detourFactor: number,
                                 relax = 1): boolean {
  const targetM = targetKm * 1000;
  const corrected = straightM * detourFactor;
  const [lo, hi] = [0.8 * targetM / relax, 1.3 * targetM * relax];
  return corrected >= lo && corrected <= hi;
}

/**
 * 匹配主流程。放空策略: 严格窗口无候选 → relax=1.25 再筛 → 仍无 → 全半径兜底 → Places。
 */
export async function match(source: PoiSource, req: MatchRequest): Promise<MatchResult> {
  if (req.distanceKm < 0.5 || req.distanceKm > 10) {
    throw new RangeError('distanceKm must be within [0.5, 10]');  // TRD 输入约束
  }
  const mode: ModeConfig = MODES[req.mode];
  const rules = req.rules ?? DEFAULT_RULES;
  const rng = req.rng ?? Math.random;

  // 1. 候选查询（上限放宽 20%）
  const candidates = await source.queryCandidates({
    center: req.center, radiusM: req.distanceKm * 1000 * 1.2, mode, rules, localHour: req.localHour,
  });

  // 2. 硬过滤
  const visited = req.visitedPoiIds ?? new Set<number>();
  const hardFiltered = candidates.filter((c) => {
    if (visited.has(c.id)) return false;               // 去重: 近30天
    if (isUnreachable(c.accessibility)) return false;  // 跨江/封闭/孤岛/铁路
    if (offWalkNetwork(c.accessibility)) return false; // 路网 100m 外
    return true;
  });

  // 距离窗口（逐级放宽）
  let pool = hardFiltered.filter((c) => inDistanceWindow(c.distM, req.distanceKm, mode.detourFactor));
  if (pool.length === 0) {
    pool = hardFiltered.filter((c) => inDistanceWindow(c.distM, req.distanceKm, mode.detourFactor, 1.25));
  }
  if (pool.length === 0) pool = hardFiltered; // 最后保底: 半径内全部

  // 3. 加权随机 / 4. 兜底
  if (pool.length > 0) {
    const chosen = pickWeighted(pool, (c) => weightOf(c).total, rng);
    return {
      poi: chosen,
      bearing: initialBearing(req.center, { lat: chosen.lat, lng: chosen.lng }),
      straightM: chosen.distM,
      correctedM: chosen.distM * mode.detourFactor,
      via: 'pool',
      weights: weightOf(chosen),
      candidatePoolSize: candidates.length,
    };
  }

  // 4. Places 兜底: 抓取周边 → 同一过滤链（真实实现会写库 status='auto' 待审核）
  const fetched = await source.fallbackFetchNearby({
    center: req.center, radiusM: 5000, mode, rules, localHour: req.localHour,
  });
  const eligible = fetched
    .filter((p) => !isUnreachable(p.accessibility) && !offWalkNetwork(p.accessibility))
    .map((p) => ({ ...p, distM: haversineMeters(req.center, { lat: p.lat, lng: p.lng }) }));
  if (eligible.length === 0) {
    throw new Error('周边无可匹配目的地（候选池与兜底均为空）');
  }
  const chosen = pickWeighted(eligible, (c) => weightOf(c).total, rng);
  return {
    poi: chosen,
    bearing: initialBearing(req.center, { lat: chosen.lat, lng: chosen.lng }),
    straightM: chosen.distM,
    correctedM: chosen.distM * mode.detourFactor,
    via: 'fallback',
    weights: weightOf(chosen),
    candidatePoolSize: 0,
  };
}

// ============================================================
// 限流与换盒（生产在 Redis; 原型进程内实现, 接口语义一致）
// ============================================================

/** 开盒限流: 10 次/小时/设备（TRD 四.防批量刷 POI 池） */
export class OpenBoxRateLimiter {
  private hits = new Map<string, number[]>();
  private readonly maxPerHour: number;

  constructor(maxPerHour = 10) {
    this.maxPerHour = maxPerHour;
  }
  allow(deviceId: string, nowMs = Date.now()): boolean {
    const win = (this.hits.get(deviceId) ?? []).filter((t) => nowMs - t < 3_600_000);
    if (win.length >= this.maxPerHour) { this.hits.set(deviceId, win); return false; }
    win.push(nowMs);
    this.hits.set(deviceId, win);
    return true;
  }
}

/** 换盒: 限 3 次/日（TRD 四. reroll） */
export class RerollLimiter {
  private used = new Map<string, number>();
  private readonly maxPerDay: number;

  constructor(maxPerDay = 3) {
    this.maxPerDay = maxPerDay;
  }
  tryReroll(sessionKey: string, dayId = new Date().toISOString().slice(0, 10)): { ok: boolean; left: number } {
    const key = `${sessionKey}:${dayId}`;
    const used = this.used.get(key) ?? 0;
    if (used >= this.maxPerDay) return { ok: false, left: 0 };
    this.used.set(key, used + 1);
    return { ok: true, left: this.maxPerDay - used - 1 };
  }
}
