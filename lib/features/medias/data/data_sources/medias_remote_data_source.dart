import 'package:cinemana/features/medias/data/models/media_model.dart';
import 'package:cinemana/features/medias/data/models/seasons_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/media_kind_model.dart';
import '../models/medias_model.dart';
import '../models/subtitles_model.dart';
import '../models/video_model.dart';

abstract class MediasRemoteDataSource {
  /// Calls the https://cinemana.shabakaty.com/api/android/AdvancedSearch?videoTitle={}&type={}&page={}
  ///
  /// Throws a [ServerException] on failure
  Future<MediasModel> search({
    required String query,
    MediaKindModel? kind,
    int? page,
  });

  /// Calls the https://cinemana.shabakaty.com/api/android/latest{Kind}/level/1/itemsPerPage/20/page/{}/
  ///
  /// Throws a [ServerException] on failure
  Future<MediasModel> getLatest({MediaKindModel? kind, int? page});

  /// Calls the https://cinemana.shabakaty.com/api/android/transcoddedFiles/id/{}
  ///
  /// Throws a [ServerException] on failure
  Future<List<VideoModel>> getVideos(String id);

  /// Calls the https://cinemana.shabakaty.com/api/android/translationFiles/id/{}
  ///
  /// Throws a [ServerException] on failure
  Future<SubtitlesModel> getSubtitles(String id);

  /// Call the https://cinemana.shabakaty.com/api/android/videoSeason/id/{}
  ///
  /// Throws a [ServerException] on failure
  Future<SeasonsModel> getSeasons(String id);

  /// Call the https://cinemana.shabakaty.com/api/android/allVideoInfo/id/{}
  ///
  /// Throws a [ServerException] on failure
  Future<MediaModel> getInfo(String id);
}

class MediasRemoteDataSourceImpl implements MediasRemoteDataSource {
  final Dio dio;

  MediasRemoteDataSourceImpl({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: "https://cinemana.shabakaty.com/api/android",
    );
  }

  @override
  Future<MediasModel> search({
    required String query,
    MediaKindModel? kind,
    int? page,
  }) async {
    kind ??= MediaKindModel.movies;
    page ??= 1;

    try {
      final result = await dio.get('/AdvancedSearch', queryParameters: {
        'videoTitle': query,
        'type': kind.name,
        'page': page - 1
      });
      if (result.statusCode != 200) throw ServerException();
      return MediasModel.fromJson(result.data);
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<MediasModel> getLatest({MediaKindModel? kind, int? page}) async {
    kind ??= MediaKindModel.movies;
    page ??= 1;

    final latestKind = kind == MediaKindModel.movies ? "Movies" : "Series";

    try {
      print("getting latest medias data");
      final result = await dio
          .get('/latest$latestKind/level/1/itemsPerPage/20/page/$page/');
      if (result.statusCode != 200) throw ServerException();
      print(result.data);
      return MediasModel.fromJson(result.data);
    } on DioException {
      throw ServerException();
    }

    // https://cinemana.shabakaty.com/api/android
  }

  @override
  Future<List<VideoModel>> getVideos(String id) async {
    try {
      final result = await dio.get('/transcoddedFiles/id/$id');
      if (result.statusCode != 200) throw ServerException();
      return (result.data as List).map((e) => VideoModel.fromJson(e)).toList();
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<SubtitlesModel> getSubtitles(String id) async {
    try {
      final result = await dio.get('/translationFiles/id/$id');
      if (result.statusCode != 200) throw ServerException();
      return SubtitlesModel.fromJson(result.data);
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<SeasonsModel> getSeasons(String id) async {
    try {
      final result = await dio.get('/videoSeason/id/$id');
      if (result.statusCode != 200) throw ServerException();
      return SeasonsModel.fromJson(result.data.cast<Map<String, dynamic>>());
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<MediaModel> getInfo(String id) async {
    try {
      final result = await dio.get('/allVideoInfo/id/$id');
      if (result.statusCode != 200) throw ServerException();
      return MediaModel.fromJson(result.data);
    } on DioException {
      throw ServerException();
    }
  }
}
