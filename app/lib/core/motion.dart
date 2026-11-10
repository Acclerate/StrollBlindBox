// WalkBox App · 有效移动判定（TRD NAV-06, 与 prototype/src/motion.ts 对齐）
// 0.5–12 km/h 步行计步 / 12–30 可疑 / >30 乘车拦截

enum MotionClass { stationary, walking, suspicious, vehicle }

const double walkMinKmh = 0.5;
const double walkMaxKmh = 12;
const double vehicleKmh = 30;

MotionClass classifySpeed(double kmh) {
  if (kmh < 0) throw ArgumentError('speed must be >= 0');
  if (kmh < walkMinKmh) return MotionClass.stationary;
  if (kmh <= walkMaxKmh) return MotionClass.walking;
  if (kmh <= vehicleKmh) return MotionClass.suspicious;
  return MotionClass.vehicle;
}

/// 步数累计器: 仅步行区间内的传感器增量计入（乘车/可疑段丢弃, 防公交颠簸计步）
class StepCounter {
  int _counted = 0;
  int get steps => _counted;

  /// 返回本次计入的增量
  int update(double speedKmh, int sensorStepDelta) {
    if (classifySpeed(speedKmh) != MotionClass.walking || sensorStepDelta < 0) return 0;
    _counted += sensorStepDelta;
    return sensorStepDelta;
  }

  void reset() => _counted = 0;
}
