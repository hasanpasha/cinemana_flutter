import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/medias_repository.dart';

class GetSeasons extends Usecase<List<Season>, Media> {
  GetSeasons(this.repository);

  final MediasRepository repository;

  @override
  Future<Either<Failure, List<Season>>> call(Media params) async {
    return await repository.getSeasons(media: params);
  }
}
