import 'package:cinemana/features/medias/domain/usecases/common.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/medias_repository.dart';

class GetLatest extends Usecase<Medias, GetLatestParams> {
  GetLatest(this.repository);

  final MediasRepository repository;

  @override
  Future<Either<Failure, Medias>> call(GetLatestParams params) {
    return repository.getLatest(kind: params.kind, page: params.page);
  }
}

class GetLatestParams extends PagedParams {
  final MediaKind? kind;

  GetLatestParams({
    this.kind,
    super.page,
  });

  @override
  PagedParams copyWith({int? page}) => GetLatestParams(
        kind: kind,
        page: page,
      );
}
