// WalkBox App · 图鉴页：统计概览 + 抵达记录列表（GET /v1/records）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/geo.dart';
import '../core/models.dart';
import '../state/walkbox_controller.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalkboxController>().refreshRecords();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<WalkboxController>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('散步图鉴')),
      body: c.records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🥚', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 8),
                  Text('还没有抵达记录', style: Theme.of(context).textTheme.titleMedium),
                  const Text('开一个盲盒，走到它面前'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (c.stats != null)
                  Card(
                    color: cs.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _stat('${c.stats!.totalArrivals}', '次抵达'),
                          _stat('${c.stats!.distinct30d}', '近30天不同点'),
                          _stat((c.stats!.totalDistanceM / 1000).toStringAsFixed(1), '总公里'),
                          _stat('${c.stats!.totalSteps}', '总步数'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                for (final r in c.records)
                  ListTile(
                    leading: Text(RevealedPoi.categoryEmoji(r.poi.category),
                        style: const TextStyle(fontSize: 28)),
                    title: Text(r.poi.nameLocal),
                    subtitle: Text(
                        '${r.poi.category} · ${r.arrivedAt.toLocal().toString().substring(0, 16)}'),
                    trailing: Text(formatDistance(r.distanceWalkedM)),
                  ),
              ],
            ),
    );
  }

  Widget _stat(String v, String label) => Column(
        children: [
          Text(v, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      );
}
