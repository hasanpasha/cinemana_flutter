part of 'medias_bloc.dart';

enum LoadMediasStatus { initial, success, failure }

sealed class MediasState extends Equatable {
  const MediasState();

  @override
  List<Object?> get props => [];
}

final class EmptyMediasState extends MediasState {}

sealed class MediasListState extends MediasState {
  final LoadMediasStatus status;
  final List<Media> medias;
  final bool hasNext;
  final int page;

  const MediasListState({
    this.status = LoadMediasStatus.initial,
    this.medias = const <Media>[],
    this.hasNext = false,
    int? page,
  }) : page = page ?? 1;

  @override
  List<Object> get props => [status, medias, hasNext, page];
}

final class SearchMediasState extends MediasListState {
  const SearchMediasState(
      {super.status, super.medias, super.hasNext, super.page});
}
