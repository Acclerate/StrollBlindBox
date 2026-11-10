// ============================================================
// WalkBox 原型 · 核心类型与配置
// 与 db/schema/002_tables.sql 的 poi_category / 模式语义对齐。
// ============================================================

export interface LatLng {
  lat: number;
  lng: number;
}

/** TRD 三. poi.accessibility — 预计算不可达标记 */
export interface Accessibility {
  ferry_gap?: boolean;        // 跨江(无桥/隧道数据)
  gated?: boolean;           // 封闭园区
  island?: boolean;          // 水域孤岛
  rail_within_50m?: boolean; // 铁路沿线 50m
  /** 目的地落在可步行路网 100m 外(TRD 2.6 围栏外校验, 离线预计算产物) */
  walk_network_within_100m?: boolean;
}

export type PoiStatus = 'auto' | 'active' | 'banned' | 'retired';

export interface Poi {
  id: number;
  lat: number;
  lng: number;
  name: string;
  nameLocal: string;
  category: string;
  description: string;
  source: 'seed' | 'auto' | 'manual';
  editorScore: number;       // 1..5
  safetyScore: number;       // 0..100
  accessibility: Accessibility;
  fenceRadiusM: number;      // 10..200, 默认 30
  status: PoiStatus;
  open24h: boolean;
  blacklisted: boolean;
  visitCount90d: number;
  arriveRate: number;        // <0.6 不可见（v_poi_active 清理线）
  /** 稀有类别加成（DB: poi_category.surprise_boost），如石碑/秘境类 1.8 */
  surpriseBoost: number;
}

/** 候选 = POI + 距查询点直线距离 */
export interface CandidatePoi extends Poi {
  distM: number;
}

// ---------- 类别词典（镜像 poi_category 表, 单一事实来源在 DB, 此处为端侧镜像） ----------
export const CATEGORY_DICT: Record<string, { nightAllowed: boolean; surpriseBoost: number; fenceM: number }> = {
  park:            { nightAllowed: false, surpriseBoost: 1.0, fenceM: 60 },
  shrine:          { nightAllowed: false, surpriseBoost: 1.6, fenceM: 30 },
  museum:          { nightAllowed: false, surpriseBoost: 1.2, fenceM: 30 },
  monument:        { nightAllowed: false, surpriseBoost: 1.4, fenceM: 30 },
  landmark_stone:  { nightAllowed: false, surpriseBoost: 1.8, fenceM: 20 },
  public_facility: { nightAllowed: true,  surpriseBoost: 1.0, fenceM: 30 },
  plaza:           { nightAllowed: true,  surpriseBoost: 1.1, fenceM: 50 },
  convenience:     { nightAllowed: true,  surpriseBoost: 1.0, fenceM: 30 },
  // 黑名单类别（仅用于阻断表达, 不会出现在匹配结果中）
  cemetery:        { nightAllowed: false, surpriseBoost: 1.0, fenceM: 30 },
  highway:         { nightAllowed: false, surpriseBoost: 1.0, fenceM: 30 },
  construction:    { nightAllowed: false, surpriseBoost: 1.0, fenceM: 30 },
};

export const WHITELIST_CATEGORIES = [
  'park', 'shrine', 'museum', 'monument', 'landmark_stone',
  'public_facility', 'plaza', 'convenience',
] as const;

// ---------- 模式配置（TRD 2.1 输入: 普通/海外/夜间） ----------
export interface ModeConfig {
  allowedCategories: readonly string[];
  minSafety: number;
  night: boolean;
  detourFactor: number;      // 路网绕转系数（城市密度, DB: poi_safety_rule detour_factor）
}

export const MODES: Record<'normal' | 'overseas' | 'night', ModeConfig> = {
  normal:   { allowedCategories: WHITELIST_CATEGORIES, minSafety: 60, night: false, detourFactor: 1.35 },
  overseas: { allowedCategories: WHITELIST_CATEGORIES, minSafety: 65, night: false, detourFactor: 1.30 },
  night:    { allowedCategories: ['public_facility', 'plaza', 'convenience'], minSafety: 80, night: true, detourFactor: 1.35 },
};

export type MatchMode = keyof typeof MODES;

// ---------- 会话 ----------
export type SessionStatus = 'walking' | 'arrived' | 'quit' | 'expired';

/** 开盒响应（TRD 四. POST /v1/sessions）— 不含目的地名称/坐标 */
export interface OpenBoxResponse {
  sessionId: string;
  bearing: number;         // 目的地方位角(度, 正北=0, 顺时针)
  distanceM: number;       // 直线距离
  poiHint: string;         // 提示文案, 永不暴露名称
  rulesVersion: number;
}
