import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        body: Stack(
          children: [
            if (media != null)
              Align(
                alignment: Alignment.bottomRight,
                child: BottomMediaFloatingView(media: media),
              ),
          ],
        ),
        // floatingActionButton: BottomMediaFloatingView(),
      );
    });
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
