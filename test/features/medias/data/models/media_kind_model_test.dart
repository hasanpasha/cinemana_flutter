import 'dart:convert';

import 'package:cinemana/features/medias/data/models/media_kind_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tMediaKindModel = MediaKindModel.movies;

  // group('fromName', () {
  //   test(
  //       'should return a valid model when the there is an enum with the same name',
  //       () async {
  //     // arrange
  //     final Map<String, dynamic> jsonMap = json.decode(fixture('media.json'));

  //     // act
  //     final result = MediaKindModel.fromName(jsonMap['kind']);

  //     // assert
  //     expect(result, tMediaKindModel);
  //   });
  // });

  group('fromNumber', () {
    test(
        'should return a valid model when the there is an enum with the same number',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('media.json'));

      // act
      final result = MediaKindModel.fromNumber(jsonMap['kind']);

      // assert
      expect(result, tMediaKindModel);
    });
  });
}
