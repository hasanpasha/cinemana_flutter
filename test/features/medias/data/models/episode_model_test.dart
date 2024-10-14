import 'dart:convert';

import 'package:cinemana/features/medias/data/models/episode_model.dart';
import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tEpisodeModel = EpisodeModel(
    number: 24,
    id: "224402",
    title: "Tensei shitara Slime Datta Ken",
    year: 2018,
    seasonNumber: 1,
    isSpecial: false,
  );

  test('should be a subclass of Episode entity', () async {
    expect(tEpisodeModel, isA<Episode>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('episode.json'));

      // act
      final result = EpisodeModel.fromJson(jsonMap);

      // assert
      expect(result, equals(tEpisodeModel));
    });
  });
}
