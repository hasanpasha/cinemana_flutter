import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/entities.dart';

abstract class MediasRepository {
  Future<Either<Failure, Medias>> search({
    required String query,
    MediaKind? kind,
    int? page,
  });

  Future<Either<Failure, List<Video>>> getVideos({required Media media});

  Future<Either<Failure, List<Subtitle>>> getSubtitles({required Media media});

  Future<Either<Failure, List<Season>>> getSeasons({required Media media});

  Future<Either<Failure, Media>> getInfo({required Media media});
}
