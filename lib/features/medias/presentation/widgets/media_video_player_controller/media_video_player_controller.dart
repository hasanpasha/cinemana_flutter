import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../models/player_media.dart';
import '../models/player_subtitle.dart';
import 'media_controller.dart';
import 'player_subtitle_controller.dart';
import 'player_video_controller.dart';

class MediaVideoPlayerController {
  MediaVideoPlayerController({
    required this.mediaController,
    required this.playerVideoController,
    required this.playerSubtitleController,
  }) {
    mediaController.addListener(_mediaListener);
    playerVideoController.addListener(_videoListener);
    playerSubtitleController.addListener(_subtitleListener);
  }

  final MediaController mediaController;
  final PlayerVideoController playerVideoController;
  final PlayerSubtitleController playerSubtitleController;

  final mediaNotifier = ValueNotifier<Media?>(null);
  final videoNotifier = ValueNotifier<PlayerVideo?>(null);
  final subtitleNotifier = ValueNotifier<PlayerSubtitle?>(null);
  final seasonsNotifier = ValueNotifier<List<Season>?>(null);
  final episodeNotifier = ValueNotifier<Episode?>(null);
  final videosListNotifier = ValueNotifier<List<PlayerVideo>?>(null);
  final subtitlesListNotifier = ValueNotifier<List<PlayerSubtitle>?>(null);

  void openMedia(Media newMedia) {
    if (newMedia is Episode) {
      mediaController.changeEpisode(newMedia);
    } else {
      mediaController.openMedia(newMedia);
    }
  }

  bool switchToNextEpisode() {
    return mediaController.switchToNextEpisode();
  }

  bool switchToPreviousEpisode() {
    return mediaController.switchToPreviousEpisode();
  }

  void dispose() {
    mediaController.removeListener(_mediaListener);
    playerVideoController.removeListener(_videoListener);
    playerSubtitleController.removeListener(_subtitleListener);
  }

  void _mediaListener() {
    final newMedia = mediaController.media;
    if (newMedia != null && newMedia != mediaNotifier.value) {
      mediaNotifier.value = newMedia;
      playerVideoController.changeMedia(newMedia);
      playerSubtitleController.changeMedia(newMedia);
    }

    if (newMedia is Episode) return;

    final seasons = mediaController.seasons;
    if (seasons != seasonsNotifier.value) {
      seasonsNotifier.value = seasons;
    }

    final episode = mediaController.episode;
    if (episode != episodeNotifier.value) {
      episodeNotifier.value = episode;
    }
  }

  void _videoListener() {
    final newVideo = playerVideoController.video;
    if (newVideo != null && newVideo != videoNotifier.value) {
      videoNotifier.value = newVideo;
    }

    final videos = playerVideoController.videos;
    if (videos != videosListNotifier.value) {
      videosListNotifier.value = videos;
    }
  }

  void _subtitleListener() {
    final newSubtitle = playerSubtitleController.subtitle;
    if (newSubtitle != null && newSubtitle != subtitleNotifier.value) {
      subtitleNotifier.value = newSubtitle;
    }

    final subtitles = playerSubtitleController.subtitles;
    if (subtitles != subtitlesListNotifier.value) {
      subtitlesListNotifier.value = subtitles;
    }
  }
}
