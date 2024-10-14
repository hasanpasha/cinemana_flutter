import 'package:cinemana/features/medias/domain/entities/video_resolution.dart';

enum VideoResolutionModel {
  p144("144p"),
  p240("240p"),
  p360("360p"),
  p480("480p"),
  p720("720p"),
  p1080("1080p"),
  p2160("2160p"),
  unknown("unknown");

  const VideoResolutionModel(this.name);

  final String name;

  factory VideoResolutionModel.fromName(String name) {
    for (var value in values) {
      if (value.name == name) return value;
    }
    return VideoResolutionModel.unknown;
  }

  VideoResolution mapToEntity() => switch (this) {
        VideoResolutionModel.p144 => VideoResolution.p144,
        VideoResolutionModel.p240 => VideoResolution.p240,
        VideoResolutionModel.p360 => VideoResolution.p360,
        VideoResolutionModel.p480 => VideoResolution.p480,
        VideoResolutionModel.p720 => VideoResolution.p720,
        VideoResolutionModel.p1080 => VideoResolution.p1080,
        VideoResolutionModel.p2160 => VideoResolution.p2160,
        VideoResolutionModel.unknown => VideoResolution.unknown,
      };
}
