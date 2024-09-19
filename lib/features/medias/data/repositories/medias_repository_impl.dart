import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/media_kind.dart';
import '../../domain/entities/medias.dart';
import '../../domain/repositories/medias_repository.dart';
import '../data_sources/medias_remote_data_source.dart';
import '../models/media_kind_model.dart';

class MediasRepositoryImpl implements MediasRepository {
  final MediasRemoteDataSource remote;

  MediasRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, Medias>> search({
    required String query,
    MediaKind? kind,
    int? page,
  }) async {
    MediaKindModel? kindModel;
    if (kind != null) {
      kindModel = MediaKindModel.fromEntity(kind);
    }
    try {
      final result =
          await remote.search(query: query, kind: kindModel, page: page);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
