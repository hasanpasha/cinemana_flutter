import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart';
import 'package:cinemana/features/medias/domain/usecases/get_info.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_info_test.mocks.dart';

@GenerateMocks([MediasRepository])
void main() {
  late final MockMediasRepository mockMediasRepository;
  late final GetInfo usecase;

  setUp(() {
    mockMediasRepository = MockMediasRepository();
    usecase = GetInfo(mockMediasRepository);
  });

  const tMedia =
      Media(id: "id", title: "title", kind: MediaKind.movies, year: 2000);
  const tMediaMore = Media(
    id: "id",
    title: "title",
    kind: MediaKind.movies,
    year: 2000,
    description: "sasa",
    rate: 9.1,
  );

  test('should get more info', () async {
    // arrange
    when(mockMediasRepository.getInfo(media: anyNamed('media')))
        .thenAnswer((_) async => const Right(tMediaMore));

    // act
    final result = await usecase(tMedia);

    // assert
    verify(mockMediasRepository.getInfo(media: tMedia));
    expect(result, equals(const Right(tMedia)));
  });
}
