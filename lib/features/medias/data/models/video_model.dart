import '../../domain/entities/video.dart';
import 'video_resolution_model.dart';

class VideoModel extends Video {
  VideoModel({required super.url, required this.resolutionModel})
      : super(resolution: resolutionModel.mapToEntity());

  final VideoResolutionModel resolutionModel;

  factory VideoModel.fromJson(Map<String, dynamic> map) => VideoModel(
        url: map['videoUrl'],
        resolutionModel: VideoResolutionModel.fromName(map['resolution']!),
      );
}
