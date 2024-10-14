import 'dart:convert';

import 'package:cinemana/features/medias/data/models/episode_model.dart';
import 'package:cinemana/features/medias/data/models/seasons_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tFirstEpisodeModel = EpisodeModel(
    number: 1,
    id: "224352",
    title: "Tensei shitara Slime Datta Ken",
    year: 2018,
    seasonNumber: 1,
    isSpecial: true,
  );

  group('fromJson', () {
    test('should return a valid model', () async {
      // arrange
      final List jsonMapList = json.decode(fixture('seasons.json'));

      // act
      final result = SeasonsModel.fromJson(jsonMapList.cast());

      // assert
      final resultFirstSeason = result.seasons.first;
      final resultFirstEpisode = resultFirstSeason.episodes.first;
      final resultLastSeason = result.seasons.last;
      final resultLastSeasonLastEpisode = resultLastSeason.episodes.last;
      expect(result.seasons.length, equals(4));
      expect(resultFirstSeason.episodes.last.number, equals(25));
      expect(resultFirstSeason.episodes.length, equals(25));
      expect(resultLastSeason.number, equals(4));
      expect(resultLastSeasonLastEpisode.number, equals(23));
      expect(resultFirstEpisode, equals(tFirstEpisodeModel));
    });
  });
}
