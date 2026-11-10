// ============================================================
// WalkBox 原型 · 地理数学 + 目的地加密
//  - Haversine / 初始方位角 / 按方位角推进（大圆近似）
//  - NAV-02 距离显示格式
//  - 目的地坐标 AES-256-GCM 加密下发（TRD 2.1 输出约束 / 三. dest_geom_encrypted）
// ============================================================

import { createCipheriv, createDecipheriv, createHash, randomBytes } from 'node:crypto';
import type { LatLng } from './types.ts';

const R_EARTH_M = 6371008.8; // IUGG 平均地球半径
const toRad = (deg: number) => (deg * Math.PI) / 180;
const toDeg = (rad: number) => (rad * 180) / Math.PI;

/** 两点地表距离（米）— Haversine */
export function haversineMeters(a: LatLng, b: LatLng): number {
  const dLat = toRad(b.lat - a.lat);
  const dLng = toRad(b.lng - a.lng);
  const s =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(a.lat)) * Math.cos(toRad(b.lat)) * Math.sin(dLng / 2) ** 2;
  return 2 * R_EARTH_M * Math.asin(Math.min(1, Math.sqrt(s)));
}

/** 初始方位角（度, 正北=0, 顺时针 0..360）— NAV-01 bearing 计算的目的地侧 */
export function initialBearing(from: LatLng, to: LatLng): number {
  const φ1 = toRad(from.lat), φ2 = toRad(to.lat);
  const Δλ = toRad(to.lng - from.lng);
  const y = Math.sin(Δλ) * Math.cos(φ2);
  const x = Math.cos(φ1) * Math.sin(φ2) - Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ);
  return (toDeg(Math.atan2(y, x)) + 360) % 360;
}

/** 从 from 沿方位角 bearingDeg 推进 distM（球面近似, 步行尺度误差可忽略） */
export function destinationPoint(from: LatLng, bearingDeg: number, distM: number): LatLng {
  const δ = distM / R_EARTH_M;
  const θ = toRad(bearingDeg);
  const φ1 = toRad(from.lat), λ1 = toRad(from.lng);
  const φ2 = Math.asin(Math.sin(φ1) * Math.cos(δ) + Math.cos(φ1) * Math.sin(δ) * Math.cos(θ));
  const λ2 = λ1 + Math.atan2(Math.sin(θ) * Math.sin(δ) * Math.cos(φ1), Math.cos(δ) - Math.sin(φ1) * Math.sin(φ2));
  return { lat: toDeg(φ2), lng: ((toDeg(λ2) + 540) % 360) - 180 };
}

/** NAV-02: <1 km 显示米(整数), ≥1 km 显示 0.1 km 粒度 */
export function formatDistance(m: number): string {
  if (m < 0) throw new RangeError('distance must be >= 0');
  if (m < 1000) return `${Math.round(m)} m`;
  return `${(Math.round(m / 100) / 10).toFixed(1)} km`;
}

// ============================================================
// 目的地坐标加密（AES-256-GCM）
// MVP 备选方案是"明文端存不暴露 UI"; V1 为加密下发, 原型直接实现 V1 语义:
// 服务端持有密钥加密 → 端上密文持久化(NAV-05 快照) → 抵达后服务端解密校验揭晓。
// ============================================================

const DEV_KEY_MATERIAL = 'walkbox-dev-dest-key'; // 生产: KMS 派生, 按环境注入
const keyFromSecret = (secret: string): Buffer => createHash('sha256').update(secret).digest();

export interface EncryptedDest {
  payload: Buffer; // iv(12) || ciphertext+tag — 与 DB 的 dest_geom_encrypted/dest_nonce 对应时拆开存
  nonce: Buffer;
}

export function encryptDest(dest: LatLng, secret: string = DEV_KEY_MATERIAL): EncryptedDest {
  const key = keyFromSecret(secret);
  const nonce = randomBytes(12);
  const cipher = createCipheriv('aes-256-gcm', key, nonce);
  const plaintext = Buffer.from(JSON.stringify([dest.lat, dest.lng]), 'utf8');
  const payload = Buffer.concat([cipher.update(plaintext), cipher.final(), cipher.getAuthTag()]);
  return { payload, nonce };
}

/** 解密失败(密文被篡改/密钥不符)抛错 — GCM 认证标签保证 */
export function decryptDest(enc: EncryptedDest, secret: string = DEV_KEY_MATERIAL): LatLng {
  const key = keyFromSecret(secret);
  const tag = enc.payload.subarray(enc.payload.length - 16);
  const body = enc.payload.subarray(0, enc.payload.length - 16);
  const decipher = createDecipheriv('aes-256-gcm', key, enc.nonce);
  decipher.setAuthTag(tag);
  const plain = Buffer.concat([decipher.update(body), decipher.final()]).toString('utf8');
  const [lat, lng] = JSON.parse(plain) as [number, number];
  return { lat, lng };
}
