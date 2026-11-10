// WalkBox App 核心单测 — 与 prototype/test 同基线（geo/motion/geo fence 对齐 TS 版断言）
import 'package:flutter_test/flutter_test.dart';
import 'package:walkbox/core/fence.dart';
import 'package:walkbox/core/geo.dart';
import 'package:walkbox/core/motion.dart';

void main() {
  group('geo [NAV-01/02]', () {
    test('haversine 基线: 赤道 1° ≈ 111.19km / 北京→上海 ≈ 1068km', () {
      final eq = haversineMeters(const LatLng(0, 0), const LatLng(0, 1));
      expect((eq - 111195).abs() < 500, isTrue, reason: 'actual=$eq');
      final bjSh = haversineMeters(const LatLng(39.9042, 116.4074), const LatLng(31.2304, 121.4737));
      expect((bjSh - 1068000).abs() < 5000, isTrue, reason: 'actual=$bjSh');
    });

    test('initialBearing 四方位', () {
      const o = LatLng(0, 0);
      expect(initialBearing(o, const LatLng(1, 0)), closeTo(0, 0.01));
      expect(initialBearing(o, const LatLng(0, 1)), closeTo(90, 0.01));
      expect(initialBearing(o, const LatLng(-1, 0)), closeTo(180, 0.01));
      expect(initialBearing(o, const LatLng(0, -1)), closeTo(270, 0.01));
    });

    test('destinationPoint 往返一致', () {
      const s = LatLng(31.2304, 121.4737);
      for (final [b, d] in const [
        [187.0, 1500.0],
        [45.0, 8300.0],
      ]) {
        final p = destinationPoint(s, b, d);
        expect((haversineMeters(s, p) - d).abs() < 1, isTrue);
        expect(initialBearing(s, p), closeTo(b, 0.01));
      }
    });

    test('formatDistance NAV-02 显示规范', () {
      expect(formatDistance(850), '850 m');
      expect(formatDistance(999), '999 m');
      expect(formatDistance(1000), '1.0 km');
      expect(formatDistance(1234), '1.2 km');
      expect(formatDistance(17300), '17.3 km');
    });

    test('angularDelta/relativeBearing 跨 0° 环绕', () {
      expect(angularDelta(350, 10), closeTo(-20, 1e-9));
      expect(angularDelta(10, 350), closeTo(20, 1e-9));
      expect(relativeBearing(90, 0), closeTo(90, 1e-9));
    });

    test('bearingToClock NAV-03 降级文案', () {
      expect(bearingToClock(0), '12 点钟方向');
      expect(bearingToClock(90), '3 点钟方向');
      expect(bearingToClock(-90), '9 点钟方向');
    });
  });

  group('motion [NAV-06]', () {
    test('速度门限: 0.5–12 步行 / 12–30 可疑 / >30 乘车', () {
      expect(classifySpeed(0.4), MotionClass.stationary);
      expect(classifySpeed(0.5), MotionClass.walking); // 下边界含
      expect(classifySpeed(12), MotionClass.walking); // 上边界含
      expect(classifySpeed(12.1), MotionClass.suspicious);
      expect(classifySpeed(30), MotionClass.suspicious);
      expect(classifySpeed(30.1), MotionClass.vehicle);
    });

    test('计步: 仅步行区间计入', () {
      final sc = StepCounter();
      expect(sc.update(4, 30), 30);
      expect(sc.update(0.3, 5), 0); // 静止噪声
      expect(sc.update(45, 500), 0); // 乘车颠簸
      expect(sc.update(20, 200), 0); // 骑行可疑
      expect(sc.update(5, -3), 0); // 负增量防御
      expect(sc.steps, 30);
    });
  });

  group('fence [TRD 2.3 / 六.2 围栏误判专项]', () {
    const dest = LatLng(31.2304, 121.4737);
    // 以 dest 为原点, 正西 offsetM 米
    GpsFix fixAt(double offsetM,
        {double accuracy = 8, double speedMps = 1.3, required int ts, int? steps}) {
      return GpsFix(
        position: destinationPoint(dest, 270, offsetM),
        accuracyM: accuracy,
        speedMps: speedMps,
        timestampMs: ts,
        stepCount: steps,
      );
    }

    test('正常步行抵达（置信度≥0.8）', () {
      var arrived = false;
      final eng = GeofenceEngine(destination: dest, fenceRadiusM: 30);
      final dists = <double>[120, 90, 60, 35, 20, 12];
      for (final (i, d) in dists.indexed) {
        final ev = eng.onLocationUpdate(fixAt(d, ts: i * 10000, steps: 100 + i * 22));
        if (ev.verdict == FenceVerdict.arrived) arrived = true;
      }
      expect(arrived, isTrue);
    });

    test('河对岸/GPS漂移 40m 外绝不触发 [误判率=0]', () {
      final eng = GeofenceEngine(destination: dest, fenceRadiusM: 30);
      for (final (i, d) in <double>[80, 60, 50, 45, 44, 45].indexed) {
        final ev = eng.onLocationUpdate(fixAt(d, accuracy: 6, ts: i * 10000, steps: 100 + i * 20));
        expect(ev.verdict, isNot(FenceVerdict.arrived));
        expect(ev.verdict, isNot(FenceVerdict.nudge));
      }
    });

    test('低精度单点进围栏 → 只 nudge 不揭晓（防隔栏杆误判）', () {
      final eng = GeofenceEngine(destination: dest, fenceRadiusM: 30);
      for (var i = 0; i < 4; i++) {
        final ev = eng.onLocationUpdate(fixAt(20, accuracy: 55, ts: i * 10000, steps: 100));
        expect(ev.verdict, FenceVerdict.nudge);
      }
    });

    test('乘车进入围栏 → vehicle 拦截不揭晓', () {
      final eng = GeofenceEngine(destination: dest, fenceRadiusM: 30);
      final ev = eng.onLocationUpdate(fixAt(0, speedMps: 11.4, ts: 0, steps: 0));
      expect(ev.verdict, FenceVerdict.vehicle);
    });

    test('服务端二次校验镜像: 末端轨迹 vs 围栏', () {
      final good = [
        fixAt(80, ts: 0),
        fixAt(40, ts: 10000),
        fixAt(15, ts: 20000),
      ];
      expect(serverVerifyMirror(good, dest, 30), isTrue);
      final bad = [fixAt(180, ts: 0), fixAt(120, ts: 10000), fixAt(100, ts: 20000)];
      expect(serverVerifyMirror(bad, dest, 30), isFalse);
      expect(serverVerifyMirror(const [], dest, 30), isFalse);
    });

    test('isGpsJump: 物理不可能位移', () {
      final p1 = fixAt(0, ts: 0);
      expect(isGpsJump(null, p1), isFalse);
      expect(isGpsJump(p1, fixAt(3, ts: 1000)), isFalse);
      expect(isGpsJump(p1, fixAt(100, ts: 1000)), isTrue);
    });
  });
}
