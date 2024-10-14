import 'package:cinemana/core/error/failure.dart';
import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';

class GetInfo extends Usecase<Media, Media> {
  final MediasRepository repository;

  GetInfo(this.repository);

  @override
  Future<Either<Failure, Media>> call(Media params) async {
    return await repository.getInfo(media: params);
  }
}
