import 'dart:convert';

import 'package:cinemana/features/medias/data/data_sources/medias_remote_data_source.dart';
import 'package:cinemana/features/medias/data/models/media_kind_model.dart';
import 'package:cinemana/features/medias/data/models/medias_model.dart';
import 'package:cinemana/features/medias/data/repositories/medias_repository_impl.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'medias_repository_impl_test.mocks.dart';

@GenerateMocks([MediasRemoteDataSource])
void main() {
  late MediasRepositoryImpl repository;
  late MockMediasRemoteDataSource mockMediasRemoteDataSource;

  setUp(() {
    mockMediasRemoteDataSource = MockMediasRemoteDataSource();
    repository = MediasRepositoryImpl(remote: mockMediasRemoteDataSource);
  });

  group('SearchMedias', () {
    const tQuery = "The Day After Tomorrow";
    late MediasModel tMedias;

    setUp(() {
      final list = json.decode(fixture('medias.json'));
      tMedias = MediasModel.fromJson(list);
    });

    test('should get remote data when the call is successful', () async {
      // arrange
      when(mockMediasRemoteDataSource.search(
        query: anyNamed('query'),
        kind: anyNamed('kind'),
        page: anyNamed('page'),
      )).thenAnswer((_) async => tMedias);

      // act
      final result = await repository.search(
          query: tQuery, kind: MediaKind.movies, page: 1);

      // assert
      verify(mockMediasRemoteDataSource.search(
          query: tQuery, kind: MediaKindModel.movies, page: 1));
      expect(result, equals(Right(tMedias)));
    });
  });
}
