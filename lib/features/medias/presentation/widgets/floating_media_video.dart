import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/extensions.dart';
import '../../../../core/presentation/providers/providers.dart';
import '../../domain/entities/media.dart';
import '../pages/media_detail_page.dart';
import 'custom_adaptive_video_controls.dart';

class FloatingMediaVideo extends ConsumerWidget {
  const FloatingMediaVideo({
    super.key,
    required this.onTap,
    required this.child,
    this.alignment = Alignment.bottomRight,
  });

  final Function() onTap;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(mediaProvider);

    void onClose() {
      ref.read(mediaProvider.notifier).state = null;
      ref.read(videoPlayerProvider).stop();
    }

    return Stack(
      children: [
        child,
        if (media != null)
          Align(
            alignment: alignment,
            child: Dismissible(
              key: Key(media.id),
              onDismissed: (direction) => onClose(),
              child: _FloatingMediaVideo(
                media: media,
                onTap: onTap,
                onClose: onClose,
              ),
            ),
          )
      ],
    );
  }
}

class _FloatingMediaVideo extends StatelessWidget {
  const _FloatingMediaVideo({
    required this.media,
    required this.onTap,
    required this.onClose,
  });

  final Media media;
  final Function() onTap;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    final view = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          const AspectRatio(
            aspectRatio: 16 / 9,
            child: MediaVideoPlayer(showControls: false),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              color: Colors.white,
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                PreviousButton(
                  iconColor: Colors.white,
                ),
                PlayingToggleButton(
                  iconColor: Colors.white,
                ),
                NextButton(
                  iconColor: Colors.white,
                ),
                Spacer(),
                // Text(media.title),
              ],
            ),
          ),
        ],
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: context.isPhone ? phoneView : desktopView,
        ),
      ),
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
