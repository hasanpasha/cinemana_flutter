import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../features/medias/domain/entities/media.dart';
import '../../../features/medias/domain/usecases/common.dart';
import '../../usecases/usecase.dart';
import '../extensions.dart';

class PagedMediasNotifier<U extends Usecase, P extends PagedParams>
    extends PagedNotifier<int, Media> {
  PagedMediasNotifier({
    required U usecase,
    required P params,
  }) : super(
          load: (page, limit) async {
            final result = await usecase(params.copyWith(page: page));
            if (result.isLeft()) {
              throw Exception("failed to load medias");
            }
            return result.unwrapRight()?.medias;
          },
          nextPageKeyBuilder: (lastItems, page, limit) =>
              lastItems?.isEmpty ?? false ? null : page + 1,
        );
}
