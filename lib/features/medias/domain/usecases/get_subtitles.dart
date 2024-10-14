import 'package:cinemana/core/error/failure.dart';
import 'package:cinemana/core/usecases/usecase.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/subtitle.dart';
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart';
import 'package:dartz/dartz.dart';

class GetSubtitles extends Usecase<List<Subtitle>, Media> {
  GetSubtitles(this.repository);

  final MediasRepository repository;

  @override
  Future<Either<Failure, List<Subtitle>>> call(Media params) async {
    return await repository.getSubtitles(media: params);
  }
}
