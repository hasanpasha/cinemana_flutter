import 'package:cinemana/features/medias/presentation/widgets/floating_media_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../../core/presentation/providers/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/entities/media.dart';
import '../widgets/media_kind_selector.dart';
import '../widgets/media_poster.dart';

class MediasPage extends StatelessWidget {
  const MediasPage({super.key});

  static const String mediaDetailRouteName = 'mainMediaDetail';

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cinemana'),
        ),
        body: FloatingMediaVideo(
          onTap: () => context.goNamed(MediasPage.mediaDetailRouteName),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 350,
                  child: LatestMedias(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class LatestMedias extends ConsumerWidget {
  const LatestMedias({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Latest ${ref.watch(latestKindStateProvider).name}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              MediaKindSelector(
                moviesIcon: const Text("movies"),
                seriesIcon: const Text("series"),
                selectedDecoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                initialKind: ref.watch(latestKindStateProvider),
                onSelected: (kind) {
                  ref.read(latestKindStateProvider.notifier).state = kind;
                },
              )
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: RiverPagedBuilder<int, Media>(
            firstPageKey: 1,
            provider: latestMediasNotifierProvider,
            itemBuilder: (context, media, index) => Hero(
              tag: media.id,
              child: Material(
                child: AspectRatio(
                  aspectRatio: 0.56,
                  child: MediaPoster(
                    media: media,
                    showTitleText: true,
                    onPress: (media) {
                      ref.read(mediaProvider.notifier).state = media;
                      context.goNamed(MediasPage.mediaDetailRouteName);
                    },
                  ),
                ),
              ),
            ),
            pagedBuilder: (controller, builder) {
              return PagedListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                pagingController: controller,
                builderDelegate: builder,
              );
            },
          ),
        ),
      ],
    );
  }
}
