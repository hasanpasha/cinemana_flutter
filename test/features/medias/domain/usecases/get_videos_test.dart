import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:cinemana/features/medias/domain/entities/video_resolution.dart';
import 'package:cinemana/features/medias/domain/entities/video.dart';
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart';
import 'package:cinemana/features/medias/domain/usecases/get_videos.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_videos_test.mocks.dart';

@GenerateMocks([MediasRepository])
void main() {
  late MockMediasRepository mockMediasRepository;
  late GetVideos usecase;

  setUp(() {
    mockMediasRepository = MockMediasRepository();
    usecase = GetVideos(mockMediasRepository);
  });

  const tVideos = <Video>[
    Video(url: "url1", resolution: VideoResolution.p144),
    Video(url: "url2", resolution: VideoResolution.p720),
  ];

  test('should get list of video for the media', () async {
    // arrange
    const media =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);

    when(mockMediasRepository.getVideos(media: anyNamed('media')))
        .thenAnswer((_) async => const Right(tVideos));

    // act
    final result = await usecase(media);

    // assert
    expect(result, equals(const Right(tVideos)));
    verify(mockMediasRepository.getVideos(media: media));
    verifyNoMoreInteractions(mockMediasRepository);
  });
}
