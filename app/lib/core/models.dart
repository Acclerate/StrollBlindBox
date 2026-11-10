// WalkBox App · API 数据模型（对应 server/src/index.ts 响应结构）
import 'geo.dart';

class TrackPoint {
  final double lat;
  final double lng;
  final double accuracyM;
  final double speedMps;
  final int ts; // 毫秒时间戳(UTC)
  final int? steps;

  const TrackPoint({
    required this.lat,
    required this.lng,
    required this.accuracyM,
    required this.speedMps,
    required this.ts,
    this.steps,
  });

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'accuracy_m': accuracyM,
        'speed_mps': speedMps,
        'ts': ts,
        'steps': steps,
      };
}

/// 开盒响应（MVP: 含坐标用于端上离线导航计算, UI 永不展示 — TRD 2.1 备选方案）
class OpenBoxResponse {
  final String sessionId;
  final double bearing;
  final double distanceM;
  final LatLng dest;
  final int fenceRadiusM;
  final String poiHint;
  final String via;
  OpenBoxResponse({
    required this.sessionId,
    required this.bearing,
    required this.distanceM,
    required this.dest,
    required this.fenceRadiusM,
    required this.poiHint,
    required this.via,
  });

  factory OpenBoxResponse.fromJson(Map<String, dynamic> j) => OpenBoxResponse(
        sessionId: j['session_id'] as String,
        bearing: (j['bearing'] as num).toDouble(),
        distanceM: (j['distance_m'] as num).toDouble(),
        dest: LatLng((j['dest']['lat'] as num).toDouble(), (j['dest']['lng'] as num).toDouble()),
        fenceRadiusM: (j['fence_radius_m'] as num).toInt(),
        poiHint: (j['poi_hint'] ?? '跟着箭头走') as String,
        via: (j['via'] ?? 'pool') as String,
      );
}

class RevealedPoi {
  final int id;
  final String name;
  final String nameLocal;
  final String category;
  final String description;

  RevealedPoi({
    required this.id,
    required this.name,
    required this.nameLocal,
    required this.category,
    required this.description,
  });

  factory RevealedPoi.fromJson(Map<String, dynamic> j) => RevealedPoi(
        id: (j['id'] as num).toInt(),
        name: j['name'] as String? ?? '',
        nameLocal: j['name_local'] as String? ?? '',
        category: j['category'] as String? ?? '',
        description: j['description'] as String? ?? '',
      );

  static String categoryEmoji(String category) => switch (category) {
        'park' => '🌳',
        'shrine' => '⛩️',
        'museum' => '🏛️',
        'monument' => '🗿',
        'landmark_stone' => '🪨',
        'public_facility' => '🏫',
        'plaza' => '⛲',
        'convenience' => '🏪',
        _ => '📍',
      };
}

class ArriveResponse {
  final bool serverVerified;
  final RevealedPoi poi;
  final DateTime arrivedAt;
  ArriveResponse({required this.serverVerified, required this.poi, required this.arrivedAt});

  factory ArriveResponse.fromJson(Map<String, dynamic> j) => ArriveResponse(
        serverVerified: j['server_verified'] as bool? ?? false,
        poi: RevealedPoi.fromJson(j['poi'] as Map<String, dynamic>),
        arrivedAt: DateTime.tryParse(j['arrived_at'] as String? ?? '') ?? DateTime.now(),
      );
}

class RecordItem {
  final String sessionId;
  final RevealedPoi poi;
  final DateTime arrivedAt;
  final double confidence;
  final double distanceWalkedM;
  final int steps;

  RecordItem({
    required this.sessionId,
    required this.poi,
    required this.arrivedAt,
    required this.confidence,
    required this.distanceWalkedM,
    required this.steps,
  });

  factory RecordItem.fromJson(Map<String, dynamic> j) => RecordItem(
        sessionId: j['session_id'] as String,
        poi: RevealedPoi.fromJson(j['poi'] as Map<String, dynamic>),
        arrivedAt: DateTime.tryParse(j['arrived_at'] as String) ?? DateTime.now(),
        confidence: ((j['confidence'] as num?) ?? 0).toDouble(),
        distanceWalkedM: ((j['distance_walked_m'] as num?) ?? 0).toDouble(),
        steps: ((j['steps'] as num?) ?? 0).toInt(),
      );
}

class RecordStats {
  final int totalArrivals;
  final int distinct30d;
  final double totalDistanceM;
  final int totalSteps;
  final Map<String, int> categories;
  RecordStats({
    required this.totalArrivals,
    required this.distinct30d,
    required this.totalDistanceM,
    required this.totalSteps,
    required this.categories,
  });

  factory RecordStats.fromJson(Map<String, dynamic> j) => RecordStats(
        totalArrivals: (j['total_arrivals'] as num?)?.toInt() ?? 0,
        distinct30d: (j['distinct_30d'] as num?)?.toInt() ?? 0,
        totalDistanceM: ((j['total_distance_m'] as num?) ?? 0).toDouble(),
        totalSteps: (j['total_steps'] as num?)?.toInt() ?? 0,
        categories: ((j['categories'] as Map<String, dynamic>?) ?? {})
            .map((k, v) => MapEntry(k, (v as num).toInt())),
      );
}

class RecordsResponse {
  final RecordStats stats;
  final List<RecordItem> items;
  RecordsResponse({required this.stats, required this.items});

  factory RecordsResponse.fromJson(Map<String, dynamic> j) => RecordsResponse(
        stats: RecordStats.fromJson(j['stats'] as Map<String, dynamic>),
        items: (j['items'] as List<dynamic>? ?? [])
            .map((e) => RecordItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
