// Mocks generated by Mockito 5.4.4 from annotations
// in cinemana/test/features/medias/domain/usecases/get_seasons_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:cinemana/core/error/failure.dart' as _i5;
import 'package:cinemana/features/medias/domain/entities/entities.dart' as _i6;
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart'
    as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MediasRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMediasRepository extends _i1.Mock implements _i3.MediasRepository {
  MockMediasRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Medias>> search({
    required String? query,
    _i6.MediaKind? kind,
    int? page,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #search,
          [],
          {
            #query: query,
            #kind: kind,
            #page: page,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Medias>>.value(
            _FakeEither_0<_i5.Failure, _i6.Medias>(
          this,
          Invocation.method(
            #search,
            [],
            {
              #query: query,
              #kind: kind,
              #page: page,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Medias>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Video>>> getVideos(
          {required _i6.Media? media}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getVideos,
          [],
          {#media: media},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, List<_i6.Video>>>.value(
            _FakeEither_0<_i5.Failure, List<_i6.Video>>(
          this,
          Invocation.method(
            #getVideos,
            [],
            {#media: media},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Video>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Subtitle>>> getSubtitles(
          {required _i6.Media? media}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSubtitles,
          [],
          {#media: media},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Subtitle>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Subtitle>>(
          this,
          Invocation.method(
            #getSubtitles,
            [],
            {#media: media},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Subtitle>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Season>>> getSeasons(
          {required _i6.Media? media}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSeasons,
          [],
          {#media: media},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Season>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Season>>(
          this,
          Invocation.method(
            #getSeasons,
            [],
            {#media: media},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Season>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Media>> getInfo(
          {required _i6.Media? media}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getInfo,
          [],
          {#media: media},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Media>>.value(
            _FakeEither_0<_i5.Failure, _i6.Media>(
          this,
          Invocation.method(
            #getInfo,
            [],
            {#media: media},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Media>>);
}
