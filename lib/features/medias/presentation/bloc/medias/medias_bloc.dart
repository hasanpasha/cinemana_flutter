import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/search_medias.dart';

part 'medias_event.dart';
part 'medias_state.dart';

class MediasBloc extends Bloc<MediasEvent, MediasState> {
  final SearchMedias searchMedias;

  final log = Logger('MediasBloc');

  MediasBloc({
    required this.searchMedias,
  }) : super(EmptyMediasState()) {
    on<GetMediasBySearch>(onGetMediasBySearch, transformer: restartable());
  }

  Future<void> onGetMediasBySearch(
    GetMediasBySearch event,
    Emitter<MediasState> emit,
  ) async {
    await searchMedias(Params(
      query: event.query,
      kind: event.kind,
      page: event.page,
    )).then(
      (result) {
        if (emit.isDone) return;

        log.info("[GetMediasBySearch] got result $result");
        return result.fold(
          (failure) =>
              emit(const SearchMediasState(status: LoadMediasStatus.failure)),
          (medias) => emit(SearchMediasState(
            status: LoadMediasStatus.success,
            medias: medias.medias,
            hasNext: medias.hasNext,
            page: event.page,
          )),
        );
      },
    );
  }

  Stream<T> getStateStream<T extends MediasState>() =>
      stream.where((state) => (state is T)).map((state) => state as T);
}
