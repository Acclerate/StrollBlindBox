// WalkBox App · 地理数学核心（与 prototype/src/geo.ts、compass.ts 逐条对齐）
// 纯 Dart, 无平台依赖, 单测覆盖见 test/core_test.dart
import 'dart:math' as math;

class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);

  @override
  bool operator ==(Object other) => other is LatLng && other.lat == lat && other.lng == lng;
  @override
  int get hashCode => Object.hash(lat, lng);
  @override
  String toString() => 'LatLng($lat, $lng)';
}

const double _rEarthM = 6371008.8; // IUGG 平均半径, 与原型一致
double _toRad(double deg) => deg * math.pi / 180;
double _toDeg(double rad) => rad * 180 / math.pi;

/// 两点地表距离（米）— Haversine
double haversineMeters(LatLng a, LatLng b) {
  final dLat = _toRad(b.lat - a.lat);
  final dLng = _toRad(b.lng - a.lng);
  final s = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRad(a.lat)) * math.cos(_toRad(b.lat)) * math.sin(dLng / 2) * math.sin(dLng / 2);
  return 2 * _rEarthM * math.asin(math.min(1, math.sqrt(s)));
}

/// 初始方位角（度, 正北=0, 顺时针 0..360）— NAV-01 目的地侧
double initialBearing(LatLng from, LatLng to) {
  final f1 = _toRad(from.lat), f2 = _toRad(to.lat);
  final dl = _toRad(to.lng - from.lng);
  final y = math.sin(dl) * math.cos(f2);
  final x = math.cos(f1) * math.sin(f2) - math.sin(f1) * math.cos(f2) * math.cos(dl);
  return (_toDeg(math.atan2(y, x)) + 360) % 360;
}

/// 从 from 沿方位角推进 distM（球面近似, 步行尺度足够）
LatLng destinationPoint(LatLng from, double bearingDeg, double distM) {
  final d = distM / _rEarthM;
  final t = _toRad(bearingDeg);
  final f1 = _toRad(from.lat), l1 = _toRad(from.lng);
  final f2 = math.asin(math.sin(f1) * math.cos(d) + math.cos(f1) * math.sin(d) * math.cos(t));
  final l2 = l1 +
      math.atan2(math.sin(t) * math.sin(d) * math.cos(f1), math.cos(d) - math.sin(f1) * math.sin(f2));
  return LatLng(_toDeg(f2), ((_toDeg(l2) + 540) % 360) - 180);
}

/// NAV-02: <1 km 显示米, ≥1 km 显示 0.1 km 粒度
String formatDistance(double m) {
  if (m < 0) throw ArgumentError('distance must be >= 0');
  if (m < 1000) return '${m.round()} m';
  return '${((m / 100).round() / 10).toStringAsFixed(1)} km';
}

/// 圆周差 (a-b) 归一到 (-180,180] — 处理 359°↔1° 跳变
double angularDelta(double a, double b) {
  double d = (a - b) % 360;
  if (d > 180) d -= 360;
  if (d <= -180) d += 360;
  return d;
}

/// 相对转向角（箭头渲染）: bearing = 目标方位角 − 设备航向, 归一到 (-180,180] [NAV-01]
double relativeBearing(double targetBearingDeg, double headingDeg) => angularDelta(targetBearingDeg, headingDeg);

/// NAV-03 降级静态指示: “目标在你 2 点钟方向”
String bearingToClock(double relativeDeg) {
  final normalized = ((relativeDeg % 360) + 360) % 360; // 0=正前, 90=右侧
  final hour = (normalized / 30).round() % 12;
  return '${hour == 0 ? 12 : hour} 点钟方向';
}
