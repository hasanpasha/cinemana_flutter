import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:cinemana/features/medias/domain/entities/subtitle.dart';
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart';
import 'package:cinemana/features/medias/domain/usecases/get_subtitles.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sealed_languages/sealed_languages.dart';

import 'get_videos_test.mocks.dart';

@GenerateMocks([MediasRepository])
void main() {
  late final mockMediasRepository = MockMediasRepository();
  late final GetSubtitles usecase = GetSubtitles(mockMediasRepository);

  const tSubtitles = [
    Subtitle(url: "url1", name: "ass", language: LangAra()),
    Subtitle(url: "url2", name: "srt", language: LangEng()),
  ];
  const tMedia =
      Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);

  test('should get a list of subtitles', () async {
    // arrange
    when(mockMediasRepository.getSubtitles(media: anyNamed('media')))
        .thenAnswer((_) async => const Right(tSubtitles));

    // act
    final result = await usecase(tMedia);

    // assert
    verify(mockMediasRepository.getSubtitles(media: tMedia));
    verifyNoMoreInteractions(mockMediasRepository);
    expect(result, equals(const Right(tSubtitles)));
  });
}
