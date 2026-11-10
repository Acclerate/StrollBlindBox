// WalkBox App · 首页：距离/模式选择 + 开盒 + 恢复未完成会话 + 图鉴统计
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/walkbox_controller.dart';
import 'collection_screen.dart';
import 'walk_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _distances = [0.5, 1.0, 2.0, 3.0, 5.0, 10.0];
  static const _modes = {'normal': '🌤 普通', 'night': '🌙 夜间'};

  Future<void> _openBox(WalkboxController c) async {
    await c.openBox();
    if (!mounted) return;
    if (c.phase == AppPhase.navigating) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const WalkScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<WalkboxController>();
    final restored = c.phase == AppPhase.navigating && c.snapshot != null && c.revealResult == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('散步盲盒'),
        actions: [
          IconButton(
            icon: const Icon(Icons.collections_bookmark_outlined),
            tooltip: '图鉴',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CollectionScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.dns_outlined),
            tooltip: '服务器设置',
            onPressed: () => _serverDialog(context, c),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (restored)
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('有一次未完成的散步'),
                  subtitle: const Text('从上次中断的地方继续'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    c.resumeRestoredSession();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WalkScreen()),
                    );
                  },
                ),
              ),
            const Spacer(flex: 2),
            Text('🎁', textAlign: TextAlign.center, style: TextStyle(fontSize: 96, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('今天去哪儿，盒子说了算',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(flex: 2),
            Text('散步距离', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final d in _distances)
                  ChoiceChip(
                    label: Text(d == 0.5 ? '500 m' : '${d % 1 == 0 ? d.toInt() : d} km'),
                    selected: c.distanceKm == d,
                    onSelected: (_) => c.setDistance(d),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('模式', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [for (final e in _modes.entries) ButtonSegment(value: e.key, label: Text(e.value))],
              selected: {c.mode},
              onSelectionChanged: (s) => c.setMode(s.first),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: c.loading ? null : () => _openBox(c),
              icon: c.loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.card_giftcard),
              label: Text(c.loading ? '开盒中…' : '开 盒'),
            ),
            if (c.error != null) ...[
              const SizedBox(height: 12),
              Text(c.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 16),
            if (c.stats != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat('🎯', '${c.stats!.totalArrivals}', '次抵达'),
                  _stat('🛣', (c.stats!.totalDistanceM / 1000).toStringAsFixed(1), '总公里'),
                  _stat('👣', '${c.stats!.totalSteps}', '总步数'),
                ],
              ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _stat(String emoji, String value, String label) => Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );

  Future<void> _serverDialog(BuildContext context, WalkboxController c) async {
    final ctrl = TextEditingController(text: c.baseUrl);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('服务器地址'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'http://192.168.x.x:8081')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              c.setBaseUrl(ctrl.text);
              Navigator.pop(ctx);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
