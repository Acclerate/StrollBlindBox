// ============================================================
// WalkBox 原型 · 端到端闭环演示（TRD ②）
//
//   npm run demo           开盒 → 模拟步行(GPS噪声) → 围栏判定 → 揭晓
//   npm run demo -- --db   同上, POI 源切换为 PostGIS（需库已起并 npm i pg）
//   --night                夜间模式（22:00–05:00 类别过滤演示）
//   --ride                 中途乘车段演示（NAV-06 防作弊: 乘车抵达不揭晓）
//   --reroll               换盒限流演示（3 次/日）
//
// 演示覆盖 TRD 需求: NAV-01/02/03/05/06, 2.1 匹配全流程, 2.3 围栏+置信度+补传,
//                    2.6 安全过滤, 四. 限流, 2.1 输出约束(不提前揭晓)。
// ============================================================

import { randomUUID } from 'node:crypto';
import { destinationPoint, formatDistance, haversineMeters, initialBearing } from './geo.ts';
import { GeofenceEngine, serverVerifyArrival } from './geofence.ts';
import type { GpsFix } from './geofence.ts';
import { match, OpenBoxRateLimiter, RerollLimiter } from './matcher.ts';
import { CompassFuser, relativeBearing, bearingToClock } from './compass.ts';
import { StepCounter } from './motion.ts';
import { InMemoryPoiSource, PostgisPoiSource } from './poiSource.ts';
import type { PoiSource } from './poiSource.ts';
import { DestCodec, SessionStore, TrackUploadQueue } from './session.ts';
import type { SessionSnapshot } from './session.ts';
import { MODES } from './types.ts';
import type { MatchMode } from './types.ts';

// ---------- CLI 参数 ----------
const args = new Set(process.argv.slice(2));
const useDb = args.has('--db');
const nightDemo = args.has('--night');
const rideDemo = args.has('--ride');
const rerollDemo = args.has('--reroll');

// 上海人民广场（与种子数据同圆心）
const USER_START = { lat: 31.2304, lng: 121.4737 };
const TARGET_KM = 2;
const mode: MatchMode = nightDemo ? 'night' : 'normal';
const LOCAL_HOUR = nightDemo ? 23 : 14; // --night 切到夜间时段, 演示 2.6 夜间规则收窄候选

const log = (s: string) => console.log(s);
const hr = (t: string) => log(`\n──── ${t} ${'─'.repeat(Math.max(0, 58 - t.length))}`);

// 确定性随机(演示可复现; 生产端上无此需求)
let seedState = 42;
const demoRng = () => {
  seedState = (seedState * 1664525 + 1013904223) >>> 0;
  return seedState / 4294967296;
};
const gauss = () => {
  const u = Math.max(1e-9, demoRng());
  return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * demoRng());
};

async function main(): Promise<void> {
  hr('① 数据源');
  let source: PoiSource = new InMemoryPoiSource();
  if (useDb) {
    const pg = await PostgisPoiSource.connect();
    if (pg) source = pg;
  }
  log(`POI 数据源: ${source.name}（模式=${mode}, 本地时间=${LOCAL_HOUR}:00 → 夜间规则${nightDemo || [22, 23, 0, 1, 2, 3, 4].includes(LOCAL_HOUR) ? '生效' : '未生效'}）`);

  hr('② 开盒（限流 → 匹配 → 只给方位角+距离）');
  const limiter = new OpenBoxRateLimiter();            // 10 次/小时/设备
  const deviceId = randomUUID();
  if (!limiter.allow(deviceId)) throw new Error('触发开盒限流');
  log(`限流: 通过（${limiter.constructor.name} 10 次/小时/设备, 生产为 Redis）`);

  const result = await match(source, {
    userId: 'demo-user', center: USER_START, distanceKm: TARGET_KM,
    mode, localHour: LOCAL_HOUR, rng: demoRng,
  });
  log(`匹配: via=${result.via} 候选池=${result.candidatePoolSize} 权重{cold=${result.weights!.cold.toFixed(3)}, serp=${result.weights!.serp}, quality=${result.weights!.quality}}`);
  log(`→ 目的地在你 ${result.bearing.toFixed(0)}° 方向, 直线 ${formatDistance(result.straightM)}（路网修正估 ${formatDistance(result.correctedM)}）  [TRD 2.1: 不下发的名称/坐标]`);

  if (rerollDemo) {
    hr('②-b 换盒限流（3 次/日）');
    const rl = new RerollLimiter();
    for (let i = 1; i <= 4; i++) {
      const r = rl.tryReroll('demo-session');
      log(`第 ${i} 次换盒: ${r.ok ? `允许(剩余${r.left}次)` : '拒绝 —— 已达每日上限'}`);
    }
  }

  hr('③ 会话快照（加密目的地, NAV-05）');
  const store = new SessionStore();
  const sessionId = randomUUID();
  const snapshot: SessionSnapshot = {
    sessionId, mode, status: 'walking', startedAtMs: Date.now(), targetKm: TARGET_KM,
    destEncrypted: DestCodec.encrypt({ lat: result.poi.lat, lng: result.poi.lng }),
    destHintBearing: result.bearing, destHintDistanceM: result.straightM,
    poiId: result.poi.id, steps: 0, distanceWalkedM: 0, rulesVersion: 1,
    pendingTrack: [],
  };
  store.save(snapshot);
  log(`快照已原子写入 .walkbox/session.json（目的地为 AES-256-GCM 密文, 端上不解密存储）`);

  // —— 杀进程恢复演示: 直接从快照重建状态（客户端视角, 不知道目的地明文）——
  hr('④ 模拟杀进程 → 快照恢复');
  const restored = store.restore();
  if (!restored) throw new Error('快照恢复失败');
  log(`恢复会话 ${restored.sessionId.slice(0, 8)}… 目的地密文 ${(restored.destEncrypted.payloadB64.length)} chars → 继续走`);
  const dest = DestCodec.decrypt(restored); // 仅服务端/校验路径持有明文; 此处代表校验方
  log(`（服务端视角可解密核验: 距起点 ${formatDistance(haversineMeters(USER_START, dest))}, 方位 ${initialBearing(USER_START, dest).toFixed(0)}°）`);

  hr('⑤ 步行模拟（GPS 噪声 + 罗盘融合 + 围栏引擎 + 补传队列）');
  const compass = new CompassFuser();
  const stepCounter = new StepCounter();
  const uploadQueue = new TrackUploadQueue((b) => log(`  ↑ 补传批量: ${b.points.length} 点轨迹(每60s或10点, TRD 2.3)`));

  let arrived = false;
  let nudgeLogged = 0;
  const fence = new GeofenceEngine(dest, {
    fenceRadiusM: result.poi.fenceRadiusM,
    onArrive: (ev) => { arrived = true; log(`  🎉 围栏触发: 距目的地 ${ev.distanceM.toFixed(0)}m, 置信度 ${ev.confidence!.toFixed(2)} ≥ 0.8`); },
    onNudge: (ev) => {
      if (nudgeLogged++ < 3) log(`  ⚠ 再靠近一点确认（置信度 ${ev.confidence!.toFixed(2)} < 0.8, 防隔河/隔栏误判）`);
    },
    onVehicle: (ev) => log(`  🚌 ${ev.message}`),
  });

  const bearingToDest = initialBearing(USER_START, dest);
  const totalM = haversineMeters(USER_START, dest);
  const WALK_MPS = 1.3; // ~4.7 km/h
  const TICK_MS = 2000, TICK_SEC = TICK_MS / 1000;
  const rideFromRatio = 0.4, rideToRatio = 0.7; // --ride: 40%~70% 路程坐车
  let walkedM = 0, steps = 0, tMs = 0, lastPos = { ...USER_START }, degradedShown = false;
  const trackAll: GpsFix[] = [];

  while (!arrived && walkedM < totalM + 120) {
    const ratio = totalM > 0 ? walkedM / totalM : 0;
    const riding = rideDemo && ratio >= rideFromRatio && ratio < rideToRatio;
    const speedMps = riding ? 11.5 : WALK_MPS;      // 乘车 ~41 km/h

    // 沿大圆推进 + 高斯噪声(σ≈8m); 乘车段噪声更小(道路)
    const move = speedMps * TICK_SEC;
    walkedM += move;
    lastPos = destinationPoint(USER_START, bearingToDest, walkedM);
    const fix: GpsFix = {
      lat: lastPos.lat + gauss() * (riding ? 4 : 8) / 111320,
      lng: lastPos.lng + gauss() * (riding ? 4 : 8) / (111320 * Math.cos((USER_START.lat * Math.PI) / 180)),
      accuracyM: Math.max(5, 10 + Math.abs(gauss()) * 8),
      speedMps,
      timestampMs: tMs += TICK_MS,
      stepCount: steps,
    };
    trackAll.push(fix);

    // 有效移动判定(NAV-06): 仅步行区间计步（步频 ~1.9 步/s）
    const stepInc = riding ? 0 : Math.round(1.9 * TICK_SEC);
    const { motion } = stepCounter.update(speedMps * 3.6, stepInc);
    steps = stepCounter.steps;

    // 罗盘: 行走用磁罗盘(融合后), 乘车段 GPS course 主导
    const heading = compass.update({
      headingDeg: riding ? bearingToDest : bearingToDest + gauss() * 15,
      source: riding ? 'gps-course' : 'magnetometer',
      accuracyDeg: 12, speedKmh: speedMps * 3.6, timestampMs: tMs,
    });
    if (heading.degraded && !degradedShown) {
      degradedShown = true;
      log(`  罗盘降级(NAV-03): 目标在${bearingToClock(relativeBearing(bearingToDest, heading.headingDeg))}(静态指示+校准引导)`);
    }

    // 弱信号降精度提示(TRD 定位精度策略)
    if (fix.accuracyM > 50) log(`  信号弱(精度${fix.accuracyM.toFixed(0)}m): 箭头降精度显示“继续走”`);

    // 围栏判定(乘车优先拦截)
    const ev = fence.onLocationUpdate(fix);
    uploadQueue.enqueue(fix);
    uploadQueue.maybeFlush(tMs);

    if (!riding && (trackAll.length % 20 === 0 || ev.verdict !== 'idle')) {
      const rel = relativeBearing(bearingToDest, heading.headingDeg);
      const arrow = ['⬆', '↗', '➡', '↘', '⬇', '↙', '⬅', '↖'][Math.round(((rel + 360) % 360) / 45) % 8];
      log(`  ${arrow} 走了 ${formatDistance(walkedM)} | 剩余 ${formatDistance(ev.distanceM)} | ${motion} | 步数 ${steps}`);
    }
    if (ev.verdict === 'vehicle' && !rideDemo) throw new Error('异常: 演示未开 --ride 却判乘车');
  }

  hr('⑥ 抵达揭晓（客户端触发 → 服务端二次校验）');
  const verified = serverVerifyArrival(trackAll, result.poi);
  log(`客户端置信度触发 → 服务端校验轨迹末端(≤10点) vs POI 围栏 ${result.poi.fenceRadiusM}m: ${verified ? '✅ 通过' : '❌ 拒绝'}`);
  uploadQueue.flush();
  log(`补传队列残留: ${uploadQueue.pendingCount} 点`);

  if (verified) {
    // 服务端校验通过才允许解密揭晓(TRD 2.1 输出约束)
    log(`揭晓: 「${result.poi.nameLocal}」(${result.poi.category}) — ${result.poi.description}`);
    log(`实际步行 ${formatDistance(walkedM)} / 设定 ${TARGET_KM} km | 步数 ${steps} | 图鉴点亮 ✨`);
  } else {
    log('揭晓被拒绝: 轨迹校验未通过, 不点亮图鉴');
  }

  hr('⑦ 结束');
  store.clear();
  await source.close?.();
  log(`会话归档, 快照清理。演示完成。${useDb ? '(数据源=postgis)' : '(数据源=in-memory, 试 --db)'}`);
}

main().catch((err) => {
  console.error('演示失败:', err);
  process.exit(1);
});
