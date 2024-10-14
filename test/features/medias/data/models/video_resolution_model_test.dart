import 'dart:convert';

import 'package:cinemana/features/medias/data/models/video_resolution_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tVideoResolution = VideoResolutionModel.p240;

  group('fromName', () {
    test(
        'should return a valid model when the there is an enum with the same name',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('video.json'));

      // act
      final result = VideoResolutionModel.fromName(jsonMap['resolution']);

      // assert
      expect(result, equals(tVideoResolution));
    });
  });
}
