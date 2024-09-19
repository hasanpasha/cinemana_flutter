import 'dart:convert';

import 'package:cinemana/features/medias/data/models/media_kind_model.dart';
import 'package:cinemana/features/medias/data/models/media_model.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMediaModel = MediaModel(
    id: "29067",
    title: "The Day After Tomorrow",
    kindModel: MediaKindModel.movies,
    year: 2004,
    poster:
        "https://cnth2.shabakaty.com/vascin-poster-images/5D6C8011-CEEC-F42D-03E2-997D52FB8212_poster.jpg",
    thumbnail:
        "https://cnth2.shabakaty.com/vascin-poster-images/5D2C3F65-8DEF-69FE-4D0E-61E70CAD39AE_poster_medium_thumb.jpg",
  );

  test('should be a subclass of Media entity', () async {
    expect(tMediaModel, isA<Media>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('media.json'));

      // act
      final result = MediaModel.fromJson(jsonMap);

      // assert
      expect(result, equals(result));
    });

    test(
      'should return a Media model with with null `poster` and `thumbnail` fields',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('media_no_poster.json'));

        // act
        final result = MediaModel.fromJson(jsonMap);

        // assert
        expect(result.poster, isNull);
        expect(result.thumbnail, isNull);
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tMediaModel.toJson();

      // assert
      final expectedMap = {
        "nb": "29067",
        "en_title": "The Day After Tomorrow",
        "year": "2004",
        "kind": "1",
        "imgObjUrl":
            "https://cnth2.shabakaty.com/vascin-poster-images/5D6C8011-CEEC-F42D-03E2-997D52FB8212_poster.jpg",
        "imgMediumThumbObjUrl":
            "https://cnth2.shabakaty.com/vascin-poster-images/5D2C3F65-8DEF-69FE-4D0E-61E70CAD39AE_poster_medium_thumb.jpg",
      };
      expect(result, expectedMap);
    });
  });
}
