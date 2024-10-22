import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../features/medias/domain/entities/media.dart';
import '../../../features/medias/domain/entities/media_kind.dart';
import '../../../features/medias/domain/usecases/get_latest.dart';
import 'common.dart';
import 'usecases_providers.dart';

final latestKindStateProvider = StateProvider<MediaKind>(
  (ref) => MediaKind.movies,
);

final latestMediasNotifierProvider =
    StateNotifierProvider<PagedMediasNotifier, PagedState<int, Media>>(
  (ref) {
    final getLatest = ref.watch(getLatestUsecaseProvider);
    final latestKind = ref.watch(latestKindStateProvider);

    return PagedMediasNotifier(
      usecase: getLatest,
      params: GetLatestParams(kind: latestKind),
    );
  },
);
