import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/medias.dart';
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart';
import 'package:cinemana/features/medias/domain/usecases/search_medias.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_medias_test.mocks.dart';

@GenerateMocks([MediasRepository])
void main() {
  late MockMediasRepository mockMediasRepository;
  late SearchMedias usecase;

  const tQuery = "the day after";
  const tMedias = Medias(
    hasNext: false,
    medias: [
      Media(
          id: "$tQuery 1",
          title: "$tQuery 1",
          year: 2001,
          kind: MediaKind.movies),
      Media(
          id: "$tQuery 2",
          title: "$tQuery 2",
          year: 2002,
          kind: MediaKind.movies),
    ],
  );

  setUp(() {
    mockMediasRepository = MockMediasRepository();
    usecase = SearchMedias(mockMediasRepository);
  });

  test('should get a search result for the query', () async {
    // arrange
    when(mockMediasRepository.search(query: anyNamed('query')))
        .thenAnswer((_) async => const Right(tMedias));

    // act
    final result = await usecase(SearchMediasParams(query: tQuery));

    // assert
    expect(result, const Right(tMedias));
    verify(mockMediasRepository.search(query: tQuery));
    verifyNoMoreInteractions(mockMediasRepository);
  });
}
