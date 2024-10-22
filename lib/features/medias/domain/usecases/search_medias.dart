import 'package:cinemana/features/medias/domain/usecases/common.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media_kind.dart';
import '../entities/medias.dart';
import '../repositories/medias_repository.dart';

class SearchMedias implements Usecase<Medias, SearchMediasParams> {
  final MediasRepository repository;

  SearchMedias(this.repository);

  @override
  Future<Either<Failure, Medias>> call(SearchMediasParams params) async {
    return await repository.search(
        query: params.query, kind: params.kind, page: params.page);
  }
}

class SearchMediasParams extends PagedParams {
  final String query;
  final MediaKind? kind;

  SearchMediasParams({
    required this.query,
    this.kind,
    super.page,
  });

  @override
  PagedParams copyWith({int? page}) => SearchMediasParams(
        query: query,
        kind: kind,
        page: page,
      );
}
