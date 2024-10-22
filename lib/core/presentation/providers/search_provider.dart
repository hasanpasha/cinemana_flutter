import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../features/medias/domain/entities/media.dart';
import '../../../features/medias/domain/entities/media_kind.dart';
import '../../../features/medias/domain/usecases/search_medias.dart';
import 'common.dart';
import 'usecases_providers.dart';

final searchQueryStateProvider = StateProvider<String>(
  (ref) => '',
);

final searchKindStateProvider = StateProvider<MediaKind>(
  (ref) => MediaKind.movies,
);

final searchMediasNotifierProvider =
    StateNotifierProvider<PagedMediasNotifier, PagedState<int, Media>>(
  (ref) {
    final searchMedias = ref.watch(searchMediasUsecaseProvider);
    final query = ref.watch(searchQueryStateProvider);
    final searchKind = ref.watch(searchKindStateProvider);

    return PagedMediasNotifier(
      usecase: searchMedias,
      params: SearchMediasParams(
        query: query.toString(),
        kind: searchKind,
      ),
    );
  },
);
