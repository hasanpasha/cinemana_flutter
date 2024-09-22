part of 'medias_bloc.dart';

enum LoadMediasStatus { initial, success, failure }

sealed class MediasState extends Equatable {
  final LoadMediasStatus status;
  final List<Media> medias;
  final bool hasNext;
  final int page;

  const MediasState({
    this.status = LoadMediasStatus.initial,
    this.medias = const <Media>[],
    this.hasNext = false,
    int? page,
  }) : page = page ?? 1;

  @override
  List<Object> get props => [status, medias, hasNext, page];
}

final class EmptyMediasState extends MediasState {}

final class SearchMediasState extends MediasState {
  const SearchMediasState(
      {super.status, super.medias, super.hasNext, super.page});
}
