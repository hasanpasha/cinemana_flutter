import 'package:cinemana/features/medias/domain/entities/video_resolution.dart';
import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({required this.url, required this.resolution});

  final String url;
  final VideoResolution resolution;

  @override
  List<Object?> get props => [url, resolution];
}
