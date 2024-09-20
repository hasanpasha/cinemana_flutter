import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/media_kind.dart';
import '../../domain/usecases/search_medias.dart';
import 'package:equatable/equatable.dart';

part 'medias_event.dart';
part 'medias_state.dart';

class MediasBloc extends Bloc<MediasEvent, MediasState> {
  final SearchMedias searchMedias;

  MediasBloc({required this.searchMedias}) : super(EmptyMediasState()) {
    on<GetMediasBySearch>(_onGetMediasBySearch, transformer: restartable());
  }

  Future<void> _onGetMediasBySearch(
      GetMediasBySearch event, Emitter<MediasState> emit) async {
    await searchMedias(Params(
      query: event.query,
      kind: event.kind,
      page: event.page,
    )).then(
      (result) {
        if (emit.isDone) return;
        return result.fold(
          (failure) => emit(
              const LoadedSearchMediasState(status: LoadMediasStatus.failure)),
          (medias) {
            debugPrint("got result bloc for $event");
            debugPrint("issuing LoadedSearchMediasState");
            emit(LoadedSearchMediasState(
              status: LoadMediasStatus.success,
              medias: medias.medias,
              hasNext: medias.hasNext,
              page: event.page,
            ));
          },
        );
      },
    );
  }

  Stream<T> getStateStream<T extends MediasState>() =>
      stream.where((state) => (state is T)).map((state) => state as T);
}
