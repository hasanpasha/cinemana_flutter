import '../../../domain/entities/video.dart';
import '../../../domain/entities/video_resolution.dart';
import 'player_media.dart';

class PlayerMediaList {
  PlayerMediaList({
    required this.medias,
    required PlayerVideo defaultMedia,
    this.onChanged,
    this.onDefaultMediaSelected,
  }) : media = defaultMedia {
    onDefaultMediaSelected?.call(media);
  }

  final Function(PlayerVideo)? onChanged;
  final Function(PlayerVideo)? onDefaultMediaSelected;

  final List<PlayerVideo> medias;
  PlayerVideo media;

  PlayerVideo get currentMedia => media;
  set currentMedia(PlayerVideo media) {
    this.media = media;
    onChanged?.call(media);
  }

  factory PlayerMediaList.fromVideoEntityList({
    required List<Video> videos,
    final VideoResolution? resolution,
    final Function(PlayerVideo)? onChanged,
    final Function(PlayerVideo)? onDefaultMediaSelected,
  }) {
    final medias = videos.map(PlayerVideo.fromVideoEntity).toList();
    final defaultMedia = medias.firstWhere(
      (e) => e.resolution == resolution,
      orElse: () => medias.first,
    );
    return PlayerMediaList(
      medias: medias,
      defaultMedia: defaultMedia,
      onChanged: onChanged,
      onDefaultMediaSelected: onDefaultMediaSelected,
    );
  }
}
