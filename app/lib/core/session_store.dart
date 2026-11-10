// WalkBox App · 会话快照（TRD NAV-05 / 1.1 客户端可离线闭环）
// 原子写(temp+rename), 杀进程/重启后 100% 可恢复; 轨迹补传队列随快照持久化。
import 'dart:convert';
import 'dart:io';

import 'geo.dart';
import 'models.dart';

class SessionSnapshot {
  final String sessionId;
  final String mode;
  final double targetKm;
  final LatLng dest; // MVP: 明文坐标用于端上导航计算, UI 永不展示(TRD 备选方案)
  final double fenceRadiusM;
  final double hintBearing;
  final double hintDistanceM;
  final int startedAtMs;

  int steps;
  double distanceWalkedM;
  final List<TrackPoint> pendingTrack; // 未上传轨迹（离线补传队列）

  SessionSnapshot({
    required this.sessionId,
    required this.mode,
    required this.targetKm,
    required this.dest,
    required this.fenceRadiusM,
    required this.hintBearing,
    required this.hintDistanceM,
    required this.startedAtMs,
    this.steps = 0,
    this.distanceWalkedM = 0,
    List<TrackPoint>? pendingTrack,
  }) : pendingTrack = pendingTrack ?? [];

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'mode': mode,
        'target_km': targetKm,
        'dest': {'lat': dest.lat, 'lng': dest.lng},
        'fence_radius_m': fenceRadiusM,
        'hint_bearing': hintBearing,
        'hint_distance_m': hintDistanceM,
        'started_at_ms': startedAtMs,
        'steps': steps,
        'distance_walked_m': distanceWalkedM,
        'pending_track': pendingTrack.map((t) => t.toJson()).toList(),
      };

  factory SessionSnapshot.fromJson(Map<String, dynamic> j) => SessionSnapshot(
        sessionId: j['session_id'] as String,
        mode: j['mode'] as String,
        targetKm: (j['target_km'] as num).toDouble(),
        dest: LatLng((j['dest']['lat'] as num).toDouble(), (j['dest']['lng'] as num).toDouble()),
        fenceRadiusM: (j['fence_radius_m'] as num).toDouble(),
        hintBearing: (j['hint_bearing'] as num).toDouble(),
        hintDistanceM: (j['hint_distance_m'] as num).toDouble(),
        startedAtMs: (j['started_at_ms'] as num).toInt(),
        steps: ((j['steps'] as num?) ?? 0).toInt(),
        distanceWalkedM: ((j['distance_walked_m'] as num?) ?? 0).toDouble(),
        pendingTrack: ((j['pending_track'] as List<dynamic>?) ?? [])
            .map((e) => TrackPoint(
                  lat: (e['lat'] as num).toDouble(),
                  lng: (e['lng'] as num).toDouble(),
                  accuracyM: ((e['accuracy_m'] as num?) ?? 10).toDouble(),
                  speedMps: ((e['speed_mps'] as num?) ?? 0).toDouble(),
                  ts: (e['ts'] as num).toInt(),
                  steps: e['steps'] as int?,
                ))
            .toList(),
      );
}

class SessionStore {
  final File _file;
  final File _tmp;

  SessionStore(String dir)
      : _file = File('$dir${Platform.pathSeparator}session.json'),
        _tmp = File('$dir${Platform.pathSeparator}session.json.tmp');

  /// 原子写: tmp 写入 + rename（Android 上 rename 不覆盖, 先删目标再改名）
  Future<void> save(SessionSnapshot snap) async {
    await _tmp.writeAsString(jsonEncode(snap.toJson()), flush: true);
    if (await _file.exists()) await _file.delete();
    await _tmp.rename(_file.path);
  }

  Future<SessionSnapshot?> restore() async {
    try {
      if (!await _file.exists()) return null;
      return SessionSnapshot.fromJson(jsonDecode(await _file.readAsString()) as Map<String, dynamic>);
    } catch (_) {
      return null; // 损坏文件(理论上原子写后不应出现) → 视为无可恢复会话
    }
  }

  Future<void> clear() async {
    for (final f in [_file, _tmp]) {
      if (await f.exists()) await f.delete();
    }
  }
}

/// 轨迹补传: 每 60s 或满 10 点触发上传（TRD 2.3）
class TrackUploadQueue {
  final Future<void> Function(List<TrackPoint> batch) upload;
  final List<TrackPoint> _queue = [];
  int _lastUploadMs = 0;

  TrackUploadQueue(this.upload);

  void enqueue(TrackPoint p) {
    _queue.add(p);
    _checkFlush(DateTime.now().millisecondsSinceEpoch);
  }

  void _checkFlush(int nowMs) {
    final intervalDue = nowMs - _lastUploadMs >= 60000 && _queue.isNotEmpty;
    final pointsDue = _queue.length >= 10;
    if (intervalDue || pointsDue) flush();
  }

  void flush() {
    if (_queue.isEmpty) return;
    final batch = List<TrackPoint>.from(_queue);
    _queue.clear();
    _lastUploadMs = DateTime.now().millisecondsSinceEpoch;
    upload(batch).catchError((Object e) {
      _queue.insertAll(0, batch); // 失败回队, 待下次补传
    });
  }

  int get pendingCount => _queue.length;

  void dispose() => flush();
}
