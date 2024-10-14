import 'package:flutter/material.dart';

import '../../../../../injection_container.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/get_videos.dart';
import '../models/player_media.dart';

class PlayerVideoController extends ChangeNotifier {
  PlayerVideoController({
    this.defaultVideoResolution,
  });

  final GetVideos getVideos = sl();
  VideoResolution? defaultVideoResolution;

  PlayerVideo? video;
  List<PlayerVideo>? videos;

  // String? error;

  // void _notifyAnError(String message) {
  //   error = message;
  //   notifyListeners();
  // }

  Future<void> changeMedia(Media media) async {
    final result = await getVideos(media);
    result.fold(
      (failure) {
        // _notifyAnError(failure.toString());
      },
      (newVideos) {
        videos = newVideos.map(PlayerVideo.fromVideoEntity).toList();
        // notifyListeners();

        _selectNewPlayerMedia(
          videos: videos!,
          videoResolution: defaultVideoResolution,
        );
      },
    );
  }

  void _selectNewPlayerMedia({
    required List<PlayerVideo> videos,
    VideoResolution? videoResolution,
  }) {
    PlayerVideo? newVideo;

    for (final video in videos) {
      if (video.resolution == videoResolution) {
        newVideo = video;
        break;
      }
    }

    newVideo ??= videos.first;

    video = newVideo;
    notifyListeners();
  }
}
