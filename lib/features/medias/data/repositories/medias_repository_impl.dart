import 'package:cinemana/core/network/network_info/network_info.dart';
import 'package:cinemana/features/medias/data/data_sources/medias_local_data_source.dart';
import 'package:cinemana/features/medias/data/models/medias_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/medias_repository.dart';
import '../data_sources/medias_remote_data_source.dart';
import '../models/media_kind_model.dart';

class MediasRepositoryImpl implements MediasRepository {
  final MediasRemoteDataSource remote;
  final MediasLocalDataSource local;
  final NetworkInfo networkInfo;

  final log = Logger('MediasRepositoryImpl');

  MediasRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Medias>> search({
    required String query,
    MediaKind? kind,
    int? page,
  }) async {
    final kindModel = kind != null ? MediaKindModel.fromEntity(kind) : null;
    try {
      if (await networkInfo.isConnected) {
        log.info("getting data from remote");
        final result =
            await remote.search(query: query, kind: kindModel, page: page);
        final _ = await local.cacheSearchResult(result);
        return Right(result);
      } else {
        if (page == 1) {
          log.info("getting data from cache");
          final result = await local.getLastSearchResult();
          log.info("$result");
          return Right(result);
        } else if (page == 2) {
          return const Right(Medias(hasNext: false, medias: []));
        } else {
          throw ServerFailure();
        }
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getVideos({required Media media}) async {
    try {
      final result = await remote.getVideos(media.id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Subtitle>>> getSubtitles({
    required Media media,
  }) async {
    try {
      final result = await remote.getSubtitles(media.id);
      return Right(result.subtitles);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Season>>> getSeasons({
    required Media media,
  }) async {
    try {
      final result = await remote.getSeasons(media.id);
      return Right(result.seasons);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Media>> getInfo({required Media media}) async {
    try {
      final result = await remote.getInfo(media.id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
