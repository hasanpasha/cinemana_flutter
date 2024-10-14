import '../entities/media.dart';
import '../repositories/medias_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video.dart';

class GetVideos implements Usecase<List<Video>, Media> {
  GetVideos(this.repository);

  final MediasRepository repository;

  @override
  Future<Either<Failure, List<Video>>> call(Media media) async {
    return await repository.getVideos(media: media);
  }
}
