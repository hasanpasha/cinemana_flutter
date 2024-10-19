import 'package:cinemana/core/presentation/extensions.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:cinemana/features/medias/domain/usecases/search_medias.dart'
    as search_medias;
import 'package:cinemana/injection_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

final searchQueryStateProvider = StateProvider<String?>(
  (ref) => null,
);

final searchKindStateProvider = StateProvider<MediaKind>(
  (ref) => MediaKind.movies,
);

class SearchMediasNotifier extends PagedNotifier<int, Media> {
  SearchMediasNotifier({
    String? query,
    required MediaKind kind,
  }) : super(
          load: (page, limit) async {
            if (query == null) return null;

            final search_medias.SearchMedias searchMedias = sl();
            final result = await searchMedias(search_medias.Params(
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
    final query = ref.watch(searchQueryStateProvider);
    final searchKind = ref.watch(searchKindStateProvider);

    return SearchMediasNotifier(query: query, kind: searchKind);
  },
);
