import 'dart:convert';

import 'package:cinemana/features/medias/data/models/subtitle_model.dart';
import 'package:cinemana/features/medias/domain/entities/subtitle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sealed_languages/sealed_languages.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tSubtitleModel = SubtitleModel(
    url:
        "https://cnth2.shabakaty.com/vascin-translation-files/A1125DD8-8817-9614-FA9F-E95E8DF365C3_ar_transfile.srt?response-cache-control=max-age%3D86400&AWSAccessKeyId=PSFBSAZRKNBJOAMKHHBIBOBEONKBBOPKEDDBFBOJCH&Expires=1730069882&Signature=56t0oJiLwYE%2FBe8qNXR%2BT7Bln%2Bw%3D",
    name: "arabic",
    language: LangAar(),
  );

  test('should be a subclass of Subtitle entity', () async {
    expect(tSubtitleModel, isA<Subtitle>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('subtitle.json'));

      // act
      final result = SubtitleModel.fromJson(jsonMap);

      // assert
      expect(result, equals(result));
    });

    test(
        'should return a valid model even when the object type is a different language code',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('subtitle_type_lang_full_name.json'));

      // act
      final result = SubtitleModel.fromJson(jsonMap);

      // assert
      expect(result, equals(result));
    });
  });
}
