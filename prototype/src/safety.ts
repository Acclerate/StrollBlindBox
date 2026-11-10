// ============================================================
// WalkBox 原型 · 安全过滤（TRD 2.6 阻断级 + 2.1 硬过滤的不可达项）
// 规则库可热更新(version), 端上缓存最近一次规则版本作离线兜底。
// ============================================================

import type { Accessibility, ModeConfig, Poi } from './types.ts';

export interface SafetyRuleSet {
  version: number;
  /** 黑名单类别（对应 DB poi_safety_rule.rule_type='blacklist_category'） */
  blacklistCategories: string[];
  /** 夜间允许类别（rule_type='night_allow'） */
  nightAllowedCategories: string[];
  /** 夜间窗口(本地小时, [22,5] 表示 22:00–05:00) */
  nightWindow: [start: number, end: number];
}

export const DEFAULT_RULES: SafetyRuleSet = {
  version: 1,
  blacklistCategories: ['cemetery', 'highway', 'construction'],
  nightAllowedCategories: ['public_facility', 'plaza', 'convenience'],
  nightWindow: [22, 5],
};

/** 本地小时是否落在夜间窗口（支持跨午夜 [22,5]） */
export function isNightHour(localHour: number, window: [number, number] = DEFAULT_RULES.nightWindow): boolean {
  const [start, end] = window;
  return start > end ? localHour >= start || localHour < end : localHour >= start && localHour < end;
}

export type RejectReason =
  | 'blacklisted'            // 规则命中(阻断级)
  | 'blacklist_category'
  | 'not_active'
  | 'low_arrive_rate'        // v_poi_active 清理线 <0.6
  | 'category_not_allowed'   // 模式类别白名单
  | 'low_safety'             // 安全分低于模式阈值(夜间更高)
  | 'night_closed';          // 夜间模式但非 24h/照明类别

export interface Visibility { ok: boolean; reason?: RejectReason }

/**
 * POI 对“当前模式 + 当前本地时间”是否可见。
 * 语义与 DB 侧 v_poi_active + fn_match_candidates 的 WHERE 完全对齐:
 *   status='active' AND NOT blacklisted AND arrive_rate>=0.6
 *   AND category ∈ 模式白名单 AND safety>=minSafety AND (非夜间 OR open_24h)
 */
export function checkVisibility(poi: Poi, mode: ModeConfig, rules: SafetyRuleSet, localHour: number): Visibility {
  if (poi.blacklisted) return { ok: false, reason: 'blacklisted' };
  if (rules.blacklistCategories.includes(poi.category)) return { ok: false, reason: 'blacklist_category' };
  if (poi.status !== 'active') return { ok: false, reason: 'not_active' };
  if (poi.arriveRate < 0.6) return { ok: false, reason: 'low_arrive_rate' };
  if (!mode.allowedCategories.includes(poi.category)) return { ok: false, reason: 'category_not_allowed' };
  if (poi.safetyScore < mode.minSafety) return { ok: false, reason: 'low_safety' };
  const night = mode.night || isNightHour(localHour, rules.nightWindow);
  if (night && !poi.open24h) return { ok: false, reason: 'night_closed' };
  return { ok: true };
}

/** TRD 2.1 硬过滤·不可达: 跨江/封闭园区/孤岛/铁路沿线（accessibility 预计算） */
export function isUnreachable(accessibility: Accessibility): boolean {
  return Boolean(
    accessibility.ferry_gap || accessibility.gated || accessibility.island || accessibility.rail_within_50m,
  );
}

/**
 * TRD 2.6 围栏外校验(端侧简化): 目的地必须落在可步行路网 100m 内。
 * 原型以 accessibility.walk_network_within_100m === false 表达（离线路网预计算产物）;
 * 缺省视为在路网内, 与 DB 侧“预计算标记”语义一致。
 */
export function offWalkNetwork(accessibility: Accessibility): boolean {
  return accessibility.walk_network_within_100m === false;
}
