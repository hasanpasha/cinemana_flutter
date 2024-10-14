import 'package:equatable/equatable.dart';

import 'episode_model.dart';
import 'season_model.dart';

class SeasonsModel extends Equatable {
  const SeasonsModel(this.seasons);

  final List<SeasonModel> seasons;

  factory SeasonsModel.fromJson(List<Map<String, dynamic>> mapList) {
    final episodes = mapList.map(EpisodeModel.fromJson).toList();
    final seasonsNumbers = episodes.map((e) => e.seasonNumber).toSet().toList();
    final List<SeasonModel> seasons = List.generate(
      seasonsNumbers.length, // numbers of seasons that there is
      (idx) => SeasonModel(
        number: seasonsNumbers[idx],
        episodes: episodes
            .where((episode) => episode.seasonNumber == seasonsNumbers[idx])
            .toList()
          ..sort((a, b) => a.number.compareTo(b.number)),
      ),
    )..sort((a, b) => a.number.compareTo(b.number));
    return SeasonsModel(seasons);
  }

  @override
  List<Object?> get props => [seasons];
}
