import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/medias/domain/entities/media.dart';
import 'features/medias/presentation/pages/media_detail_page.dart';
import 'features/medias/presentation/pages/medias_page.dart';
import 'features/medias/presentation/pages/medias_search_page.dart';
import 'features/medias/presentation/widgets/scaffold_with_navbar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      parentNavigatorKey: _rootNavigatorKey,
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: ScaffoldWithNavbar(
            location: state.matchedLocation,
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const MediasPage(),
        ),
        GoRoute(
          name: 'searchMedias',
          path: '/searchMedias',
          builder: (context, state) => const MediasSearchPage(),
        ),
        GoRoute(
          name: 'mediaDetail',
          path: '/mediaDetail',
          builder: (context, state) {
            final media = state.extra as Media;

            return MediaDetailPage(media: media);
          },
        ),
      ],
    ),
  ],
);
