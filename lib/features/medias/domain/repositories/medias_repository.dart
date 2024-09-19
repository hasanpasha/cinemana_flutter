import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/media_kind.dart';
import '../entities/medias.dart';

abstract class MediasRepository {
  Future<Either<Failure, Medias>> search({
    required String query,
    MediaKind? kind,
    int? page,
  });
}
