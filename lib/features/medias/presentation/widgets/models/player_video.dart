import 'package:cinemana/features/medias/domain/entities/video.dart';
import 'package:cinemana/features/medias/domain/entities/video_resolution.dart';
import 'package:media_kit/media_kit.dart';

class PlayerVideo extends Media {
  PlayerVideo({required String url, required this.resolution}) : super(url);

  final VideoResolution resolution;

  factory PlayerVideo.fromVideoEntity(Video video) => PlayerVideo(
        url: video.url,
        resolution: video.resolution,
      );

  @override
  String toString() => resolution.name;
}
