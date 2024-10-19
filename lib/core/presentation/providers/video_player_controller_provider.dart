import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart' show VideoController;

import 'subtitle_provider.dart';
import 'video_provider.dart';

class VideoPlayerNotifier extends StateNotifier<media_kit.Player> {
  VideoPlayerNotifier(super.state);

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

final videoPlayerProvider =
    StateNotifierProvider<VideoPlayerNotifier, media_kit.Player>(
  (ref) => VideoPlayerNotifier(
    media_kit.Player(
      configuration: const media_kit.PlayerConfiguration(
        libass: true,
        libassAndroidFont: 'assets/fonts/AdobeArabic-Regular.ttf',
        libassAndroidFontName: 'Adobe Arabic',
      ),
    ),
  ),
);

final videoPlayerPlayingStateProvider = StreamProvider<bool>(
  (ref) => ref.watch(videoPlayerProvider).stream.playing,
);

final mediaVideoOpenerControllerWrapperProvider =
    FutureProvider<VideoController?>((ref) async {
  final videoPlayer = ref.watch(videoPlayerProvider);
  final video = ref.watch(videoProvider);

  if (video == null) {
    await videoPlayer.stop();
    return null;
  }

  await videoPlayer.open(video);
  return VideoController(videoPlayer);
});

final mediaSubtitleSetterControllerWrapperProvider =
    FutureProvider<VideoController?>((ref) async {
  final controllerValue = ref.watch(mediaVideoOpenerControllerWrapperProvider);
  final subtitle = ref.watch(subtitleProvider);

  final controller = controllerValue.valueOrNull;

  final videoPlayer = ref.read(videoPlayerProvider);
  if (subtitle != null) {
    await videoPlayer.setSubtitleTrack(subtitle);
  } else {
    await videoPlayer.setSubtitleTrack(media_kit.SubtitleTrack.no());
  }

  return controller;
});

final videoPlayerControllerProvider = Provider<VideoController?>(
  (ref) => ref.watch(mediaSubtitleSetterControllerWrapperProvider).valueOrNull,
);
