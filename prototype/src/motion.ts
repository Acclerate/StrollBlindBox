// ============================================================
// WalkBox 原型 · 有效移动判定（TRD NAV-06 防作弊/防误判）
//   0.5–12 km/h  → 有效步行, 计步
//   12–30 km/h   → 可疑(骑行/慢跑混杂), 不计步不判乘车
//   > 30 km/h    → 乘车, 不计步, 抵达不触发揭晓
// ============================================================

export type MotionClass = 'stationary' | 'walking' | 'suspicious' | 'vehicle';

export const WALK_MIN_KMH = 0.5;
export const WALK_MAX_KMH = 12;
export const VEHICLE_KMH = 30;

/** 速度分类（输入 km/h） */
export function classifySpeed(kmh: number): MotionClass {
  if (kmh < 0) throw new RangeError('speed must be >= 0');
  if (kmh < WALK_MIN_KMH) return 'stationary';
  if (kmh <= WALK_MAX_KMH) return 'walking';
  if (kmh <= VEHICLE_KMH) return 'suspicious';
  return 'vehicle';
}

/**
 * 步数累计器: 仅步行区间内的传感器步数增量计入会话 steps。
 * 乘车/可疑区间到来的增量被丢弃（防公交颠簸被计成步数）。
 */
export class StepCounter {
  private countedSteps = 0;

  update(speedKmh: number, sensorStepDelta: number): { countedDelta: number; motion: MotionClass } {
    const motion = classifySpeed(speedKmh);
    if (motion !== 'walking' || sensorStepDelta < 0) return { countedDelta: 0, motion };
    this.countedSteps += sensorStepDelta;
    return { countedDelta: sensorStepDelta, motion };
  }

  get steps(): number { return this.countedSteps; }
}
