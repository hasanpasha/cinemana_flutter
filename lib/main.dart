import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/presentation/bloc/media_info/media_info_bloc.dart';
import 'package:cinemana/features/medias/presentation/bloc/media_player_data/media_player_data_bloc.dart';
import 'package:cinemana/features/medias/presentation/bloc/media_seasons/media_seasons_bloc.dart';
import 'package:cinemana/features/medias/presentation/bloc/medias/medias_bloc.dart';
import 'package:cinemana/features/medias/presentation/pages/media_detail_page.dart';
import 'package:cinemana/injection_container.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_provider/go_provider.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:video_player_media_kit/video_player_media_kit.dart';

import 'features/medias/domain/entities/media.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/medias/presentation/pages/medias_page.dart';
import 'injection_container.dart' as di;
import 'package:media_kit/media_kit.dart' as mk;

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
  runApp(EasyDynamicThemeWidget(child: const Cinemana()));
}

final _router = GoRouter(routes: [
  ShellfulProviderRoute(
    providers: [
      BlocProvider(create: (_) => sl<MediasBloc>()),
      BlocProvider(create: (_) => sl<MediaPlayerDataBloc>()),
      BlocProvider(create: (_) => sl<MediaSeasonsBloc>()),
      BlocProvider(create: (_) => sl<MediaInfoBloc>()),
    ],
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const MediasPage(),
        // builder: (context, state) => const PlayerPage(
        //   media: Media(id: "id", title: "title", kind: MediaKind.movies, year: 2),
        // ),
      ),
      GoRoute(
        name: 'mediaDetail',
        path: '/mediaDetail',
        builder: (context, state) =>
            MediaDetailPage(media: state.extra as Media),
        // builder: (context, state) => PlayerPage(media: state.extra as Media),
      ),
      // GoRoute(
      //   name: 'player',
      //   path: '/playerPage',
      //   builder: (context, state) {
      //     final args = state.extra as (Media, List<Season>?);
      //     return PlayerPage(media: args.$1, seasons: args.$2);
      //   },
      //   // builder: (context, state) => PlayerPage(media: state.extra as Media),
      // ),
    ],
    // navigatorContainerBuilder: (context, shell, widgets) {
    //   Scaffold();
    // },
  ),
]);

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

  void requestPermissions() async {
    // if (/* Android 13 or higher. */) {
    // Video permissions.
    if (await Permission.videos.isDenied ||
        await Permission.videos.isPermanentlyDenied) {
      final state = await Permission.videos.request();
      // if (!state.isGranted) {
      //   await SystemNavigator.pop();
      // }
    }
    // Audio permissions.
    if (await Permission.audio.isDenied ||
        await Permission.audio.isPermanentlyDenied) {
      final state = await Permission.audio.request();
      // if (!state.isGranted) {
      //   await SystemNavigator.pop();
      // }
    }
// }
// else {
    if (await Permission.storage.isDenied ||
        await Permission.storage.isPermanentlyDenied) {
      final state = await Permission.storage.request();
      // if (!state.isGranted) {
      //   await SystemNavigator.pop();
      // }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Cinemana',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      // theme: ThemeData.dark(),
    );
  }
}
