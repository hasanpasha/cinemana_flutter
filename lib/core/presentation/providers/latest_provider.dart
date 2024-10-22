import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../features/medias/domain/entities/media.dart';
import '../../../features/medias/domain/entities/media_kind.dart';
import '../../../features/medias/domain/usecases/get_latest.dart';
import '../extensions.dart';
import 'usecases_providers.dart';

final latestKindStateProvider = StateProvider<MediaKind>(
  (ref) => MediaKind.movies,
);

class LatestMediasNotifier extends PagedNotifier<int, Media> {
  LatestMediasNotifier({
    required GetLatest searchMediasUsecase,
    MediaKind? kind,
  }) : super(
          load: (page, limit) async {
            final result = await searchMediasUsecase(
                GetLatestParams(kind: kind, page: page));
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

final latestMediasNotifierProvider =
    StateNotifierProvider<LatestMediasNotifier, PagedState<int, Media>>(
  (ref) {
    final getLatest = ref.watch(getLatestUsecaseProvider);
    final latestKind = ref.watch(latestKindStateProvider);

    return LatestMediasNotifier(
      searchMediasUsecase: getLatest,
      kind: latestKind,
    );
  },
);
