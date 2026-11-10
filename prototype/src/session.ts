// ============================================================
// WalkBox 原型 · 会话快照与恢复（TRD NAV-05 / 1.1 客户端可离线闭环）
//   - 快照原子写（tmp + rename）: 杀进程/崩溃不产生半写文件
//   - 目的地在快照中保持加密态（服务端加密下发, 端上不解密存储）
//   - 补传队列: 每 60s 或 10 点批量上传轨迹（TRD 2.3）
// ============================================================

import { mkdirSync, readFileSync, renameSync, rmSync, writeFileSync, existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import type { GpsFix } from './geofence.ts';
import type { EncryptedDest } from './geo.ts';
import { encryptDest, decryptDest } from './geo.ts';
import type { LatLng, MatchMode, SessionStatus } from './types.ts';

export interface SessionSnapshot {
  sessionId: string;
  mode: MatchMode;
  status: SessionStatus;
  startedAtMs: number;
  targetKm: number;
  /** 目的地密文（不解密持久化; 抵达后服务端校验揭晓） */
  destEncrypted: { payloadB64: string; nonceB64: string };
  destHintBearing: number;
  destHintDistanceM: number;
  poiId: number;
  steps: number;
  distanceWalkedM: number;
  rulesVersion: number;
  /** 尚未成功上传的轨迹点（离线补传队列） */
  pendingTrack: GpsFix[];
}

export interface UploadBatch { points: GpsFix[]; uploadedAtMs: number }

const BATCH_MIN_INTERVAL_MS = 60_000;
const BATCH_MIN_POINTS = 10;

/** 快照存储: 单文件 JSON, 原子写 */
export class SessionStore {
  private readonly file: string;

  constructor(file = join(process.cwd(), '.walkbox', 'session.json')) {
    this.file = file;
    mkdirSync(dirname(this.file), { recursive: true });
  }

  save(snap: SessionSnapshot): void {
    const tmp = `${this.file}.tmp`;
    writeFileSync(tmp, JSON.stringify(snap), 'utf8');
    renameSync(tmp, this.file); // 原子替换
  }

  restore(): SessionSnapshot | null {
    try {
      if (!existsSync(this.file)) return null;
      return JSON.parse(readFileSync(this.file, 'utf8')) as SessionSnapshot;
    } catch {
      return null; // 半写/损坏文件(理论上原子写后不应出现) → 视为无可恢复会话
    }
  }

  clear(): void {
    rmSync(this.file, { force: true });
  }
}

/** 补传队列: 批量条件 = 距上次上传≥60s 且 ≥10 点; flush 模拟网络恢复后的批量上传 */
export class TrackUploadQueue {
  private lastUploadMs = 0;
  private queue: GpsFix[] = [];
  private readonly upload: (batch: UploadBatch) => Promise<void> | void;

  /** 上传回调（真实实现: POST /v1/sessions/{id}/arrive 附轨迹摘要 / 轨迹批量接口） */
  constructor(upload: (batch: UploadBatch) => Promise<void> | void) {
    this.upload = upload;
  }

  enqueue(fix: GpsFix): void { this.queue.push(fix); }

  /** 返回 true 表示本次触发了批量上传（TRD 2.3: 每 60s 或满 10 点, 先到先传） */
  maybeFlush(nowMs: number): boolean {
    const intervalDue = nowMs - this.lastUploadMs >= BATCH_MIN_INTERVAL_MS && this.queue.length > 0;
    const pointsDue = this.queue.length >= BATCH_MIN_POINTS;
    return intervalDue || pointsDue ? this.flush(nowMs) : false;
  }

  flush(nowMs = Date.now()): boolean {
    if (this.queue.length === 0) return false;
    const batch = { points: this.queue.splice(0), uploadedAtMs: nowMs };
    this.lastUploadMs = nowMs;
    void this.upload(batch);
    return true;
  }

  get pendingCount(): number { return this.queue.length; }
}

/** 快照中目的地的加解密封装（服务端视角: 只有校验通过才解密揭晓） */
export const DestCodec = {
  encrypt(dest: LatLng) {
    const { payload, nonce } = encryptDest(dest);
    return { payloadB64: payload.toString('base64'), nonceB64: nonce.toString('base64') };
  },
  decrypt(snap: SessionSnapshot): LatLng {
    return decryptDest({
      payload: Buffer.from(snap.destEncrypted.payloadB64, 'base64'),
      nonce: Buffer.from(snap.destEncrypted.nonceB64, 'base64'),
    });
  },
};
