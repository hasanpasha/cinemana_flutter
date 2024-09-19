import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media_kind.dart';
import '../entities/medias.dart';
import '../repositories/medias_repository.dart';

class SearchMedias implements Usecase<Medias, Params> {
  final MediasRepository repository;

  SearchMedias(this.repository);

  @override
  Future<Either<Failure, Medias>> call(Params params) async {
    return await repository.search(
        query: params.query, kind: params.kind, page: params.page);
  }
}

class Params {
  final String query;
  final MediaKind? kind;
  final int? page;

  Params({required this.query, this.kind, this.page});
}
