import 'package:media_kit/media_kit.dart';

import '../../../domain/entities/video.dart';
import '../../../domain/entities/video_resolution.dart';
import 'player_media.dart';

class PlayerPlaylist extends Playlist {
  PlayerPlaylist({
    required this.pMedias,
    super.index,
  }) : super(pMedias);

  final List<PlayerVideo> pMedias;

  PlayerVideo get currentMedia => pMedias[index];

  factory PlayerPlaylist.fromVideoEntityList({
    required List<Video> videos,
    VideoResolution? resolution,
  }) {
    int index = 0;
    videos.asMap().forEach((idx, media) {
      media.resolution == resolution ? index = idx : null;
    });

    final medias = videos.map(PlayerVideo.fromVideoEntity).toList();
    return PlayerPlaylist(pMedias: medias, index: index);
  }
}
