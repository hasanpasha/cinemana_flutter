import 'package:bloc_test/bloc_test.dart';
import 'package:cinemana/core/error/failure.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:cinemana/features/medias/domain/entities/medias.dart';
import 'package:cinemana/features/medias/domain/usecases/search_medias.dart';
import 'package:cinemana/features/medias/presentation/bloc/medias_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'medias_bloc_test.mocks.dart';

@GenerateMocks([SearchMedias])
void main() {
  late MockSearchMedias mockSearchMedias;
  late MediasBloc bloc;

  setUp(() {
    mockSearchMedias = MockSearchMedias();
    bloc = MediasBloc(searchMedias: mockSearchMedias);
  });

  MediasBloc buildBloc() => MediasBloc(searchMedias: mockSearchMedias);

  tearDown(() {
    bloc.close();
  });

  test('initial state should be empty', () async {
    // assert
    expect(bloc.state, equals(EmptyMediasState()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tQuery = "The Day After Tomorrow";
    const tMedias = Medias(hasNext: false, medias: [
      Media(id: "1", title: "The Day", kind: MediaKind.movies, year: 2021),
      Media(
          id: "2", title: "The Day After", kind: MediaKind.movies, year: 2024),
    ]);

    blocTest(
      'should emit [Loading, Loaded] when getting a concrete number and it succeeds',
      build: () => bloc,
      setUp: () => when(mockSearchMedias(any))
          .thenAnswer((_) async => const Right(tMedias)),
      act: (bloc) => bloc.add(const GetMediasBySearch(query: tQuery)),
      verify: (bloc) => verify(mockSearchMedias(Params(
          query: tQuery, kind: anyNamed('kind'), page: anyNamed('page')))),
      expect: () => [
        LoadingMediasState(),
        const LoadedSearchMediasState(medias: tMedias)
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting a concrete number and it fails',
      build: () => bloc,
      setUp: () => when(mockSearchMedias(any))
          .thenAnswer((_) async => Left(ServerFailure())),
      act: (bloc) => bloc.add(const GetMediasBySearch(query: tQuery)),
      verify: (bloc) => verify(mockSearchMedias(Params(query: tQuery))),
      expect: () => [
        LoadingMediasState(),
        ErrorMediasState(
          message: ServerFailure().toString(),
        ),
      ],
    );
  });
}
