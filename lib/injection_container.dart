import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/medias/data/data_sources/medias_remote_data_source.dart';
import 'features/medias/data/repositories/medias_repository_impl.dart';
import 'features/medias/domain/repositories/medias_repository.dart';
import 'features/medias/domain/usecases/search_medias.dart';
import 'features/medias/presentation/bloc/medias_bloc.dart';

final sl = GetIt.instance;

void init() {
  //! Features - Medias
  // Bloc
  sl.registerFactory(
    () => MediasBloc(searchMedias: sl()),
  );

  // Usecases
  sl.registerFactory(() => SearchMedias(sl()));

  // Data Repository
  sl.registerLazySingleton<MediasRepository>(
    () => MediasRepositoryImpl(remote: sl()),
  );

  // DataSources

  sl.registerLazySingleton<MediasRemoteDataSource>(
    () => MediasRemoteDataSourceImpl(dio: sl()),
  );

  //! Core
  // Util

  // Network

  //! External
  sl.registerLazySingleton(() => Dio());
}
