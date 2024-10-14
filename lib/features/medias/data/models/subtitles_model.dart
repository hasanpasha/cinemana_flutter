import 'package:cinemana/features/medias/data/models/subtitle_model.dart';
import 'package:equatable/equatable.dart';

class SubtitlesModel extends Equatable {
  const SubtitlesModel(this.subtitles);

  final List<SubtitleModel> subtitles;

  factory SubtitlesModel.fromJson(Map<String, dynamic> map) {
    final List translationsList = (map['translations'] as List?) ?? [];

    final subtitles = translationsList
        .map((e) => SubtitleModel.fromJson(e))
        .where((e) => e.subtitleKind != 'vtt')
        .toList();

    return SubtitlesModel(subtitles);
  }

  @override
  List<Object?> get props => [subtitles];
}
