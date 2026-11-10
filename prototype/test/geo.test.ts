// TRD 需求覆盖: NAV-02(距离显示), 2.1(加密下发/往返), 地理数学基线
import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  haversineMeters, initialBearing, destinationPoint, formatDistance,
  encryptDest, decryptDest,
} from '../src/geo.ts';

test('haversine: 赤道 1° 经距 ≈ 111.19 km（R=6371008.8 基线）', () => {
  const d = haversineMeters({ lat: 0, lng: 0 }, { lat: 0, lng: 1 });
  assert.ok(Math.abs(d - 111_195) < 500, `actual=${d}`);
});

test('haversine: 北京→上海直线 ≈ 1068 km（城市级基线）', () => {
  const d = haversineMeters({ lat: 39.9042, lng: 116.4074 }, { lat: 31.2304, lng: 121.4737 });
  assert.ok(Math.abs(d - 1_068_000) < 5_000, `actual=${d}`);
});

test('initialBearing: 四个基本方位 [NAV-01]', () => {
  const from = { lat: 0, lng: 0 };
  assert.ok(Math.abs(initialBearing(from, { lat: 1, lng: 0 })) < 0.01);      // 北 → 0°
  assert.ok(Math.abs(initialBearing(from, { lat: 0, lng: 1 }) - 90) < 0.01); // 东 → 90°
  assert.ok(Math.abs(initialBearing(from, { lat: -1, lng: 0 }) - 180) < 0.01);
  assert.ok(Math.abs(initialBearing(from, { lat: 0, lng: -1 }) - 270) < 0.01);
});

test('destinationPoint: 距离/方位往返一致（步行尺度）', () => {
  const start = { lat: 31.2304, lng: 121.4737 };
  for (const [bearing, dist] of [[187, 1500], [45, 8300], [0, 300]] as const) {
    const p = destinationPoint(start, bearing, dist);
    const back = haversineMeters(start, p);
    assert.ok(Math.abs(back - dist) < 1, `bearing=${bearing} dist err=${back - dist}`);
    assert.ok(Math.abs(initialBearing(start, p) - bearing) < 0.01);
  }
});

test('formatDistance: NAV-02 显示规范（<1km 米 / ≥1km 0.1km 粒度）', () => {
  assert.equal(formatDistance(850), '850 m');
  assert.equal(formatDistance(999), '999 m');
  assert.equal(formatDistance(1000), '1.0 km');
  assert.equal(formatDistance(1234), '1.2 km');
  assert.equal(formatDistance(17_300), '17.3 km');
});

test('目的地加密: 加解密往返 + 篡改拒绝 [TRD 2.1 输出约束/V1 加密下发]', () => {
  const dest = { lat: 31.2345, lng: 121.4987 };
  const enc = encryptDest(dest);
  const dec = decryptDest(enc);
  assert.deepEqual(dec, dest);
  // 篡改 1 字节 → GCM 认证失败
  const tampered = { ...enc, payload: Buffer.from(enc.payload) };
  tampered.payload[0] ^= 0xff;
  assert.throws(() => decryptDest(tampered));
  // 密钥不符 → 认证失败
  assert.throws(() => decryptDest(enc, 'wrong-secret'));
});
