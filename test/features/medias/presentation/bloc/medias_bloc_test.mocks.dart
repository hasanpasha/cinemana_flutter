// Mocks generated by Mockito 5.4.4 from annotations
// in cinemana/test/features/medias/presentation/bloc/medias_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cinemana/core/error/failure.dart' as _i6;
import 'package:cinemana/features/medias/domain/entities/entities.dart' as _i14;
import 'package:cinemana/features/medias/domain/entities/media.dart' as _i10;
import 'package:cinemana/features/medias/domain/entities/medias.dart' as _i7;
import 'package:cinemana/features/medias/domain/entities/subtitle.dart' as _i12;
import 'package:cinemana/features/medias/domain/entities/video.dart' as _i9;
import 'package:cinemana/features/medias/domain/repositories/medias_repository.dart'
    as _i2;
import 'package:cinemana/features/medias/domain/usecases/get_info.dart' as _i15;
import 'package:cinemana/features/medias/domain/usecases/get_seasons.dart'
    as _i13;
import 'package:cinemana/features/medias/domain/usecases/get_subtitles.dart'
    as _i11;
import 'package:cinemana/features/medias/domain/usecases/get_videos.dart'
    as _i8;
import 'package:cinemana/features/medias/domain/usecases/search_medias.dart'
    as _i4;
import 'package:dartz/dartz.dart' as _i3;
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

class _FakeMediasRepository_0 extends _i1.SmartFake
    implements _i2.MediasRepository {
  _FakeMediasRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SearchMedias].
///
/// See the documentation for Mockito's code generation for more information.
class MockSearchMedias extends _i1.Mock implements _i4.SearchMedias {
  MockSearchMedias() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MediasRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeMediasRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.MediasRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.Medias>> call(_i4.Params? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i7.Medias>>.value(
            _FakeEither_1<_i6.Failure, _i7.Medias>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.Medias>>);
}

/// A class which mocks [GetVideos].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetVideos extends _i1.Mock implements _i8.GetVideos {
  MockGetVideos() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MediasRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeMediasRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.MediasRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i9.Video>>> call(
          _i10.Media? media) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [media],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, List<_i9.Video>>>.value(
            _FakeEither_1<_i6.Failure, List<_i9.Video>>(
          this,
          Invocation.method(
            #call,
            [media],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i9.Video>>>);
}

/// A class which mocks [GetSubtitles].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetSubtitles extends _i1.Mock implements _i11.GetSubtitles {
  MockGetSubtitles() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MediasRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeMediasRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.MediasRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i12.Subtitle>>> call(
          _i10.Media? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, List<_i12.Subtitle>>>.value(
                _FakeEither_1<_i6.Failure, List<_i12.Subtitle>>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i12.Subtitle>>>);
}

/// A class which mocks [GetSeasons].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetSeasons extends _i1.Mock implements _i13.GetSeasons {
  MockGetSeasons() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MediasRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeMediasRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.MediasRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i14.Season>>> call(
          _i10.Media? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, List<_i14.Season>>>.value(
                _FakeEither_1<_i6.Failure, List<_i14.Season>>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i14.Season>>>);
}

/// A class which mocks [GetInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetInfo extends _i1.Mock implements _i15.GetInfo {
  MockGetInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MediasRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeMediasRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.MediasRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i10.Media>> call(_i10.Media? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i10.Media>>.value(
            _FakeEither_1<_i6.Failure, _i10.Media>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i10.Media>>);
}
