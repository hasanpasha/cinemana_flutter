import 'dart:convert';

import 'package:cinemana/core/error/exceptions.dart';
import 'package:cinemana/features/medias/data/data_sources/medias_remote_data_source.dart';
import 'package:cinemana/features/medias/data/models/medias_model.dart';
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

  void setUpMockDioSuccess200() {
    when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
              data: fixture('medias.json'),
              statusCode: 200,
              requestOptions: RequestOptions(),
            ));
  }

  void setUpMockDioFailure404() {
    when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
              statusCode: 404,
              requestOptions: RequestOptions(),
            ));
  }

  group('getConcreteNumberTrivia', () {
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
}
