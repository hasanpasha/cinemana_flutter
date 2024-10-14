import 'dart:convert';

import 'package:cinemana/core/error/exceptions.dart';
import 'package:cinemana/features/medias/data/data_sources/medias_remote_data_source.dart';
import 'package:cinemana/features/medias/data/models/media_model.dart';
import 'package:cinemana/features/medias/data/models/medias_model.dart';
import 'package:cinemana/features/medias/data/models/seasons_model.dart';
import 'package:cinemana/features/medias/data/models/subtitles_model.dart';
import 'package:cinemana/features/medias/data/models/video_model.dart';
import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'medias_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MediasRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = MediasRemoteDataSourceImpl(dio: mockDio);
  });

  group('search', () {
    void setUpMockDioSuccess200() {
      when(mockDio.get('/AdvancedSearch',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: json.decode(fixture('medias.json')),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
    }

    void setUpMockDioFailure404() {
      when(mockDio.get('/AdvancedSearch',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                statusCode: 404,
                requestOptions: RequestOptions(),
              ));
    }

    const tQuery = "The Day After Tomorrow";
    final tMediasModel =
        MediasModel.fromJson(json.decode(fixture('medias.json')));

    test('''should perform a GET request with a number as the path
        and with Content-Type header set to application/json''', () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      await dataSource.search(query: tQuery);

      // assert
      verify(mockDio.get('/AdvancedSearch', queryParameters: {
        'videoTitle': tQuery,
        'type': 'movies',
        'page': 0
      }));
    });

    test('should return medias when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      final result = await dataSource.search(query: tQuery);

      // assert
      expect(result, tMediasModel);
    });

    test(
        'should throw a server exception when the response code is not 200 (failure)',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.search(query: tQuery);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });

    test(
        'should throw a server exception when the http client throws an exception',
        () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      // act
      call() async => await dataSource.search(query: tQuery);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });
  });

  group('getVideos', () {
    void setUpMockDioSuccess200() {
      when(mockDio.get('/transcoddedFiles/id/21'))
          .thenAnswer((_) async => Response(
                data: json.decode(fixture('videos.json')),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
    }

    void setUpMockDioFailure404() {
      when(mockDio.get('/transcoddedFiles/id/21'))
          .thenAnswer((_) async => Response(
                statusCode: 404,
                requestOptions: RequestOptions(),
              ));
    }

    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);
    final tVideosModel = (json.decode(fixture('videos.json')) as List)
        .map((e) => VideoModel.fromJson(e));

    test('''should perform a GET request with a number as the path
        and with Content-Type header set to application/json''', () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      await dataSource.getVideos(tMedia.id);

      // assert
      verify(mockDio.get('/transcoddedFiles/id/${tMedia.id}'));
    });

    test('should return medias when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      final result = await dataSource.getVideos(tMedia.id);

      // assert
      expect(result, tVideosModel);
    });

    test(
        'should throw a server exception when the response code is not 200 (failure)',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getVideos(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });

    test(
        'should throw a server exception when the http client throws an exception',
        () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      // act
      call() async => await dataSource.getVideos(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });
  });

  group('getSubtitles', () {
    void setUpMockDioSuccess200() {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: json.decode(fixture('subtitles.json')),
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));
    }

    void setUpMockDioFailure404() {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            statusCode: 404,
            requestOptions: RequestOptions(),
          ));
    }

    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.movies, year: 2001);
    final SubtitlesModel tSubtitlesModel =
        SubtitlesModel.fromJson(json.decode(fixture('subtitles.json')));

    test('''should perform a GET request with the correct path
        and with Content-Type header set to application/json''', () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      await dataSource.getSubtitles(tMedia.id);

      // assert
      verify(mockDio.get("/translationFiles/id/${tMedia.id}"));
    });

    test(
        'should return subtitles model when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      final result = await dataSource.getSubtitles(tMedia.id);

      // assert
      expect(result, equals(tSubtitlesModel));
    });

    test(
        'should throw a server exception when the response code is not 200 (failure)',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getSubtitles(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });

    test(
        'should throw a server exception when the http client throws an exception',
        () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      // act
      call() async => await dataSource.getSubtitles(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });
  });

  group('getSeasons', () {
    void setUpMockDioSuccess200() {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: json.decode(fixture('seasons.json')),
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));
    }

    void setUpMockDioFailure404() {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            statusCode: 404,
            requestOptions: RequestOptions(),
          ));
    }

    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.series, year: 2001);
    late final SeasonsModel tSeasonsModel = SeasonsModel.fromJson(
        json.decode(fixture('seasons.json')).cast<Map<String, dynamic>>());

    test('''should perform a GET request with the correct path
        and with Content-Type header set to application/json''', () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      await dataSource.getSeasons(tMedia.id);

      // assert
      verify(mockDio.get("/videoSeason/id/${tMedia.id}"));
    });

    test(
        'should return subtitles model when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      final result = await dataSource.getSeasons(tMedia.id);

      // assert
      expect(result, equals(tSeasonsModel));
    });

    test(
        'should throw a server exception when the response code is not 200 (failure)',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getSeasons(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });

    test(
        'should throw a server exception when the http client throws an exception',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getSeasons(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });
  });

  group('getInfo', () {
    void setUpMockDioSuccess200() {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: json.decode(fixture('media_more.json')),
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));
    }

    void setUpMockDioFailure404() {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            statusCode: 404,
            requestOptions: RequestOptions(),
          ));
    }

    const tMedia =
        Media(id: "21", title: "test", kind: MediaKind.series, year: 2001);
    late final tMediaMore =
        MediaModel.fromJson(json.decode(fixture("media_more.json")));

    test('''should perform a GET request with the correct path
        and with Content-Type header set to application/json''', () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      await dataSource.getInfo(tMedia.id);

      // assert
      verify(mockDio.get("/allVideoInfo/id/${tMedia.id}"));
    });

    test('should return info model when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      final result = await dataSource.getInfo(tMedia.id);

      // assert
      expect(result, equals(tMediaMore));
    });

    test(
        'should throw a server exception when the response code is not 200 (failure)',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getInfo(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });

    test(
        'should throw a server exception when the http client throws an exception',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getInfo(tMedia.id);

      // assert
      await expectLater(call, throwsA(isA<ServerException>()));
    });
  });
}
