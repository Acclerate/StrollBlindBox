// WalkBox App · 后端 API 客户端（TRD 四. 接口; 鉴权 X-Device-Id）
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'geo.dart';
import 'models.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  final String baseUrl;
  final String deviceId;
  final http.Client _http;

  ApiClient({required this.baseUrl, required this.deviceId, http.Client? client})
      : _http = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-Device-Id': deviceId,
      };

  Future<Map<String, dynamic>> _post(String path, Object? body) async {
    final res = await _http
        .post(Uri.parse('$baseUrl$path'), headers: _headers, body: jsonEncode(body ?? {}))
        .timeout(const Duration(seconds: 20));
    return _decode(res);
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final res = await _http.get(Uri.parse('$baseUrl$path'), headers: _headers)
        .timeout(const Duration(seconds: 20));
    return _decode(res);
  }

  Map<String, dynamic> _decode(http.Response res) {
    final Map<String, dynamic> j =
        res.body.isEmpty ? <String, dynamic>{} : jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400) {
      throw ApiException(res.statusCode, (j['message'] ?? j['error'] ?? 'HTTP ${res.statusCode}') as String);
    }
    return j;
  }

  /// 开盒: POST /v1/sessions
  Future<OpenBoxResponse> openBox({
    required LatLng at,
    required double distanceKm,
    String mode = 'normal',
    required int localHour,
  }) async {
    final j = await _post('/v1/sessions', {
      'lat': at.lat,
      'lng': at.lng,
      'distance_km': distanceKm,
      'mode': mode,
      'local_hour': localHour,
    });
    return OpenBoxResponse.fromJson(j);
  }

  /// 抵达上报: POST /v1/sessions/:id/arrive（服务端二次校验通过才返回揭晓内容）
  Future<ArriveResponse> arrive(
    String sessionId, {
    required List<TrackPoint> track,
    required double confidence,
    required double distanceWalkedM,
    required int steps,
  }) async {
    final j = await _post('/v1/sessions/$sessionId/arrive', {
      'track': track.map((t) => t.toJson()).toList(),
      'confidence': confidence,
      'distance_walked_m': distanceWalkedM,
      'steps': steps,
    });
    return ArriveResponse.fromJson(j);
  }

  /// 放弃: POST /v1/sessions/:id/quit
  Future<void> quit(String sessionId) => _post('/v1/sessions/$sessionId/quit', {});

  /// 换盒: POST /v1/sessions/:id/reroll（限 3 次/日）
  Future<OpenBoxResponse> reroll(
    String sessionId, {
    required LatLng at,
    required double distanceKm,
    String mode = 'normal',
    required int localHour,
  }) async {
    final j = await _post('/v1/sessions/$sessionId/reroll', {
      'lat': at.lat,
      'lng': at.lng,
      'distance_km': distanceKm,
      'mode': mode,
      'local_hour': localHour,
    });
    return OpenBoxResponse.fromJson(j);
  }

  /// 图鉴: GET /v1/records
  Future<RecordsResponse> records({int page = 1, int size = 50}) async {
    final j = await _get('/v1/records?page=$page&size=$size');
    return RecordsResponse.fromJson(j);
  }

  void dispose() => _http.close();
}
