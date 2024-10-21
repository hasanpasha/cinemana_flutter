import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/medias/data/data_sources/medias_local_data_source.dart';
import '../../../features/medias/data/data_sources/medias_remote_data_source.dart';
import '../../../features/medias/data/repositories/medias_repository_impl.dart';
import '../../../features/medias/domain/repositories/medias_repository.dart';
import '../../../features/medias/domain/usecases/get_info.dart';
import '../../../features/medias/domain/usecases/get_seasons.dart';
import '../../../features/medias/domain/usecases/get_subtitles.dart';
import '../../../features/medias/domain/usecases/get_videos.dart';
import '../../../features/medias/domain/usecases/search_medias.dart';
import '../../network/network_info/network_info.dart';

final searchMediasUsecaseProvider = Provider<SearchMedias>((ref) {
  final repository = ref.watch(mediasRepositoryProvider);

  return SearchMedias(repository);
});

final getVideosUsecaseProvider = Provider<GetVideos>((ref) {
  final repository = ref.watch(mediasRepositoryProvider);

  return GetVideos(repository);
});

final getSubtitlesUsecaseProvider = Provider<GetSubtitles>((ref) {
  final repository = ref.watch(mediasRepositoryProvider);

  return GetSubtitles(repository);
});

final getInfoUsecaseProvider = Provider<GetInfo>((ref) {
  final repository = ref.watch(mediasRepositoryProvider);

  return GetInfo(repository);
});

final getSeasonsUsecaseProvider = Provider<GetSeasons>((ref) {
  final repository = ref.watch(mediasRepositoryProvider);

  return GetSeasons(repository);
});

final mediasRepositoryProvider = Provider<MediasRepository>((ref) {
  final remote = ref.watch(mediasRemoteDataSourceProvider);
  final local = ref.watch(mediasLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return MediasRepositoryImpl(
      remote: remote, local: local, networkInfo: networkInfo);
});

final mediasRemoteDataSourceProvider = Provider<MediasRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);

  return MediasRemoteDataSourceImpl(dio: dio);
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final mediasLocalDataSourceProvider = Provider((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);

  return MediasLocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final sharedPreferencesProvider = Provider<SharedPreferencesAsync>((ref) {
  return SharedPreferencesAsync();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectionChecker = ref.watch(connectionCheckerProvider);

  return NetworkInfoImpl(connectionChecker: connectionChecker);
});

final connectionCheckerProvider = Provider<InternetConnectionChecker>((ref) {
  return InternetConnectionChecker();
});
