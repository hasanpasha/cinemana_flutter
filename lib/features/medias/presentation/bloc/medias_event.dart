part of 'medias_bloc.dart';

sealed class MediasEvent extends Equatable {
  const MediasEvent();

  @override
  List<Object> get props => [];
}

class GetMediasBySearch extends MediasEvent {
  final String query;
  final MediaKind? kind;
  final int? page;

  const GetMediasBySearch({required this.query, this.kind, this.page});

  @override
  List<Object> get props => [query];
}
