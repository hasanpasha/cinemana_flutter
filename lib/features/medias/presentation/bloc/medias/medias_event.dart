part of 'medias_bloc.dart';

sealed class MediasEvent extends Equatable {
  const MediasEvent();

  @override
  List<Object> get props => [];
}

class GetMediasBySearch extends MediasEvent {
  const GetMediasBySearch({required this.query, this.kind, this.page});

  final String query;
  final MediaKind? kind;
  final int? page;

  @override
  List<Object> get props => [query];
}

final class GetMediaSeasons extends MediasEvent {
  const GetMediaSeasons(this.media);

  final Media media;

  @override
  List<Object> get props => [media];
}
