// 服务端 e2e：开盒 → 伪轨迹步行 → 抵达校验揭晓 → 图鉴 → reroll/quit/限流路径
// 运行: node server/src/e2e.ts
import assert from 'node:assert/strict';
import { startServer } from './index.ts';
import { InMemoryPoiSource, loadSeedPois } from '../../prototype/src/poiSource.ts';
import { destinationPoint, haversineMeters, initialBearing } from '../../prototype/src/geo.ts';

const DEVICE = 'e2e-device-0001';

async function main() {
  const server = startServer({ port: 0, host: '127.0.0.1', poiSource: new InMemoryPoiSource(loadSeedPois()) });
  await new Promise<void>((r) => server.once('listening', r));
  const port = (server.address() as { port: number }).port;
  const base = `http://127.0.0.1:${port}`;
  const api = (path: string, init?: RequestInit) =>
    fetch(base + path, { ...init, headers: { 'Content-Type': 'application/json', 'X-Device-Id': DEVICE, ...(init?.headers ?? {}) } });

  // 1. 鉴权
  const noAuth = await fetch(base + '/v1/records');
  assert.equal(noAuth.status, 401, '缺 X-Device-Id 应 401');

  // 2. 开盒
  const start = { lat: 31.2304, lng: 121.4737 };
  const opened = await api('/v1/sessions', {
    method: 'POST', body: JSON.stringify({ ...start, distance_km: 2, mode: 'normal', local_hour: 14 }),
  });
  assert.equal(opened.status, 201);
  const box = await opened.json() as { session_id: string; bearing: number; distance_m: number; dest: { lat: number; lng: number }; fence_radius_m: number };
  assert.ok(box.dest && typeof box.dest.lat === 'number', 'MVP 坐标下发');
  assert.ok(!JSON.stringify(box).includes('name'), '开盒响应不得包含目的地名称');
  console.log('✔ 开盒:', box.bearing, '°', box.distance_m, 'm, fence', box.fence_radius_m);

  // 3. 伪轨迹: 沿方位角推进至围栏内(每点带 GPS 噪声可省, 直接落点)
  const bearing = initialBearing(start, box.dest);
  const total = haversineMeters(start, box.dest);
  const track: Array<{ lat: number; lng: number; accuracy_m: number; speed_mps: number; ts: number; steps: number }> = [];
  for (let d = 0; d <= total - 10; d += Math.min(60, Math.max(20, (total - 10) / 25))) {
    const p = destinationPoint(start, bearing, d);
    track.push({ lat: p.lat, lng: p.lng, accuracy_m: 10, speed_mps: 1.3, ts: Date.now() - (total - d) * 800, steps: Math.round(d / 0.7) });
  }
  // 末端 2 点落入围栏内
  for (const off of [10, 5]) {
    const p = destinationPoint(start, bearing, total - off);
    track.push({ lat: p.lat, lng: p.lng, accuracy_m: 8, speed_mps: 1.3, ts: Date.now() - off * 800, steps: Math.round((total - off) / 0.7) });
  }

  // 4. 错误轨迹先试 → 422（服务端二次校验拒收）
  const badTrack = track.slice(0, 3);
  const bad = await api(`/v1/sessions/${box.session_id}/arrive`, {
    method: 'POST', body: JSON.stringify({ track: badTrack, confidence: 0.9, distance_walked_m: 100, steps: 10 }),
  });
  assert.equal(bad.status, 422, '轨迹未达围栏应 422');
  console.log('✔ 抵达校验拦截: 轨迹末端不在围栏 → 422');

  // 5. 正确轨迹 → 200 揭晓（此时才出现名称）
  const arrive = await api(`/v1/sessions/${box.session_id}/arrive`, {
    method: 'POST', body: JSON.stringify({ track, confidence: 0.85, distance_walked_m: total, steps: Math.round(total / 0.7) }),
  });
  assert.equal(arrive.status, 200);
  const revealed = await arrive.json() as { server_verified: boolean; poi: { nameLocal: string; category: string } };
  assert.equal(revealed.server_verified, true);
  assert.ok(revealed.poi.nameLocal.length > 0);
  console.log('✔ 抵达揭晓:', revealed.poi.nameLocal, `(${revealed.poi.category})`);

  // 6. 图鉴
  const rec = await api('/v1/records');
  const records = await rec.json() as { stats: { total_arrivals: number; total_steps: number }; items: unknown[] };
  assert.equal(records.stats.total_arrivals, 1);
  assert.equal(records.items.length, 1);
  console.log('✔ 图鉴:', records.stats);

  // 7. 重复抵达幂等拒绝（会话已 arrived → 404? 不, 会话仍在 map; arrive 应只允许一次）
  const again = await api(`/v1/sessions/${box.session_id}/arrive`, {
    method: 'POST', body: JSON.stringify({ track, confidence: 0.9 }),
  });
  assert.equal(again.status, 422, '已抵达会话不应重复记图鉴(围栏校验虽过但会话终态)——MVP 以 422 拒绝');
  const rec2 = await api('/v1/records');
  assert.equal((await rec2.json() as { stats: { total_arrivals: number } }).stats.total_arrivals, 1, '图鉴不得重复计数');
  console.log('✔ 重复抵达不重复计数');

  // 8. quit
  const q = await api('/v1/sessions', { method: 'POST', body: JSON.stringify({ ...start, distance_km: 1, local_hour: 14 }) });
  const qBox = await q.json() as { session_id: string };
  const quit = await api(`/v1/sessions/${qBox.session_id}/quit`, { method: 'POST', body: '{}' });
  assert.equal(quit.status, 200);
  console.log('✔ quit');

  // 9. reroll 3 次后拒绝
  for (let i = 0; i < 3; i++) {
    const r = await api(`/v1/sessions/${qBox.session_id}/reroll`, {
      method: 'POST', body: JSON.stringify({ ...start, distance_km: 1, local_hour: 14 }),
    });
    assert.equal(r.status, 201, `第${i + 1}次 reroll 应成功`);
  }
  const r4 = await api(`/v1/sessions/${qBox.session_id}/reroll`, {
    method: 'POST', body: JSON.stringify({ ...start, distance_km: 1, local_hour: 14 }),
  });
  assert.equal(r4.status, 429, '第 4 次 reroll 应拒绝');
  console.log('✔ reroll 限流: 3 次后 429');

  // 10. 开盒限流（本设备已用 2 次: 开盒×2; 再 8 次到限, 第 11 次 429）
  for (let i = 0; i < 8; i++) {
    const r = await api('/v1/sessions', { method: 'POST', body: JSON.stringify({ ...start, distance_km: 1, local_hour: 14 }) });
    assert.equal(r.status, 201);
  }
  const over = await api('/v1/sessions', { method: 'POST', body: JSON.stringify({ ...start, distance_km: 1, local_hour: 14 }) });
  assert.equal(over.status, 429, '开盒 10 次/小时后应 429');
  console.log('✔ 开盒限流: 10 次后 429');

  server.close();
  // 清理测试数据（只移除本 e2e 的设备记录, 不动真实数据）
  const { existsSync, readFileSync, writeFileSync } = await import('node:fs');
  const file = new URL('./../data/records.json', import.meta.url);
  if (existsSync(file)) {
    const all = JSON.parse(readFileSync(file, 'utf8')) as Record<string, unknown>;
    delete all[DEVICE];
    writeFileSync(file, JSON.stringify(all, null, 1), 'utf8');
  }
  console.log('\n=== e2e ALL PASS ===');
}

main().catch((e) => { console.error('e2e FAILED:', e); process.exit(1); });
