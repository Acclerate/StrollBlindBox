// ============================================================
// WalkBox 原型 · POI 数据源
//   PoiSource        — 候选查询接口（语义 = DB fn_match_candidates）
//   InMemoryPoiSource — 种子 CSV 加载, 内存过滤（默认, 无 DB 依赖）
//   PostgisPoiSource  — DATABASE_URL 时启用, 走真实 ST_DWithin（需可选依赖 pg）
// ============================================================

import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { haversineMeters } from './geo.ts';
import { checkVisibility, DEFAULT_RULES, isNightHour } from './safety.ts';
import type { SafetyRuleSet } from './safety.ts';
import type { CandidatePoi, LatLng, ModeConfig, Poi } from './types.ts';
import { CATEGORY_DICT } from './types.ts';

const HERE = dirname(fileURLToPath(import.meta.url));

export interface CandidateQuery {
  center: LatLng;
  radiusM: number;
  mode: ModeConfig;
  rules?: SafetyRuleSet;
  localHour: number;
}

export interface PoiSource {
  readonly name: string;
  /** 候选查询: 可见性(安全/夜间/状态/抵达率) + 半径过滤, 返回带直线距离 */
  queryCandidates(q: CandidateQuery): Promise<CandidatePoi[]>;
  /** 兜底抓取桩: 模拟 Places API 周边实时抓取(TRD 2.1 第 4 步), 返回待审核 auto POI */
  fallbackFetchNearby(q: CandidateQuery): Promise<Poi[]>;
  /** 释放连接等资源（进程退出前调用, 避免连接悬挂阻塞事件循环） */
  close?(): Promise<void> | void;
}

// ---------- 最小 CSV 解析（支持引号/转义, 无外部依赖） ----------
export function parseCsv(text: string): string[][] {
  const rows: string[][] = [];
  let row: string[] = [];
  let field = '';
  let inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') { field += '"'; i++; }
        else inQuotes = false;
      } else field += c;
    } else if (c === '"') inQuotes = true;
    else if (c === ',') { row.push(field); field = ''; }
    else if (c === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
    else if (c !== '\r') field += c;
  }
  if (field.length || row.length) { row.push(field); rows.push(row); }
  return rows;
}

/** 从 db/seed/seed_pois.csv 加载种子 POI 为 Poi[] */
export function loadSeedPois(csvPath = join(HERE, '..', '..', 'db', 'seed', 'seed_pois.csv')): Poi[] {
  const rows = parseCsv(readFileSync(csvPath, 'utf8'));
  const head = rows.shift() ?? [];
  const idx = (name: string) => head.indexOf(name);
  return rows
    .filter((r) => r.length > 1)
    .map((r, i) => {
      const category = r[idx('category')];
      const dict = CATEGORY_DICT[category] ?? { nightAllowed: false, surpriseBoost: 1.0, fenceM: 30 };
      const accRaw = r[idx('accessibility')];
      const accessibility = accRaw ? (JSON.parse(accRaw || '{}') as Poi['accessibility']) : {};
      // 镜像 DB 侧 fn_refresh_blacklist(): island/铁路沿线的 accessibility 预计算标记 → 黑名单。
      // CSV 落盘的是刷新前状态, 加载时补齐, 保证与 v_poi_active 视图口径一致。
      const unreachableFlag = Boolean(accessibility.island || accessibility.rail_within_50m);
      return {
        id: i + 1,
        lat: Number(r[idx('lat')]),
        lng: Number(r[idx('lng')]),
        name: r[idx('name')],
        nameLocal: r[idx('name_local')],
        category,
        description: r[idx('description')] ?? '',
        source: (r[idx('source')] ?? 'seed') as Poi['source'],
        editorScore: Number(r[idx('editor_score')] ?? 3),
        safetyScore: Number(r[idx('safety_score')] ?? 70),
        accessibility,
        fenceRadiusM: Number(r[idx('fence_radius_m')] ?? 30),
        status: (r[idx('status')] ?? 'active') as Poi['status'],
        open24h: r[idx('open_24h')] === 'true',
        blacklisted: r[idx('blacklisted')] === 'true' || unreachableFlag,
        visitCount90d: Number(r[idx('visit_count_90d')] ?? 0),
        arriveRate: Number(r[idx('arrive_rate')] ?? 1),
        surpriseBoost: dict.surpriseBoost,
      };
    });
}

// ---------- 内存数据源（默认） ----------
export class InMemoryPoiSource implements PoiSource {
  readonly name = 'in-memory(seed)';
  private pois: Poi[];

  constructor(pois?: Poi[]) {
    this.pois = pois ?? loadSeedPois();
  }

  async queryCandidates(q: CandidateQuery): Promise<CandidatePoi[]> {
    const rules = q.rules ?? DEFAULT_RULES;
    const out: CandidatePoi[] = [];
    for (const poi of this.pois) {
      const v = checkVisibility(poi, q.mode, rules, q.localHour);
      if (!v.ok) continue;
      const distM = haversineMeters(q.center, { lat: poi.lat, lng: poi.lng });
      if (distM > q.radiusM) continue;
      out.push({ ...poi, distM });
    }
    return out;
  }

  /** Places 兜底桩: 从库里 status='auto' 的待审核 POI 中取周边样本（真实实现为 Places API 抓取入库） */
  async fallbackFetchNearby(q: CandidateQuery): Promise<Poi[]> {
    return this.pois
      .filter((p) => p.status === 'auto')
      .filter((p) => haversineMeters(q.center, { lat: p.lat, lng: p.lng }) <= 5000)
      .slice(0, 5);
  }

  count(): number { return this.pois.length; }
}

// ---------- PostGIS 数据源（可选, 与 fn_match_candidates 同语义） ----------
interface PgLikeClient {
  query(sql: string, params: unknown[]): Promise<{ rows: Record<string, unknown>[] }>;
  end(): Promise<void> | void;
}

export class PostgisPoiSource implements PoiSource {
  readonly name = 'postgis';
  private client: PgLikeClient;

  constructor(client: PgLikeClient) {
    this.client = client;
  }

  /** 工厂: lazy import pg, 连接失败返回 null（调用方降级 InMemory） */
  static async connect(databaseUrl?: string): Promise<PostgisPoiSource | null> {
    try {
      const mod = (await import('pg')) as unknown as Record<string, unknown> & { Client?: unknown };
      const PG = ((mod.default as Record<string, unknown>) ?? mod) as {
        Client: new (cfg: { connectionString: string }) => PgLikeClient & { connect(): Promise<void> };
      };
      const client = new PG.Client({
        connectionString: databaseUrl ?? process.env.DATABASE_URL ?? 'postgres://walkbox:walkbox_dev@127.0.0.1:54329/walkbox',
      });
      await client.connect();
      return new PostgisPoiSource(client);
    } catch (err) {
      console.warn(`[poiSource] PostGIS 不可用, 降级 in-memory: ${(err as Error).message}`);
      return null;
    }
  }

  async queryCandidates(q: CandidateQuery): Promise<CandidatePoi[]> {
    // 夜间生效与内存源一致: 模式夜间 或 本地时间落入 22:00–05:00
    const night = q.mode.night || isNightHour(q.localHour, (q.rules ?? DEFAULT_RULES).nightWindow);
    const sql = `
      SELECT p.id, ST_Y(p.geom) AS lat, ST_X(p.geom) AS lng, p.name, p.name_local, p.category,
             p.description, p.source, p.editor_score, p.safety_score, p.accessibility,
             p.fence_radius_m, p.status, p.open_24h, p.visit_count_90d, p.arrive_rate,
             c.surprise_boost,
             ST_Distance(p.geog, ST_SetSRID(ST_MakePoint($1,$2),4326)::geography) AS dist_m
      FROM v_poi_active p
      JOIN poi_category c ON c.category = p.category
      WHERE ST_DWithin(p.geog, ST_SetSRID(ST_MakePoint($1,$2),4326)::geography, $3)
        AND p.category = ANY($4)
        AND p.safety_score >= $5
        AND (NOT $6 OR p.open_24h)
      ORDER BY dist_m
      LIMIT 500`;
    const params = [
      q.center.lng, q.center.lat, q.radiusM,
      q.mode.allowedCategories, q.mode.minSafety, night,
    ];
    const { rows } = await this.client.query(sql, params);
    return rows.map((r) => ({
      id: Number(r.id),
      lat: Number(r.lat),
      lng: Number(r.lng),
      name: String(r.name),
      nameLocal: String(r.name_local ?? ''),
      category: String(r.category),
      description: String(r.description ?? ''),
      source: r.source as Poi['source'],
      editorScore: Number(r.editor_score),
      safetyScore: Number(r.safety_score),
      accessibility: (r.accessibility ?? {}) as Poi['accessibility'],
      fenceRadiusM: Number(r.fence_radius_m),
      status: r.status as Poi['status'],
      open24h: Boolean(r.open_24h),
      blacklisted: false, // v_poi_active 已过滤
      visitCount90d: Number(r.visit_count_90d),
      arriveRate: Number(r.arrive_rate),
      surpriseBoost: Number(r.surprise_boost ?? 1),
      distM: Number(r.dist_m),
    }));
  }

  /** 真实实现: Places API 抓取→过滤→写库 status='auto'; 原型取库里 auto 样本 */
  async fallbackFetchNearby(q: CandidateQuery): Promise<Poi[]> {
    const sql = `
      SELECT p.id, ST_Y(p.geom) AS lat, ST_X(p.geom) AS lng, p.name, p.name_local, p.category,
             p.description, p.source, p.editor_score, p.safety_score, p.accessibility,
             p.fence_radius_m, p.status, p.open_24h, p.visit_count_90d, p.arrive_rate,
             1.0 AS surprise_boost
      FROM poi p
      WHERE p.status = 'auto'
        AND ST_DWithin(p.geom::geography, ST_SetSRID(ST_MakePoint($1,$2),4326)::geography, 5000)
      LIMIT 5`;
    const { rows } = await this.client.query(sql, [q.center.lng, q.center.lat]);
    return rows.map((r) => ({
      id: Number(r.id), lat: Number(r.lat), lng: Number(r.lng),
      name: String(r.name), nameLocal: String(r.name_local ?? ''), category: String(r.category),
      description: String(r.description ?? ''), source: 'auto' as const,
      editorScore: Number(r.editor_score), safetyScore: Number(r.safety_score),
      accessibility: (r.accessibility ?? {}) as Poi['accessibility'],
      fenceRadiusM: Number(r.fence_radius_m), status: 'auto' as const,
      open24h: Boolean(r.open_24h), blacklisted: false,
      visitCount90d: Number(r.visit_count_90d), arriveRate: Number(r.arrive_rate),
      surpriseBoost: 1,
    }));
  }

  async close(): Promise<void> {
    await this.client.end();
  }
}
