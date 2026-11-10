// WalkBox App · 抵达判定/地理围栏（TRD 2.3, 与 prototype/src/geofence.ts 对齐）
// 客户端触发 + 服务端二次校验; 乘车优先拦截; 置信度融合防隔河/隔栏误判。

import 'geo.dart';
import 'motion.dart';

class GpsFix {
  final LatLng position;
  final double accuracyM; // GPS 水平精度; >50 触发弱信号提示(TRD 定位精度策略)
  final double speedMps;
  final int timestampMs;
  final int? stepCount; // 传感器累计步数(可缺省: 无计步器设备)

  const GpsFix({
    required this.position,
    required this.accuracyM,
    required this.speedMps,
    required this.timestampMs,
    this.stepCount,
  });
}

enum FenceVerdict { idle, approaching, nudge, arrived, vehicle }

class FenceEvent {
  final FenceVerdict verdict;
  final double distanceM;
  final double? confidence;
  FenceEvent(this.verdict, this.distanceM, [this.confidence]);
}

class ConfidenceBreakdown {
  final double gps;
  final double track;
  final double step;
  final double fused;
  const ConfidenceBreakdown(this.gps, this.track, this.step, this.fused);
}

const int trackWindowMs = 60000;
const double _wGps = 0.4, _wTrack = 0.35, _wStep = 0.25;
const double arriveThreshold = 0.8;

class GeofenceEngine {
  final LatLng destination;
  final double fenceRadiusM;
  final List<GpsFix> _track = [];
  bool _arrived = false;

  GeofenceEngine({required this.destination, required this.fenceRadiusM});

  bool get arrived => _arrived;
  List<GpsFix> get track => List.unmodifiable(_track);

  /// 主入口: 每个定位更新调用一次（TRD 2.3 onLocationUpdate）
  FenceEvent onLocationUpdate(GpsFix fix) {
    // 乘车判定优先: 乘车抵达不触发揭晓(TRD NAV-06)
    final kmh = fix.speedMps * 3.6;
    final d = haversineMeters(fix.position, destination);
    if (kmh > vehicleKmh) return FenceEvent(FenceVerdict.vehicle, d);

    if (d <= fenceRadiusM) {
      _track.add(fix);
      final conf = _fuse(fix);
      if (conf.fused >= arriveThreshold && !_arrived) {
        _arrived = true;
        return FenceEvent(FenceVerdict.arrived, d, conf.fused);
      }
      return FenceEvent(FenceVerdict.nudge, d, conf.fused); // “再靠近一点确认”
    }
    _track.add(fix);
    return FenceEvent(d <= fenceRadiusM * 3 ? FenceVerdict.approaching : FenceVerdict.idle, d);
  }

  /// 置信度融合: gps=(50-acc)/45 | track=近60s落在2×围栏内占比 | step=增量>0?1:0.5(无计步器中性)
  ConfidenceBreakdown _fuse(GpsFix fix) {
    _track.removeWhere((f) => fix.timestampMs - f.timestampMs > trackWindowMs);
    final recent = _track;
    final gps = ((50 - fix.accuracyM) / 45).clamp(0.0, 1.0);
    double track = 0.5;
    if (recent.length >= 2) {
      final inside = recent
          .where((f) => haversineMeters(f.position, destination) <= fenceRadiusM * 2)
          .length;
      track = inside / recent.length;
    }
    double step = 0.5;
    if (recent.length >= 2) {
      final first = recent.first.stepCount, last = recent.last.stepCount;
      if (first != null && last != null && last - first > 0) step = 1;
    }
    return ConfidenceBreakdown(gps, track, step, _wGps * gps + _wTrack * track + _wStep * step);
  }

  /// 补传轨迹批量（每 60s 或 10 点, TRD 2.3）
  List<GpsFix> drainTrackBatch({int maxPoints = 10}) {
    if (_track.length < maxPoints) return const [];
    final batch = _track.sublist(0, maxPoints);
    _track.removeRange(0, maxPoints);
    return batch;
  }
}

/// 服务端二次校验镜像: 轨迹末端(≤10点)至少 1 点落在围栏内
/// （真正的权威校验在服务端 fn_verify_arrival / serverVerifyArrival）
bool serverVerifyMirror(List<GpsFix> track, LatLng dest, double fenceM) {
  if (track.isEmpty) return false;
  final tail = track.length <= 10 ? track : track.sublist(track.length - 10);
  return tail.any((f) => haversineMeters(f.position, dest) <= fenceM);
}

/// GPS 漂移检测: 点间速度 > 30km/h 即物理不可能位移
bool isGpsJump(GpsFix? prev, GpsFix cur) {
  if (prev == null) return false;
  final dtSec = ((cur.timestampMs - prev.timestampMs) / 1000).clamp(1, 86400).toDouble();
  return haversineMeters(prev.position, cur.position) / dtSec > 8.34;
}
