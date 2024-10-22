import 'package:cinemana/features/medias/presentation/widgets/floating_media_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../../core/presentation/providers/providers.dart';
import '../../domain/entities/entities.dart';
import '../widgets/media_kind_selector.dart';
import '../widgets/media_poster.dart';

class MediasSearchPage extends ConsumerStatefulWidget {
  const MediasSearchPage({super.key});

  @override
  ConsumerState<MediasSearchPage> createState() => _MediasSearchPageState();
}

class _MediasSearchPageState extends ConsumerState<MediasSearchPage> {
  static const double searchGridChildAspectRatio = 0.56;
  static const int searchGridChildMinSize = 150;

  static const String mediaDetailRouteName = 'searchedMediaDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SearchQueryField(),
        actions: [
          MediaKindSelector(
            onSelected: (kind) {
              ref.read(searchKindStateProvider.notifier).state = kind;
            },
          ),
        ],
      ),
      body: FloatingMediaVideo(
        onTap: () => context.goNamed(mediaDetailRouteName),
        child: Column(
          children: [
            Expanded(
              child: RiverPagedBuilder<int, Media>(
                firstPageKey: 1,
                provider: searchMediasNotifierProvider,
                itemBuilder: (context, media, index) => Hero(
                  tag: media.id,
                  child: Material(
                    child: MediaPoster(
                      media: media,
                      showTitleText: true,
                      onPress: (media) {
                        ref.read(mediaProvider.notifier).state = media;
                        context.goNamed(mediaDetailRouteName);
                      },
                    ),
                  ),
                ),
                pagedBuilder: (controller, builder) {
                  return PagedGridView(
                    pagingController: controller,
                    builderDelegate: builder,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.sizeOf(context).width.toInt() ~/
                              searchGridChildMinSize,
                      childAspectRatio: searchGridChildAspectRatio,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchQueryField extends ConsumerStatefulWidget {
  const SearchQueryField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchQueryFieldState();
}

class _SearchQueryFieldState extends ConsumerState<SearchQueryField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: ref.read(searchQueryStateProvider),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffix: IconButton(
          onPressed: () {
            controller.clear();
            ref.read(searchQueryStateProvider.notifier).state = '';
          },
          icon: const Icon(Icons.close),
        ),
        prefix: IconButton(
          onPressed: () {
            ref.read(searchQueryStateProvider.notifier).state = controller.text;
          },
          icon: const Icon(Icons.search),
        ),
      ),
      onSubmitted: (value) {
        ref.read(searchQueryStateProvider.notifier).state = value;
      },
    );
  }
}
