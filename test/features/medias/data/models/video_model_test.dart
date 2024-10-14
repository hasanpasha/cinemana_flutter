import 'dart:convert';

import 'package:cinemana/features/medias/data/models/video_model.dart';
import 'package:cinemana/features/medias/data/models/video_resolution_model.dart';
import 'package:cinemana/features/medias/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tVideoModel = VideoModel(
    url:
        "https://cdn.shabakaty.com/vascin24-mp4/C3B1134F-A137-220B-968D-110912F5FF76_video.mp4?response-content-disposition=attachment%3B%20filename%3D%22video.mp4%22&AWSAccessKeyId=PSFBSAZRKNBJOAMKHHBIBOBEONKBBOPKEDDBFBOJCH&Expires=1727559379&Signature=5Nc%2Fr3ozcJNqp4pup42iSlqQWrI%3D",
    resolutionModel: VideoResolutionModel.p240,
  );

  test('should be a subclass of Media entity', () async {
    expect(tVideoModel, isA<Video>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('video.json'));

      // act
      final result = VideoModel.fromJson(jsonMap);

      // assert
      expect(result, equals(result));
    });
  });
}
