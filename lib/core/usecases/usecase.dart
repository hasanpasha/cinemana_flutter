import 'package:dartz/dartz.dart';

import '../error/failure.dart';

abstract class Usecase<T, P> {
  Future<Either<Failure, T>> call(P params);
}
