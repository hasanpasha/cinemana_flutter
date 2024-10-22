import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/presentation/widgets/scaffold_with_navbar.dart';
import 'features/medias/presentation/pages/media_detail_page.dart';
import 'features/medias/presentation/pages/medias_page.dart';
import 'features/medias/presentation/pages/medias_search_page.dart';

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
          routes: [
            GoRoute(
              name: 'mainMediaDetail',
              path: 'mainMediaDetail',
              builder: (context, state) => const MediaDetailPage(),
            ),
          ],
        ),
        GoRoute(
          name: 'searchMedias',
          path: '/searchMedias',
          builder: (context, state) => const MediasSearchPage(),
          routes: [
            GoRoute(
              name: 'searchedMediaDetail',
              path: 'searchedMediaDetail',
              builder: (context, state) => const MediaDetailPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
