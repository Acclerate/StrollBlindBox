// WalkBox App · 全局状态编排（LocatorCore 端上实现, 对应 docs/client-location-design.md §3-§7）
// 传感器流 → 滤波/状态机 → 领域层(围栏/计步/航向), UI 仅订阅本控制器。
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client.dart';
import '../core/fence.dart';
import '../core/geo.dart';
import '../core/models.dart';
import '../core/motion.dart';
import '../core/session_store.dart';

enum AppPhase { idle, opening, navigating, revealing }

enum WalkStatus { walking, vehicle, nudge, weakSignal, noFix, compassDegraded, arrived }

/// 端上"有效移动"状态（NAV-06）
class WalkboxController extends ChangeNotifier {
  // ---- 配置 ----
  String? _deviceId;
  String baseUrl = 'http://10.0.2.2:8081'; // 默认模拟器回环; 真机改成局域网 IP 或 adb reverse
  ApiClient? _api;

  // ---- 会话状态 ----
  AppPhase phase = AppPhase.idle;
  SessionSnapshot? snapshot;
  double distanceKm = 2;
  String mode = 'normal';
  String? error;

  // ---- 导航视图状态 ----
  double? remainingM;
  double arrowDeg = 0; // 相对转向角 (-180..180], UI 箭头旋转角
  String? clockHint;   // NAV-03 降级: “目标在 2 点钟方向”
  int steps = 0;
  double walkedM = 0;
  WalkStatus status = WalkStatus.walking;
  String? nudgeMessage;
  bool vehicleBlocked = false;
  bool loading = false;

  // ---- 揭晓 ----
  ArriveResponse? revealResult;

  // ---- 图鉴 ----
  RecordStats? stats;
  List<RecordItem> records = const [];

  // ---- 内部 ----
  GeofenceEngine? _fence;
  final StepCounter _stepCounter = StepCounter();
  StreamSubscription<Position>? _positionSub;
  StreamSubscription<CompassEvent>? _compassSub;
  StreamSubscription<StepCount>? _stepSub;
  TrackUploadQueue? _uploadQueue;
  SessionStore? _store;
  double _heading = 0;
  double? _lastPedometerSteps;
  int _lastStepCount = 0;
  GpsFix? _lastFix;
  int _lastGoodTs = 0;
  Timer? _noFixWatchdog;
  int _snapshotSaveCounter = 0;
  LatLng? _lastKnownPosition;

  ApiClient get api {
    final d = _deviceId;
    if (d == null) throw StateError('deviceId 未初始化, 先调用 init()');
    return _api ??= ApiClient(baseUrl: baseUrl, deviceId: d);
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('device_id') ??
        '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}_${identityHashCode(this).toRadixString(36)}';
    await prefs.setString('device_id', _deviceId!);
    baseUrl = prefs.getString('base_url') ?? baseUrl;
    final dir = prefs.getString('docs_dir'); // 由 main 注入 path_provider 结果
    if (dir != null) _store = SessionStore(dir);
    await _restoreSnapshot();
    await refreshRecords(notify: false);
    notifyListeners();
  }

  void setDocsDir(String dir) => _store = SessionStore(dir);

  Future<void> setBaseUrl(String url) async {
    baseUrl = url.replaceAll(RegExp(r'/+$'), '');
    _api?.dispose();
    _api = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('base_url', baseUrl);
    notifyListeners();
  }

  /// UI 选择距离/模式（封装修改+通知, 避免 UI 直接触碰 protected notifyListeners）
  void setDistance(double d) {
    distanceKm = d;
    notifyListeners();
  }

  void setMode(String m) {
    mode = m;
    notifyListeners();
  }

  // ============================================================
  // 权限（隐私合规: “仅使用期间”可完整体验）
  // ============================================================
  Future<bool> ensurePermissions() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      error = '需要定位权限才能开始散步（选择“仅使用期间”即可）';
      notifyListeners();
      return false;
    }
    // 计步为可选增强（Android 10+ 活动识别）; 拒绝不影响闭环(置信度步数项取中性 0.5)
    await Permission.activityRecognition.request();
    return true;
  }

  // ============================================================
  // 开盒 / 换盒 / 放弃
  // ============================================================
  Future<void> openBox() async {
    if (!(await ensurePermissions())) return;
    final pos = await getCurrentPosition();
    if (pos == null) return;
    loading = true;
    error = null;
    phase = AppPhase.opening;
    notifyListeners();
    try {
      final box = await api.openBox(
        at: pos,
        distanceKm: distanceKm,
        mode: mode,
        localHour: DateTime.now().hour,
      );
      _startSession(box, walkedM: 0, steps: 0);
    } on ApiException catch (e) {
      error = e.message;
      phase = AppPhase.idle;
    } catch (e) {
      error = '连接服务器失败：$e';
      phase = AppPhase.idle;
    }
    loading = false;
    notifyListeners();
  }

  Future<void> reroll() async {
    final snap = snapshot;
    final pos = _lastKnownPosition;
    if (snap == null || pos == null) return;
    loading = true;
    notifyListeners();
    try {
      final box = await api.reroll(
        snap.sessionId,
        at: pos,
        distanceKm: snap.targetKm,
        mode: snap.mode,
        localHour: DateTime.now().hour,
      );
      _teardownSensors();
      _startSession(box, walkedM: 0, steps: 0);
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = '换盒失败：$e';
    }
    loading = false;
    notifyListeners();
  }

  Future<void> quitSession() async {
    final snap = snapshot;
    _teardownSensors();
    if (snap != null) {
      try {
        await api.quit(snap.sessionId);
      } catch (_) {} // 离线也可放弃, 服务端状态由补传对账
    }
    await _store?.clear();
    snapshot = null;
    phase = AppPhase.idle;
    remainingM = null;
    arrowDeg = 0;
    steps = 0;
    walkedM = 0;
    revealResult = null;
    notifyListeners();
  }

  // ============================================================
  // 会话启动 / 恢复
  // ============================================================
  void _startSession(OpenBoxResponse box, {required double walkedM, required int steps}) {
    snapshot = SessionSnapshot(
      sessionId: box.sessionId,
      mode: mode,
      targetKm: distanceKm,
      dest: box.dest,
      fenceRadiusM: box.fenceRadiusM.toDouble(),
      hintBearing: box.bearing,
      hintDistanceM: box.distanceM,
      startedAtMs: DateTime.now().millisecondsSinceEpoch,
      distanceWalkedM: walkedM,
      steps: steps,
    );
    _fence = GeofenceEngine(destination: box.dest, fenceRadiusM: box.fenceRadiusM.toDouble());
    _uploadQueue = TrackUploadQueue(_uploadTrack);
    remainingM = box.distanceM;
    error = null;
    nudgeMessage = null;
    vehicleBlocked = false;
    revealResult = null;
    phase = AppPhase.navigating;
    notifyListeners();
    _store?.save(snapshot!);
    _startSensors();
  }

  Future<void> _restoreSnapshot() async {
    final snap = await _store?.restore();
    if (snap == null) return;
    snapshot = snap;
    distanceKm = snap.targetKm;
    mode = snap.mode;
    remainingM = snap.hintDistanceM;
    _fence = GeofenceEngine(destination: snap.dest, fenceRadiusM: snap.fenceRadiusM);
    _uploadQueue = TrackUploadQueue(_uploadTrack);
    // 恢复即续走(NAV-05): 不回 idle, 直接进入导航态
    phase = AppPhase.navigating;
  }

  void resumeRestoredSession() {
    if (phase == AppPhase.navigating) _startSensors();
  }

  // ============================================================
  // 传感器接线（对应详设 §3: 预过滤 → 滤波 → 运动分类 → 航向融合）
  // ============================================================
  void _startSensors() {
    _positionSub ??= Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1, // ≥1m 位移才上报
      ),
    ).listen(_onPosition, onError: (_) => _setNoFix());

    _compassSub ??= FlutterCompass.events?.listen((event) {
      final h = event.heading;
      if (h == null) return; // 无罗盘设备: 保持 GPS course/上次航向
      final acc = event.accuracy;
      final degraded = acc != null && acc > 25; // NAV-03 未校准(度)
      _heading = h;
      if (degraded) {
        status = WalkStatus.compassDegraded;
        clockHint = bearingToClock(relativeBearing(_destBearing(), h));
      } else {
        clockHint = null;
      }
      _updateArrow();
      notifyListeners();
    });

    _stepSub ??= Pedometer.stepCountStream.listen(
      (StepCount event) => _lastPedometerSteps = event.steps.toDouble(),
      onError: (_) => _lastPedometerSteps = null, // 无权限/无传感器 → 步数项中性
    );

    // TRD 定位精度策略: 连续 30s 无有效定位 → 冻结距离推进并提示
    _noFixWatchdog ??= Timer.periodic(const Duration(seconds: 5), (_) {
      if (phase != AppPhase.navigating || _lastGoodTs == 0) return;
      if (DateTime.now().millisecondsSinceEpoch - _lastGoodTs > 30000 &&
          status != WalkStatus.noFix) {
        status = WalkStatus.noFix;
        notifyListeners();
      }
    });
  }

  void _teardownSensors() {
    _positionSub?.cancel();
    _compassSub?.cancel();
    _stepSub?.cancel();
    _noFixWatchdog?.cancel();
    _positionSub = null;
    _compassSub = null;
    _stepSub = null;
    _noFixWatchdog = null;
    _lastPedometerSteps = null;
    _lastStepCount = 0;
    _uploadQueue?.dispose();
    _uploadQueue = null;
  }

  double _destBearing() {
    final snap = snapshot;
    final pos = _lastKnownPosition;
    if (snap != null && pos != null) return initialBearing(pos, snap.dest);
    return snap?.hintBearing ?? 0;
  }

  void _updateArrow() {
    final snap = snapshot;
    if (snap == null) return;
    arrowDeg = relativeBearing(_destBearing(), _heading);
  }

  /// 定位更新主循环（TRD 2.3 onLocationUpdate 的端上入口）
  void _onPosition(Position p) {
    final snap = snapshot;
    if (snap == null || phase != AppPhase.navigating) return;
    final now = p.timestamp.millisecondsSinceEpoch;
    final accuracy = p.accuracy; // geolocator v13: 非空 double
    final speedKmh = (p.speed * 3.6).clamp(0.0, 300.0);
    final fix = GpsFix(
      position: LatLng(p.latitude, p.longitude),
      accuracyM: accuracy.toDouble(),
      speedMps: p.speed,
      timestampMs: now,
      stepCount: _lastPedometerSteps?.toInt(),
    );

    // 预过滤: 物理不可能位移(漂移)直接丢弃 [详设 §3]
    if (isGpsJump(_lastFix, fix)) return;
    _lastFix = fix;
    _lastGoodTs = now;
    _lastKnownPosition = fix.position;

    // 有效移动判定 + 计步（NAV-06）
    final motion = classifySpeed(speedKmh);
    final delta = _pedometerDelta();
    _stepCounter.update(speedKmh, delta);
    steps = _stepCounter.steps + snap.steps;

    // 距离推进（NAV-02 数据源）; 精度>50m → 弱信号提示, 30s 无定位冻结(详设§9)
    final d = haversineMeters(fix.position, snap.dest);
    if (accuracy <= 50) {
      remainingM = d;
      walkedM += haversineMeters(_prevPosition ?? fix.position, fix.position);
      _prevPosition = fix.position;
      status = motion == MotionClass.vehicle ? WalkStatus.vehicle : WalkStatus.walking;
    } else {
      status = WalkStatus.weakSignal;
    }
    _updateArrow();

    // 轨迹入补传队列（每 60s 或 10 点）
    _uploadQueue?.enqueue(TrackPoint(
      lat: fix.position.lat,
      lng: fix.position.lng,
      accuracyM: fix.accuracyM,
      speedMps: fix.speedMps,
      ts: now,
      steps: _lastPedometerSteps?.toInt(),
    ));

    // 围栏判定（2.3）: 乘车优先拦截 → nudge → arrived
    final ev = _fence!.onLocationUpdate(fix);
    switch (ev.verdict) {
      case FenceVerdict.vehicle:
        vehicleBlocked = true; // “这不像走路哦”
        break;
      case FenceVerdict.nudge:
        nudgeMessage = '再靠近一点确认（防隔河/隔栏误判）';
        break;
      case FenceVerdict.arrived:
        nudgeMessage = null;
        _onFenceArrived(ev.confidence ?? 0.8);
        break;
      default:
        nudgeMessage = null;
    }

    // 快照节流持久化(每 10 个 fix), 杀进程可恢复（NAV-05）
    if (++_snapshotSaveCounter % 10 == 0) {
      snap.steps = steps;
      snap.distanceWalkedM = walkedM;
      _store?.save(snap);
    }
    notifyListeners();
  }

  LatLng? _prevPosition;

  int _pedometerDelta() {
    final cur = _lastPedometerSteps;
    if (cur == null) return 0;
    final delta = (cur - _lastStepCount).toInt();
    if (delta > 0) _lastStepCount = cur.toInt();
    return delta < 0 ? 0 : delta;
  }

  void _setNoFix() {
    status = WalkStatus.noFix;
    notifyListeners();
  }

  // ============================================================
  // 抵达 → 服务端二次校验 → 揭晓
  // ============================================================
  Future<void> _onFenceArrived(double confidence) async {
    final snap = snapshot;
    final fence = _fence;
    if (snap == null || fence == null) return;
    _teardownSensors();
    final allTrack = <TrackPoint>[
      ...snap.pendingTrack,
      ...fence.track.map((f) => TrackPoint(
            lat: f.position.lat,
            lng: f.position.lng,
            accuracyM: f.accuracyM,
            speedMps: f.speedMps,
            ts: f.timestampMs,
            steps: f.stepCount,
          )),
    ];
    // TRD 2.3 上报的是“轨迹摘要”: 末端 200 点足够服务端二次校验(仅需末端10点)
    final track = allTrack.length > 200 ? allTrack.sublist(allTrack.length - 200) : allTrack;
    try {
      revealResult = await api.arrive(
        snap.sessionId,
        track: track,
        confidence: confidence,
        distanceWalkedM: walkedM,
        steps: steps,
      );
      status = WalkStatus.arrived;
      phase = AppPhase.revealing;
      await _store?.clear();
      await refreshRecords(notify: false);
    } on ApiException catch (e) {
      // 服务端校验未通过(422): 不揭晓, 回到导航态让用户继续靠近
      nudgeMessage = e.message;
      phase = AppPhase.navigating;
      _startSensors();
    } catch (_) {
      // 网络失败: 保留轨迹待补传, 本地先进入揭晓态占位(恢复联网后重试 arrive)
      snap.pendingTrack.addAll(track);
      await _store?.save(snap);
      nudgeMessage = '离线中：已记录抵达，联网后将同步揭晓';
      phase = AppPhase.revealing;
    }
    notifyListeners();
  }

  Future<void> _uploadTrack(List<TrackPoint> batch) async {
    // MVP: 轨迹批量随 arrive 一次性上报; 该队列用于离线暂存与后续 /track 接口扩展
    final snap = snapshot;
    if (snap == null) return;
    snap.pendingTrack.addAll(batch);
    if (snap.pendingTrack.length > 200) {
      snap.pendingTrack.removeRange(0, snap.pendingTrack.length - 200);
    }
  }

  // ============================================================
  // 图鉴
  // ============================================================
  Future<void> refreshRecords({bool notify = true}) async {
    try {
      final res = await api.records();
      stats = res.stats;
      records = res.items;
    } catch (_) {
      // 离线: 保留上次缓存
    }
    if (notify) notifyListeners();
  }

  /// 离线恢复联网后补传抵达（NAV 闭环兜底）
  Future<void> syncPendingArrival() async {
    final snap = snapshot;
    if (snap == null || phase != AppPhase.revealing) return;
    try {
      revealResult = await api.arrive(
        snap.sessionId,
        track: snap.pendingTrack,
        confidence: 0.8,
        distanceWalkedM: snap.distanceWalkedM,
        steps: snap.steps,
      );
      await _store?.clear();
      await refreshRecords(notify: false);
      notifyListeners();
    } catch (_) {}
  }

  Future<LatLng?> getCurrentPosition() async {
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 15));
      _lastKnownPosition = LatLng(p.latitude, p.longitude);
      return _lastKnownPosition;
    } catch (e) {
      error = '获取定位失败：$e';
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _teardownSensors();
    _api?.dispose();
    super.dispose();
  }
}
