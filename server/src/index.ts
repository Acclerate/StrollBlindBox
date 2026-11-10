// ============================================================
// WalkBox App 后端 API（TRD 四. REST 草图 · MVP 核心闭环子集）
//
//   POST /v1/sessions            开盒（限流 10/h/设备）
//   POST /v1/sessions/:id/arrive 抵达上报（轨迹摘要 → 服务端二次校验 → 揭晓）
//   POST /v1/sessions/:id/quit   放弃
//   POST /v1/sessions/:id/reroll 换盒（限 3 次/日, 重新开盒）
//   GET  /v1/records             图鉴分页（设备维度, JSON 文件持久化）
//   GET  /healthz
//
// 鉴权: X-Device-Id（匿名设备 UUID, TRD 四.）
// 实现复用 prototype/src 的匹配/安全过滤/围栏校验逻辑（逻辑单一事实来源）。
// ============================================================

import { createServer } from 'node:http';
import { randomUUID } from 'node:crypto';
import { mkdirSync, readFileSync, writeFileSync, existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { match, OpenBoxRateLimiter, RerollLimiter } from '../../prototype/src/matcher.ts';
import { InMemoryPoiSource, PostgisPoiSource } from '../../prototype/src/poiSource.ts';
import type { PoiSource } from '../../prototype/src/poiSource.ts';
import { serverVerifyArrival } from '../../prototype/src/geofence.ts';
import type { GpsFix } from '../../prototype/src/geofence.ts';
import type { MatchMode, Poi } from '../../prototype/src/types.ts';

const HERE = dirname(fileURLToPath(import.meta.url));
const DATA_DIR = join(HERE, '..', 'data');
const RECORDS_FILE = join(DATA_DIR, 'records.json');

// ---------- 图鉴持久化（设备维度; MVP 用 JSON 文件, 生产换 PostgreSQL） ----------
interface ArrivalRecord {
  sessionId: string;
  deviceId: string;
  poi: { id: number; name: string; nameLocal: string; category: string; description: string };
  arrivedAt: string;            // ISO(UTC)
  confidence: number;
  distanceWalkedM: number;
  steps: number;
}

function loadRecords(): Map<string, ArrivalRecord[]> {
  try {
    if (!existsSync(RECORDS_FILE)) return new Map();
    const raw = JSON.parse(readFileSync(RECORDS_FILE, 'utf8')) as Record<string, ArrivalRecord[]>;
    return new Map(Object.entries(raw));
  } catch {
    return new Map();
  }
}

// ---------- 服务端会话（内存; 生产存 walk_session 表） ----------
interface ServerSession {
  id: string;
  deviceId: string;
  poi: Poi;
  dest: { lat: number; lng: number };
  targetKm: number;
  mode: MatchMode;
  bearing: number;
  distanceM: number;
  status: 'walking' | 'arrived' | 'quit';
  startedAt: number;
}

export interface ServerOptions {
  port?: number;
  host?: string;
  poiSource?: PoiSource;
}

export function startServer(opts: ServerOptions = {}) {
  const poiSource = opts.poiSource ?? new InMemoryPoiSource();
  const sessions = new Map<string, ServerSession>();
  const records = loadRecords();
  const openBoxLimiter = new OpenBoxRateLimiter();
  const rerollLimiter = new RerollLimiter();

  const saveRecords = () => {
    mkdirSync(DATA_DIR, { recursive: true });
    writeFileSync(RECORDS_FILE, JSON.stringify(Object.fromEntries(records), null, 1), 'utf8');
  };

  const json = (res: import('node:http').ServerResponse, status: number, body: unknown) => {
    const buf = Buffer.from(JSON.stringify(body));
    res.writeHead(status, {
      'Content-Type': 'application/json; charset=utf-8',
      'Content-Length': buf.length,
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'Content-Type, X-Device-Id',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    });
    res.end(buf);
  };

  const visitedOf = (deviceId: string): Set<number> => {
    const list = records.get(deviceId) ?? [];
    const recent = list.filter((r) => Date.now() - Date.parse(r.arrivedAt) < 30 * 24 * 3600_000);
    return new Set(recent.map((r) => r.poi.id));
  };

  /** 开盒（POST /v1/sessions 与 reroll 共用）：MVP 简化方案——坐标下发但端上不展示(TRD 2.1) */
  async function openBox(deviceId: string, body: {
    lat: number; lng: number; distance_km: number; mode?: MatchMode; local_hour?: number;
  }, res: import('node:http').ServerResponse, opts: { consumeQuota: boolean } = { consumeQuota: true }): Promise<void> {
    if (typeof body.lat !== 'number' || typeof body.lng !== 'number') {
      return json(res, 400, { error: 'bad_request', message: 'lat/lng required' });
    }
    // reroll 不消耗开盒配额: 两者是独立限额（reroll 3/日, 开盒 10/时）
    if (opts.consumeQuota && !openBoxLimiter.allow(deviceId)) {
      return json(res, 429, { error: 'rate_limited', message: '开盒过于频繁（10 次/小时）' });
    }
    const mode: MatchMode = body.mode ?? 'normal';
    try {
      const result = await match(poiSource, {
        userId: deviceId,
        center: { lat: body.lat, lng: body.lng },
        distanceKm: body.distance_km,
        mode,
        localHour: body.local_hour ?? 12,
        visitedPoiIds: visitedOf(deviceId),
      });
      const id = randomUUID();
      sessions.set(id, {
        id, deviceId, poi: result.poi,
        dest: { lat: result.poi.lat, lng: result.poi.lng },
        targetKm: body.distance_km, mode,
        bearing: result.bearing, distanceM: result.straightM,
        status: 'walking', startedAt: Date.now(),
      });
      return json(res, 201, {
        session_id: id,
        bearing: Math.round(result.bearing * 10) / 10,
        distance_m: Math.round(result.straightM),
        // MVP 备选方案: 坐标端上存储用于离线导航计算, 但 UI 永不展示(V1 升级为加密下发)
        dest: { lat: result.poi.lat, lng: result.poi.lng },
        fence_radius_m: result.poi.fenceRadiusM,
        poi_hint: '跟着箭头走，别问它是什么',
        rules_version: 1,
        via: result.via,
        candidate_pool: result.candidatePoolSize,
      });
    } catch (err) {
      return json(res, 503, { error: 'no_candidate', message: (err as Error).message });
    }
  }

  const server = createServer(async (req, res) => {
    const url = new URL(req.url ?? '/', 'http://localhost');
    if (req.method === 'OPTIONS') return json(res, 204, {});

    const deviceId = req.headers['x-device-id'];
    if (url.pathname !== '/healthz' && (typeof deviceId !== 'string' || deviceId.length < 8)) {
      return json(res, 401, { error: 'unauthorized', message: '缺少 X-Device-Id' });
    }
    const dev = typeof deviceId === 'string' ? deviceId : '';

    // ---------- GET /healthz ----------
    if (req.method === 'GET' && url.pathname === '/healthz') {
      return json(res, 200, { ok: true, poi_source: poiSource.name, sessions: sessions.size });
    }

    // ---------- POST /v1/sessions ----------
    if (req.method === 'POST' && url.pathname === '/v1/sessions') {
      return openBox(dev, await readJson(req), res);
    }

    // ---------- /v1/sessions/:id/(arrive|quit|reroll) ----------
    const m = url.pathname.match(/^\/v1\/sessions\/([0-9a-f-]{36})\/(arrive|quit|reroll)$/i);
    if (req.method === 'POST' && m) {
      const [, id, action] = m;
      const session = sessions.get(id);
      if (!session) return json(res, 404, { error: 'not_found', message: '会话不存在或已过期' });

      if (action === 'quit') {
        session.status = 'quit';
        return json(res, 200, { session_id: id, status: 'quit', message: '今天就到这里，记录已保存' });
      }

      if (action === 'reroll') {
        if (session.status === 'arrived') return json(res, 422, { error: 'already_arrived', message: '已抵达的会话不能换盒' });
        const rr = rerollLimiter.tryReroll(dev);
        if (!rr.ok) return json(res, 429, { error: 'reroll_limited', message: '换盒每天最多 3 次' });
        session.status = 'quit'; // 旧盒作废
        const body = await readJson(req);
        return openBox(dev, {
          lat: body.lat ?? session.dest.lat, lng: body.lng ?? session.dest.lng,
          distance_km: body.distance_km ?? session.targetKm,
          mode: body.mode ?? session.mode, local_hour: body.local_hour,
        }, res, { consumeQuota: false });
      }

      // arrive: 服务端二次校验（TRD 2.3: 校验通过才点亮图鉴）
      if (session.status !== 'walking') {
        return json(res, 422, { error: 'session_closed', message: `会话已处于 ${session.status} 状态` });
      }
      const body = await readJson(req) as {
        track?: Array<{ lat: number; lng: number; accuracy_m?: number; speed_mps?: number; ts: number; steps?: number }>;
        confidence?: number; distance_walked_m?: number; steps?: number;
      };
      const track: GpsFix[] = (body.track ?? []).map((p) => ({
        lat: p.lat, lng: p.lng,
        accuracyM: p.accuracy_m ?? 10,
        speedMps: p.speed_mps ?? 1.3,
        timestampMs: p.ts,
        stepCount: p.steps,
      }));
      const verified = serverVerifyArrival(track, session.poi);
      if (!verified) {
        return json(res, 422, {
          error: 'verify_failed',
          message: '轨迹末端不在目的地围栏内，本次抵达未通过校验',
        });
      }
      session.status = 'arrived';
      const record: ArrivalRecord = {
        sessionId: id, deviceId: dev,
        poi: {
          id: session.poi.id, name: session.poi.name, nameLocal: session.poi.nameLocal,
          category: session.poi.category, description: session.poi.description,
        },
        arrivedAt: new Date().toISOString(),
        confidence: body.confidence ?? 0.8,
        distanceWalkedM: body.distance_walked_m ?? 0,
        steps: body.steps ?? 0,
      };
      const list = records.get(dev) ?? [];
      list.push(record);
      records.set(dev, list);
      saveRecords();
      return json(res, 200, {
        session_id: id, status: 'arrived', server_verified: true,
        poi: { ...record.poi, fence_radius_m: session.poi.fenceRadiusM },
        arrived_at: record.arrivedAt,
      });
    }

    // ---------- GET /v1/records ----------
    if (req.method === 'GET' && url.pathname === '/v1/records') {
      const list = records.get(dev) ?? [];
      const sinceMs = Date.now() - 30 * 24 * 3600_000;
      const stats = {
        total_arrivals: list.length,
        total_distance_m: Math.round(list.reduce((s, r) => s + r.distanceWalkedM, 0)),
        total_steps: list.reduce((s, r) => s + r.steps, 0),
        categories: list.reduce<Record<string, number>>((acc, r) => {
          acc[r.poi.category] = (acc[r.poi.category] ?? 0) + 1;
          return acc;
        }, {}),
        distinct_30d: new Set(list.filter((r) => Date.parse(r.arrivedAt) > sinceMs).map((r) => r.poi.id)).size,
      };
      const page = Math.max(1, Number(url.searchParams.get('page') ?? 1));
      const size = Math.min(50, Math.max(1, Number(url.searchParams.get('size') ?? 20)));
      const start = (page - 1) * size;
      return json(res, 200, {
        stats,
        page, size, total: list.length,
        items: list.slice().reverse().slice(start, start + size), // 最新在前
      });
    }

    json(res, 404, { error: 'not_found' });
  });

  const port = opts.port ?? 8081;
  const host = opts.host ?? '0.0.0.0';
  server.listen(port, host);
  return server;
}

/** 读 JSON body（限 1MB） */
function readJson(req: import('node:http').IncomingMessage): Promise<Record<string, unknown>> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = [];
    let size = 0;
    req.on('data', (c: Buffer) => {
      size += c.length;
      if (size > 1_048_576) { reject(new Error('payload too large')); req.destroy(); return; }
      chunks.push(c);
    });
    req.on('end', () => {
      try { resolve(chunks.length ? JSON.parse(Buffer.concat(chunks).toString('utf8')) : {}); }
      catch (e) { reject(e); }
    });
    req.on('error', reject);
  });
}

// ---------- 直跑入口: node server/src/index.ts ----------
if (process.argv[1] && import.meta.url === `file:///${process.argv[1].replace(/\\/g, '/')}`) {
  const withDb = process.env.WALKBOX_DB === '1';
  (async () => {
    const source = withDb ? ((await PostgisPoiSource.connect()) ?? new InMemoryPoiSource()) : new InMemoryPoiSource();
    startServer({ poiSource: source });
    console.log(`[walkbox-server] listening :8081 (poi_source=${source.name}${withDb ? ', WALKBOX_DB=1' : ''})`);
  })().catch((e) => { console.error(e); process.exit(1); });
}
