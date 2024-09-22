import 'features/medias/domain/entities/media.dart';
import 'features/medias/presentation/pages/media_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/medias/presentation/pages/medias_page.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

final _router = GoRouter(routes: [
  GoRoute(
    name: 'home',
    path: '/',
    builder: (context, state) => const MediasPage(),
  ),
  GoRoute(
    name: 'mediaDetail',
    path: '/mediaDetail',
    builder: (context, state) => MediaDetailPage(media: state.extra as Media),
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Cinemana',
      theme: ThemeData.dark(),
    );
  }
}
