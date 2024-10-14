import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart';
import 'package:cinemana/features/medias/domain/usecases/get_seasons.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_seasons_test.mocks.dart';

@GenerateMocks([MediasRepository])
void main() {
  late final MockMediasRepository mockMediasRepository = MockMediasRepository();
  late final GetSeasons usecase = GetSeasons(mockMediasRepository);

  const tSeasons = <Season>[
    Season(number: 1, episodes: <Episode>[
      Episode(number: 1, id: "1222", title: "The day after", year: 2021)
    ]),
  ];

  test('should get list of seasons for the media', () async {
    // arrange
    const media =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);

    when(mockMediasRepository.getSeasons(media: anyNamed('media')))
        .thenAnswer((_) async => const Right(tSeasons));

    // act
    final result = await usecase(media);

    // assert
    expect(result, equals(const Right(tSeasons)));
    verify(mockMediasRepository.getSeasons(media: media));
    verifyNoMoreInteractions(mockMediasRepository);
  });
}
