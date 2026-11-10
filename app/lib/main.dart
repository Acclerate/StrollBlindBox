// WalkBox（散步盲盒）· App 入口
// 架构见 docs/client-location-design.md: UI → 领域层(围栏/导航/记录) → LocatorCore → 原生桥
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'state/walkbox_controller.dart';
import 'ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = WalkboxController();
  // 快照目录注入（NAV-05: 会话可离线闭环, 杀进程 100% 可恢复）
  try {
    final dir = await getApplicationDocumentsDirectory();
    controller.setDocsDir(dir.path);
  } catch (_) {/* 测试环境无插件时静默 */ }
  await controller.init();
  runApp(WalkBoxApp(controller: controller));
}

class WalkBoxApp extends StatelessWidget {
  final WalkboxController controller;
  const WalkBoxApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MaterialApp(
        title: '散步盲盒',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF6750A4), // 盲盒紫
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
