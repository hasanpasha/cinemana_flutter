import 'dart:convert';

import 'package:cinemana/core/error/exceptions.dart';
import 'package:cinemana/core/error/failure.dart';
import 'package:cinemana/core/network/network_info/network_info.dart';
import 'package:cinemana/features/medias/data/data_sources/medias_local_data_source.dart';
import 'package:cinemana/features/medias/data/data_sources/medias_remote_data_source.dart';
import 'package:cinemana/features/medias/data/models/media_kind_model.dart';
import 'package:cinemana/features/medias/data/models/media_model.dart';
import 'package:cinemana/features/medias/data/models/medias_model.dart';
import 'package:cinemana/features/medias/data/models/seasons_model.dart';
import 'package:cinemana/features/medias/data/models/subtitles_model.dart';
import 'package:cinemana/features/medias/data/models/video_model.dart';
import 'package:cinemana/features/medias/data/repositories/medias_repository_impl.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'medias_repository_impl_test.mocks.dart';

@GenerateMocks([MediasRemoteDataSource, MediasLocalDataSource, NetworkInfo])
void main() {
  late final MediasRepositoryImpl repository;
  late final MockMediasRemoteDataSource mockMediasRemoteDataSource;
  late final MockMediasLocalDataSource mockMediasLocalDataSource;
  late final MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockMediasRemoteDataSource = MockMediasRemoteDataSource();
    mockMediasLocalDataSource = MockMediasLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MediasRepositoryImpl(
      remote: mockMediasRemoteDataSource,
      local: mockMediasLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
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

    test('should get server failure when the call throws an exception',
        () async {
      // arrange
      when(mockMediasRemoteDataSource.search(
        query: anyNamed('query'),
        kind: anyNamed('kind'),
        page: anyNamed('page'),
      )).thenThrow(ServerException());

      // act
      final result = await repository.search(
          query: tQuery, kind: MediaKind.movies, page: 1);

      // assert
      verify(mockMediasRemoteDataSource.search(
          query: tQuery, kind: MediaKindModel.movies, page: 1));
      expect(result, Left(ServerFailure()));
    });
  });

  group('GetVideos', () {
    late List<VideoModel> tVideos;
    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);

    setUp(() {
      final list = json.decode(fixture('videos.json')) as List;
      tVideos = list.map((e) => VideoModel.fromJson(e)).toList();
    });

    test('should get remote data when the call is successful', () async {
      // arrange
      when(mockMediasRemoteDataSource.getVideos(any))
          .thenAnswer((_) async => tVideos);

      // act
      final result = await repository.getVideos(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getVideos(tMedia.id));
      expect(result, equals(Right(tVideos)));
    });

    test('should get server failure when the call throws an exception',
        () async {
      // arrange
      when(mockMediasRemoteDataSource.getVideos(any))
          .thenThrow(ServerException());

      // act
      final result = await repository.getVideos(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getVideos(tMedia.id));
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('GetSubtitles', () {
    late SubtitlesModel tSubtitlesModel;
    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);

    setUp(() {
      final subs = json.decode(fixture('subtitles.json'));
      tSubtitlesModel = SubtitlesModel.fromJson(subs);
    });

    test('should get remote data when the call is successful', () async {
      // arrange
      when(mockMediasRemoteDataSource.getSubtitles(any))
          .thenAnswer((_) async => tSubtitlesModel);

      // act
      final result = await repository.getSubtitles(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getSubtitles(tMedia.id));
      expect(result, equals(Right(tSubtitlesModel.subtitles)));
    });

    test('should get server failure when the call throws an exception',
        () async {
      // arrange
      when(mockMediasRemoteDataSource.getSubtitles(any))
          .thenThrow(ServerException());

      // act
      final result = await repository.getSubtitles(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getSubtitles(tMedia.id));
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('GetSeasons', () {
    late SeasonsModel tSeasonsModel;
    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);

    setUp(() {
      final subs = json.decode(fixture('seasons.json'));
      tSeasonsModel = SeasonsModel.fromJson(subs.cast<Map<String, dynamic>>());
    });

    test('should get remote data when the call is successful', () async {
      // arrange
      when(mockMediasRemoteDataSource.getSeasons(any))
          .thenAnswer((_) async => tSeasonsModel);

      // act
      final result = await repository.getSeasons(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getSeasons(tMedia.id));
      expect(result, equals(Right(tSeasonsModel.seasons)));
    });

    test('should get server failure when the call throws an exception',
        () async {
      // arrange
      when(mockMediasRemoteDataSource.getSeasons(any))
          .thenThrow(ServerException());

      // act
      final result = await repository.getSeasons(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getSeasons(tMedia.id));
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('GetInfo', () {
    late MediaModel tMediaMoreInfo;
    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);

    setUp(() {
      tMediaMoreInfo =
          MediaModel.fromJson(json.decode(fixture('media_more.json')));
    });

    test('should get remote data when the call is successful', () async {
      // arrange
      when(mockMediasRemoteDataSource.getInfo(any))
          .thenAnswer((_) async => tMediaMoreInfo);

      // act
      final result = await repository.getInfo(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getInfo(tMedia.id));
      expect(result, equals(Right(tMediaMoreInfo)));
    });

    test('should get server failure when the call throws an exception',
        () async {
      // arrange
      when(mockMediasRemoteDataSource.getInfo(any))
          .thenThrow(ServerException());

      // act
      final result = await repository.getInfo(media: tMedia);

      // assert
      verify(mockMediasRemoteDataSource.getInfo(tMedia.id));
      expect(result, equals(Left(ServerFailure())));
    });
  });
}
