import 'package:bloc_test/bloc_test.dart';
import 'package:cinemana/core/error/failure.dart';
import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/domain/usecases/get_info.dart';
import 'package:cinemana/features/medias/domain/usecases/get_seasons.dart';
import 'package:cinemana/features/medias/domain/usecases/get_subtitles.dart';
import 'package:cinemana/features/medias/domain/usecases/get_videos.dart';
import 'package:cinemana/features/medias/domain/usecases/search_medias.dart';
import 'package:cinemana/features/medias/presentation/bloc/medias/medias_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sealed_languages/sealed_languages.dart';

import 'medias_bloc_test.mocks.dart';

@GenerateMocks([SearchMedias, GetVideos, GetSubtitles, GetSeasons, GetInfo])
void main() {
  late MockSearchMedias mockSearchMedias;
  late MockGetVideos mockGetVideos;
  late MockGetSubtitles mockGetSubtitles;
  late MockGetSeasons mockGetSeasons;
  late MockGetInfo mockGetInfo;
  late MediasBloc bloc;

  setUp(() {
    mockSearchMedias = MockSearchMedias();
    mockGetVideos = MockGetVideos();
    mockGetSubtitles = MockGetSubtitles();
    mockGetSeasons = MockGetSeasons();
    mockGetInfo = MockGetInfo();
    bloc = MediasBloc(
      searchMedias: mockSearchMedias,
      // getSeasons: mockGetSeasons,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be empty', () async {
    // assert
    expect(bloc.state, equals(EmptyMediasState()));
  });

  group('GetMediasBySearch', () {
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
      verify: (bloc) => expect(
          (verify(mockSearchMedias(captureAny)).captured[0] as Params).query,
          tQuery),
      expect: () => [
        SearchMediasState(
          status: LoadMediasStatus.success,
          medias: tMedias.medias,
          hasNext: tMedias.hasNext,
        )
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting a concrete number and it fails',
      build: () => bloc,
      setUp: () => when(mockSearchMedias(any))
          .thenAnswer((_) async => Left(ServerFailure())),
      act: (bloc) => bloc.add(const GetMediasBySearch(query: tQuery)),
      verify: (bloc) => expect(
          (verify(mockSearchMedias(captureAny)).captured[0] as Params).query,
          tQuery),
      expect: () => [
        const SearchMediasState(status: LoadMediasStatus.failure),
      ],
    );
  });

  group('GetMediaPlayerData', skip: true, () {
    const tMedia =
        Media(id: "1", title: "The Day", kind: MediaKind.movies, year: 2021);
    const tVideos = [
      Video(url: "url1", resolution: VideoResolution.p1080),
      Video(url: "url2", resolution: VideoResolution.p2160),
    ];
    const tSubtitles = [
      Subtitle(url: "url1", name: "arab", language: LangAra()),
    ];

    blocTest(
      'should emit [Loading, LoadedVideos] when getting videos and it succeeds',
      build: () => bloc,
      setUp: () {
        when(mockGetVideos(any)).thenAnswer((_) async => const Right(tVideos));
        when(mockGetSubtitles(any))
            .thenAnswer((_) async => const Right(tSubtitles));
      },
      // act: (bloc) => bloc.add(const GetMediaPlayerData(tMedia)),
      // verify: (bloc) => verify(mockGetVideos(tMedia)),
      // expect: () => [
      // const LoadingMediaPlayerDataState(),
      // const LoadedMediaPlayerDataState(
      // videos: tVideos, subtitles: tSubtitles),
      // ],
    );

    blocTest(
      'should emit [Loading, Error] when getting videos and it fails',
      build: () => bloc,
      setUp: () {
        when(mockGetVideos(any)).thenAnswer((_) async => Left(ServerFailure()));
        when(mockGetSubtitles(any))
            .thenAnswer((_) async => const Right(tSubtitles));
      },
      // act: (bloc) => bloc.add(const GetMediaPlayerData(tMedia)),
      verify: (bloc) {
        verify(mockGetVideos(tMedia));
        verifyNever(mockGetSubtitles(tMedia));
      },
      expect: () => [
        // const LoadingMediaPlayerDataState(),
        // ErrorMediaPlayerDataState(ServerFailure().toString()),
      ],
    );
  });

  // group('GetMediaSeasons', skip: true, () {
  //   const tMedia =
  //       Media(id: "1", title: "The Day", kind: MediaKind.movies, year: 2021);
  //   const tSeasons = [
  //     Season(
  //       number: 1,
  //       episodes: [
  //         Episode(number: 1, id: "111", title: "the day", year: 2000),
  //       ],
  //     ),
  //   ];

  //   blocTest(
  //     'should emit [Loading, LoadedSeasons] when getting seasons and it succeeds',
  //     build: () => bloc,
  //     setUp: () {
  //       when(mockGetSeasons(any))
  //           .thenAnswer((_) async => const Right(tSeasons));
  //     },
  //     act: (bloc) => bloc.add(const GetMediaSeasons(tMedia)),
  //     verify: (bloc) => verify(mockGetSeasons(tMedia)),
  //     expect: () => [
  //       const LoadingMediaSeasonsState(),
  //       const LoadedMediaSeasonsState(tSeasons),
  //     ],
  //   );

  //   blocTest(
  //     'should emit [Loading, Error] when getting videos and it fails',
  //     build: () => bloc,
  //     setUp: () {
  //       when(mockGetSeasons(any))
  //           .thenAnswer((_) async => Left(ServerFailure()));
  //     },
  //     act: (bloc) => bloc.add(const GetMediaSeasons(tMedia)),
  //     verify: (bloc) {
  //       verify(mockGetSeasons(tMedia));
  //     },
  //     expect: () => [
  //       const LoadingMediaSeasonsState(),
  //       ErrorMediaSeasonsState(ServerFailure().toString()),
  //     ],
  //   );
  // });

  group('GetMediaInfo', skip: true, () {
    const tMedia =
        Media(id: "1", title: "The Day", kind: MediaKind.movies, year: 2021);

    // blocTest(
    //   'should emit [Loading, LoadedInfo] when getting info and it succeeds',
    //   build: () => bloc,
    //   setUp: () {
    //     when(mockGetInfo(any)).thenAnswer((_) async => const Right(tMedia));
    //   },
    //   act: (bloc) => bloc.add(const GetMediaInfo(tMedia)),
    //   verify: (bloc) => verify(mockGetInfo(tMedia)),
    //   expect: () => [
    //     const LoadingMediaInfoState(),
    //     const LoadedMediaInfoState(tMedia),
    //   ],
    // );

    // blocTest(
    //   'should emit [Loading, Error] when getting info and it fails',
    //   build: () => bloc,
    //   setUp: () {
    //     when(mockGetInfo(any)).thenAnswer((_) async => Left(ServerFailure()));
    //   },
    //   act: (bloc) => bloc.add(const GetMediaInfo(tMedia)),
    //   verify: (bloc) {
    //     verify(mockGetInfo(tMedia));
    //   },
    //   expect: () => [
    //     const LoadingMediaInfoState(),
    //     ErrorMediaInfoState(ServerFailure().toString()),
    //   ],
    // );
  });
}
