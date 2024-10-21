import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/medias/domain/entities/entities.dart';
import '../extensions.dart';
import '../models/player_video.dart';
import 'media_provider.dart';
import 'series_provider.dart';
import 'usecases_providers.dart';

final availableVideoResolutionsProvider = Provider<Iterable<VideoResolution>?>(
  (ref) => ref
      .watch(allVideosProvider)
      .valueOrNull
      ?.map((video) => video.resolution),
);

final allVideosProvider = FutureProvider<List<PlayerVideo>?>((ref) async {
  final getVideos = ref.watch(getVideosUsecaseProvider);

  Media? currentMedia;

  final episode = ref.watch(seriesControllerProvider);
  final media = ref.watch(mediaProvider);

  if (episode != null) {
    currentMedia = episode.episode;
  } else if (media != null) {
    currentMedia = media;
  }

  if (currentMedia == null) return null;

  final result = await getVideos(currentMedia);
  return result.unwrapRight()?.map(PlayerVideo.fromVideoEntity).toList();
});

final videoResolutionProvider = StateProvider<VideoResolution>(
  (ref) => VideoResolution.p1080,
);

final videoProvider = Provider<PlayerVideo?>((ref) {
  final videosValue = ref.watch(allVideosProvider);
  final videoResolution = ref.watch(videoResolutionProvider);

  if (!videosValue.hasValue) return null;

  final videos = videosValue.value;
  if (videos == null) return null;

  PlayerVideo? playerVideo;
  for (final video in videos) {
    if (video.resolution == videoResolution) {
      playerVideo = video;
    }
  }
  playerVideo ??= videos.firstOrNull;

  return playerVideo;
});
