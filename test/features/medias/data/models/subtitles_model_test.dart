import 'dart:convert';

import 'package:cinemana/features/medias/data/models/subtitle_model.dart';
import 'package:cinemana/features/medias/data/models/subtitles_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sealed_languages/sealed_languages.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tFirstSubtitleModel = SubtitleModel(
    url:
        "https://cnth2.shabakaty.com/vascin-translation-files/A1125DD8-8817-9614-FA9F-E95E8DF365C3_ar_transfile.srt?response-cache-control=max-age%3D86400&AWSAccessKeyId=PSFBSAZRKNBJOAMKHHBIBOBEONKBBOPKEDDBFBOJCH&Expires=1730069882&Signature=56t0oJiLwYE%2FBe8qNXR%2BT7Bln%2Bw%3D",
    name: "arabic",
    language: LangAra(),
    subtitleKind: 'srt',
  );

  const tSubtitlesModel = SubtitlesModel([tFirstSubtitleModel]);

  group('fromJson', () {
    test(
        'should return a valid Subtitles model which contains non empty list of subtitles',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('subtitles.json'));

      // act
      final result = SubtitlesModel.fromJson(jsonMap);

      // assert
      expect(result.subtitles.first, equals(tSubtitlesModel.subtitles.first));
      expect(result.subtitles.isEmpty, isFalse);
    });

    test(
        'should return a valid Subtitles model which contains empty list of subtitles',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('subtitles_no_key.json'));

      // act
      final result = SubtitlesModel.fromJson(jsonMap);

      // assert
      expect(result.subtitles.isEmpty, isTrue);
    });
  });
}
