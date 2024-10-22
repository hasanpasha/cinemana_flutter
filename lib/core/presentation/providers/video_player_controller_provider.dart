import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart' show VideoController;

class VideoPlayerNotifier extends StateNotifier<media_kit.Player> {
  VideoPlayerNotifier() : super(createPlayer());

  void updateWith({
    String? libassAndroidFont,
    String? libassAndroidFontName,
  }) {
    state = createPlayer(
      libassAndroidFont: libassAndroidFont,
      libassAndroidFontName: libassAndroidFontName,
    );
  }

  static media_kit.Player createPlayer({
    String? libassAndroidFont,
    String? libassAndroidFontName,
  }) {
    libassAndroidFont ??= 'assets/fonts/AdobeArabic-Regular.ttf';
    libassAndroidFontName ??= 'Adobe Arabic';

    return media_kit.Player(
      configuration: media_kit.PlayerConfiguration(
        libass: true,
        libassAndroidFont: libassAndroidFont,
        libassAndroidFontName: libassAndroidFontName,
      ),
    );
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

final videoPlayerProvider =
    StateNotifierProvider<VideoPlayerNotifier, media_kit.Player>(
  (ref) => VideoPlayerNotifier(),
);

final videoPlayerPlayingStateProvider = StreamProvider<bool>(
  (ref) => ref.watch(videoPlayerProvider).stream.playing,
);

final videoPlayerControllerProvider = Provider<VideoController>(
  (ref) {
    final player = ref.watch(videoPlayerProvider);

    return VideoController(
      player,
    );
  },
);
