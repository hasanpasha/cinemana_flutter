import 'package:cinemana/router.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart' as mk;

import 'injection_container.dart' as di;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print(
        '${record.loggerName}: ${record.level.name}: ${record.time}: ${record.message}, err: ${record.error}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  mk.MediaKit.ensureInitialized();
  di.init();
  runApp(
    EasyDynamicThemeWidget(
      child: const ProviderScope(child: Cinemana()),
    ),
  );
}

class Cinemana extends StatefulWidget {
  const Cinemana({super.key});

  @override
  State<Cinemana> createState() => _CinemanaState();
}

class _CinemanaState extends State<Cinemana> {
  @override
  void initState() {
    super.initState();
    // requestPermissions();
  }

//   void requestPermissions() async {
//     // if (/* Android 13 or higher. */) {
//     // Video permissions.
//     if (await Permission.videos.isDenied ||
//         await Permission.videos.isPermanentlyDenied) {
//       final state = await Permission.videos.request();
//       // if (!state.isGranted) {
//       //   await SystemNavigator.pop();
//       // }
//     }
//     // Audio permissions.
//     if (await Permission.audio.isDenied ||
//         await Permission.audio.isPermanentlyDenied) {
//       final state = await Permission.audio.request();
//       // if (!state.isGranted) {
//       //   await SystemNavigator.pop();
//       // }
//     }
// // }
// // else {
//     if (await Permission.storage.isDenied ||
//         await Permission.storage.isPermanentlyDenied) {
//       final state = await Permission.storage.request();
//       // if (!state.isGranted) {
//       //   await SystemNavigator.pop();
//       // }
//       // }
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Cinemana',
      theme: ThemeData.light(useMaterial3: true).copyWith(),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      // theme: ThemeData.dark(),
    );
  }
}
