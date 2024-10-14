import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/media_model.dart';
import '../models/medias_model.dart';
import '../models/seasons_model.dart';
import '../models/subtitles_model.dart';
import '../models/video_model.dart';

abstract class MediasLocalDataSource {
  Future<MediasModel> getLastSearchResult();

  Future<bool> cacheSearchResult(
    MediasModel medias,
  );

  Future<List<VideoModel>> getVideos(String id);

  Future<bool> cacheMediaVideos(String id, List<VideoModel> videos);

  Future<SubtitlesModel> getSubtitles(String id);

  Future<bool> cacheMediaSubtitles(String id, SubtitlesModel subtitles);

  Future<SeasonsModel> getSeasons(String id);

  Future<bool> cacheMediaSeasons(String id, SeasonsModel seasons);

  Future<MediaModel> getInfo(String id);

  Future<bool> cacheMediaInfo(MediaModel mediaModel);
}

class MediasLocalDataSourceImpl implements MediasLocalDataSource {
  MediasLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferencesAsync sharedPreferences;

  final log = Logger('MediasLocalDataSourceImpl');

  static const String dataKey = 'cachedData';
  static const String searchKey = '${dataKey}_searchData';
  static const String videosKey = '${dataKey}_videosData';

  @override
  Future<bool> cacheSearchResult(MediasModel medias) async {
    try {
      await sharedPreferences.setString(
        searchKey,
        json.encode(medias.toJson()),
      );
      return true;
    } catch (err) {
      log.warning('failed to cache search result: $err');
      return false;
    }
  }

  @override
  Future<MediasModel> getLastSearchResult() async {
    try {
      final data = await sharedPreferences.getString(searchKey);
      if (data == null) throw CacheException();
      final jsonData = json.decode(data);
      final medias = MediasModel.fromJson(jsonData).mediaModelList;
      log.info("got from cache $medias");
      return MediasModel(hasNext: false, mediaModelList: medias);
    } catch (err) {
      log.shout('failed to retrieve cached search result', err);
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheMediaInfo(MediaModel mediaModel) {
    // TODO: implement cacheMediaInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> cacheMediaSeasons(String id, SeasonsModel seasons) {
    // TODO: implement cacheMediaSeasons
    throw UnimplementedError();
  }

  @override
  Future<bool> cacheMediaSubtitles(String id, SubtitlesModel subtitles) {
    // TODO: implement cacheMediaSubtitles
    throw UnimplementedError();
  }

  @override
  Future<bool> cacheMediaVideos(String id, List<VideoModel> videos) {
    // TODO: implement cacheMediaVideos
    throw UnimplementedError();
  }

  @override
  Future<MediaModel> getInfo(String id) {
    // TODO: implement getInfo
    throw UnimplementedError();
  }

  @override
  Future<SeasonsModel> getSeasons(String id) {
    // TODO: implement getSeasons
    throw UnimplementedError();
  }

  @override
  Future<SubtitlesModel> getSubtitles(String id) {
    // TODO: implement getSubtitles
    throw UnimplementedError();
  }

  @override
  Future<List<VideoModel>> getVideos(String id) {
    // TODO: implement getVideos
    throw UnimplementedError();
  }
}
