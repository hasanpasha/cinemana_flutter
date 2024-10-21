import 'package:cinemana/features/medias/domain/usecases/search_medias.dart'
    as search_medias;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../features/medias/domain/entities/media.dart';
import '../../../features/medias/domain/entities/media_kind.dart';
import '../extensions.dart';
import 'usecases_providers.dart';

final searchQueryStateProvider = StateProvider<String?>(
  (ref) => null,
);

final searchKindStateProvider = StateProvider<MediaKind>(
  (ref) => MediaKind.movies,
);

class SearchMediasNotifier extends PagedNotifier<int, Media> {
  SearchMediasNotifier({
    required search_medias.SearchMedias searchMediasUsecase,
    String? query,
    MediaKind? kind,
  }) : super(
          load: (page, limit) async {
            if (query == null) return null;

            final result = await searchMediasUsecase(search_medias.Params(
              query: query,
              kind: kind,
              page: page,
            ));
            if (result.isLeft()) {
              throw Exception("failed to search");
            }
            return result.unwrapRight()?.medias;
          },
          nextPageKeyBuilder: (lastItems, page, limit) =>
              lastItems?.isEmpty ?? false ? null : page + 1,
          errorBuilder: (error) {},
        );

  int? get latestPage => state.previousPageKeys.lastOrNull;
}

final searchMediasNotifierProvider =
    StateNotifierProvider<SearchMediasNotifier, PagedState<int, Media>>(
  (ref) {
    final searchMedias = ref.watch(searchMediasUsecaseProvider);
    final query = ref.watch(searchQueryStateProvider);
    final searchKind = ref.watch(searchKindStateProvider);

    return SearchMediasNotifier(
      searchMediasUsecase: searchMedias,
      query: query,
      kind: searchKind,
    );
  },
);
