import 'package:cinemana/features/medias/data/models/media_model.dart';

import '../../domain/entities/entities.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.number,
    super.isSpecial,
    required super.id,
    required super.title,
    required super.year,
    super.poster,
    super.thumbnail,
    required this.seasonNumber,
  });

  final int seasonNumber;

  factory EpisodeModel.copyMediaModelWith(
    MediaModel media, {
    required int number,
    required int seasonNumber,
    bool isSpecial = false,
  }) =>
      EpisodeModel(
        number: number,
        isSpecial: isSpecial,
        seasonNumber: seasonNumber,
        id: media.id,
        title: media.title,
        year: media.year,
        poster: media.poster,
        thumbnail: media.thumbnail,
      );

  factory EpisodeModel.fromJson(Map<String, dynamic> map) {
    final media = MediaModel.fromJson(map);

    return EpisodeModel.copyMediaModelWith(
      media,
      number: int.parse(map['episodeNummer']),
      isSpecial: map['isSpecial'] == '1',
      seasonNumber: int.parse(map['season']),
    );
  }

  @override
  List<Object?> get props => [seasonNumber, super.props];
}
