import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/media_kind_model.dart';
import '../models/medias_model.dart';

abstract class MediasRemoteDataSource {
  /// Calls the https://cinemana.shabakaty.com/api/android/AdvancedSearch?videoTitle={}&type={}&page={}
  ///
  /// Throws a [ServerException] on failure
  Future<MediasModel> search({
    required String query,
    MediaKindModel? kind,
    int? page,
  });
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
}
