import 'package:cinemana/core/network/network_info/network_info.dart';
import 'package:cinemana/features/medias/data/data_sources/medias_local_data_source.dart';
import 'package:cinemana/features/medias/domain/usecases/get_info.dart';
import 'package:cinemana/features/medias/domain/usecases/get_seasons.dart';
import 'package:cinemana/features/medias/presentation/bloc/media_info/media_info_bloc.dart';
import 'package:cinemana/features/medias/presentation/bloc/media_player_data/media_player_data_bloc.dart';
import 'package:cinemana/features/medias/presentation/bloc/media_seasons/media_seasons_bloc.dart';
import 'package:dio/dio.dart';
// import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/medias/data/data_sources/medias_remote_data_source.dart';
import 'features/medias/data/repositories/medias_repository_impl.dart';
import 'features/medias/domain/repositories/medias_repository.dart';
import 'features/medias/domain/usecases/get_subtitles.dart';
import 'features/medias/domain/usecases/get_videos.dart';
import 'features/medias/domain/usecases/search_medias.dart';
import 'features/medias/presentation/bloc/medias/medias_bloc.dart';

final sl = GetIt.instance;

void init() {
  //! Features - Medias
  // Bloc
  sl.registerFactory<MediasBloc>(
    () => MediasBloc(
      searchMedias: sl(),
    ),
  );

  sl.registerFactory<MediaPlayerDataBloc>(
    () => MediaPlayerDataBloc(
      getVideos: sl(),
      getSubtitles: sl(),
    ),
  );

  sl.registerFactory<MediaInfoBloc>(
    () => MediaInfoBloc(getInfo: sl()),
  );

  sl.registerFactory<MediaSeasonsBloc>(
    () => MediaSeasonsBloc(getSeasons: sl()),
  );

  // Usecases
  sl.registerFactory<SearchMedias>(() => SearchMedias(sl()));
  sl.registerFactory<GetVideos>(() => GetVideos(sl()));
  sl.registerFactory<GetSubtitles>(() => GetSubtitles(sl()));
  sl.registerFactory<GetSeasons>(() => GetSeasons(sl()));
  sl.registerFactory<GetInfo>(() => GetInfo(sl()));

  // Data Repository
  sl.registerLazySingleton<MediasRepository>(
    () => MediasRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
    ),
  );

  // DataSources

  sl.registerLazySingleton<MediasRemoteDataSource>(
    () => MediasRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<MediasLocalDataSource>(
    () => MediasLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  // Util

  // Network
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  //! External
  // sl.registerLazySingleton<CacheStore>(() => MemCacheStore());
  // sl.registerLazySingleton<CacheOptions>(() => CacheOptions(store: sl()));
  sl.registerLazySingleton<Dio>(() {
    return Dio();
    // ..interceptors.add(DioCacheInterceptor(options: sl()));
  });

  sl.registerLazySingleton<SharedPreferencesAsync>(() {
    return SharedPreferencesAsync();
  });

  sl.registerLazySingleton<InternetConnectionChecker>(() {
    return InternetConnectionChecker();
  });
}
