import 'package:cinemana/core/presentation/providers/latest_provider.dart';
import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/presentation/widgets/media_kind_selector.dart';
import 'package:cinemana/features/medias/presentation/widgets/media_poster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import '../../../../core/presentation/providers/providers.dart';
import '../../../../core/presentation/extensions.dart';
import '../../domain/entities/media.dart';
import '../widgets/custom_adaptive_video_controls.dart';
import 'media_detail_page.dart';

class MediasPage extends ConsumerWidget {
  const MediasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(mediaProvider);

    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cinemana'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
        // body: Stack(
        //   children: [
        //     if (media != null)
        //       Align(
        //         alignment: Alignment.bottomRight,
        //         child: BottomMediaFloatingView(media: media),
        //       ),
        //   ],
        // ),
        // floatingActionButton: BottomMediaFloatingView(),
      );
    });
  }
}

class LatestMedias extends ConsumerWidget {
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
                moviesIcon: Text("movies"),
                seriesIcon: Text("series"),
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
                      context.goNamed('mediaDetail', extra: media);
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

class BottomMediaFloatingView extends StatelessWidget {
  const BottomMediaFloatingView({
    super.key,
    required this.media,
  });

  final Media media;

  @override
  Widget build(BuildContext context) {
    final view = Card(
      clipBehavior: Clip.hardEdge,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const Stack(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: MediaVideoPlayer(showControls: false),
            ),
            Align(
              alignment: Alignment.topRight,
              child: MediaCloseButton(iconColor: Colors.white),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(),
                  PhonePreviousButton(
                    iconColor: Colors.white,
                  ),
                  PlayingToggleButton(
                    iconColor: Colors.white,
                  ),
                  PhoneNextButton(
                    iconColor: Colors.white,
                  ),
                  Spacer(),
                  // Text(media.title),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final phoneView = SizedBox(
      width: 200,
      height: 200 * (9 / 16),
      child: view,
    );

    final desktopView = SizedBox(
      width: 400,
      height: 400 * (9 / 16),
      child: view,
    );

    return Hero(
      tag: media.id,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
        child: Material(
          child: InkWell(
            child: context.isPhone ? phoneView : desktopView,
            onTap: () => context.pushNamed('mediaDetail', extra: media),
          ),
        ),
      ),
    );
  }
}

class MediaCloseButton extends ConsumerWidget {
  const MediaCloseButton({
    super.key,
    this.iconColor,
  });

  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CloseButton(
      onPressed: () => ref.read(mediaProvider.notifier).state = null,
      color: iconColor,
      // icon: const Icon(Icons.close),
    );
  }
}

class PlayingToggleButton extends ConsumerWidget {
  const PlayingToggleButton({
    super.key,
    this.iconColor,
  });

  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(videoPlayerProvider);

    final playing = ref.watch(videoPlayerPlayingStateProvider);

    return IconButton(
      onPressed: () {
        player.playOrPause();
      },
      color: iconColor,
      icon: playing.maybeWhen(
        data: (isPlaying) {
          if (isPlaying) {
            return const Icon(Icons.pause);
          } else {
            return const Icon(Icons.play_arrow);
          }
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}
