// WalkBox App · 抵达揭晓页（服务端二次校验通过后展示; TRD 2.1 输出约束在此兑现）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/geo.dart';
import '../core/models.dart';
import '../state/walkbox_controller.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<WalkboxController>();
    final cs = Theme.of(context).colorScheme;
    final r = c.revealResult;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.primaryContainer, cs.surface],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: CurvedAnimation(parent: _anim, curve: Curves.elasticOut),
                  child: const Text('🎉', style: TextStyle(fontSize: 80)),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _anim,
                  child: Column(
                    children: [
                      Text('抵达目的地！', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 20),
                      if (r != null) ...[
                        _revealCard(context, r.poi),
                        const SizedBox(height: 20),
                        Text(
                          '走了 ${formatDistance(c.walkedM)} · ${c.steps} 步',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '服务端校验 ✅ · ${r.arrivedAt.toLocal().toString().substring(0, 16)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ] else
                        const Text('离线记录已保存，联网后将同步揭晓'),
                      const SizedBox(height: 32),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          c.quitSession(); // 归档清理, 回到首页
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('收进图鉴'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _revealCard(BuildContext context, RevealedPoi poi) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(RevealedPoi.categoryEmoji(poi.category), style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            Text(poi.nameLocal, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('${poi.category} · #${poi.id}', style: Theme.of(context).textTheme.bodySmall),
            const Divider(height: 24),
            Text(poi.description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
