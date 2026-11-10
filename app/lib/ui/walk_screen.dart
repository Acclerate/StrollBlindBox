// WalkBox App · 步行导航页：大箭头 + 剩余距离 + 状态横幅（NAV-01/02/03/06 全部落位）
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/geo.dart';
import '../state/walkbox_controller.dart';
import 'reveal_screen.dart';

class WalkScreen extends StatefulWidget {
  const WalkScreen({super.key});

  @override
  State<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  late final WalkboxController _c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _c = context.read<WalkboxController>();
    _c.addListener(_onController);
  }

  @override
  void dispose() {
    _c.removeListener(_onController);
    super.dispose();
  }

  void _onController() {
    if (!mounted) return;
    if (_c.phase == AppPhase.revealing) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RevealScreen()));
      return;
    }
    if (_c.vehicleBlocked) {
      _c.vehicleBlocked = false; // 一次性提示
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('🚌 这不像走路哦——检测到乘车，本次不计入'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<WalkboxController>();
    final cs = Theme.of(context).colorScheme;
    final banner = _banner(c);
    final compassDegraded = c.clockHint != null;

    return PopScope(
      canPop: false, // 步行中禁返回, 用“结束散步”退出（防误触丢会话; 快照仍可恢复）
      child: Scaffold(
        appBar: AppBar(
          title: const Text('跟着箭头走'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.cached),
              tooltip: '换盒（3 次/日）',
              onPressed: () => _confirm(c, '换一个盲盒？', '当前进度将作废', c.reroll),
            ),
            IconButton(
              icon: const Icon(Icons.flag_outlined),
              tooltip: '结束',
              onPressed: () => _confirm(c, '今天就到这里？', '未抵达不点亮图鉴', c.quitSession),
            ),
          ],
        ),
        body: Column(
          children: [
            if (banner != null) banner,
            const Spacer(flex: 2),
            // NAV-01: 箭头 = 目标方位角 − 设备航向（随罗盘流高频刷新, 低通平滑由 core 层负责）
            TweenAnimationBuilder<double>(
              tween: Tween(end: c.arrowDeg / 360),
              duration: const Duration(milliseconds: 100),
              builder: (_, turns, child) =>
                  Transform.rotate(angle: turns * 2 * math.pi, child: child),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.primary, width: 3),
                  boxShadow: [
                    BoxShadow(color: cs.primary.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 8),
                  ],
                ),
                child: Icon(Icons.navigation_rounded, size: 130, color: cs.primary),
              ),
            ),
            const SizedBox(height: 24),
            // NAV-02: <1km 显示米, ≥1km 显示 0.1km 粒度
            Text(
              c.remainingM == null ? '--' : formatDistance(c.remainingM!),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text('剩余直线距离'),
            const SizedBox(height: 8),
            if (compassDegraded)
              Chip(
                avatar: const Icon(Icons.explore_off, size: 18),
                label: Text('罗盘不稳 · 目标在${c.clockHint}'),
              )
            else
              Text('已走 ${formatDistance(c.walkedM)} · 步数 ${c.steps}'),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget? _banner(WalkboxController c) {
    if (c.status == WalkStatus.weakSignal) return _bn('📡 信号弱，继续走', Colors.orange);
    if (c.status == WalkStatus.noFix) return _bn('📴 定位暂时不可用，距离已冻结', Colors.orange);
    if (c.nudgeMessage != null) return _bn('⚠ ${c.nudgeMessage}', Colors.blueGrey);
    return null;
  }

  Widget _bn(String text, Color color) => Container(
        width: double.infinity,
        color: color.withValues(alpha: 0.15),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: color)),
      );

  Future<void> _confirm(WalkboxController c, String title, String sub, Future<void> Function() action) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(sub),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('再走走')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('确认')),
        ],
      ),
    );
    if (ok == true) {
      await action();
      if (mounted && c.phase == AppPhase.idle) Navigator.pop(context);
    }
  }
}
