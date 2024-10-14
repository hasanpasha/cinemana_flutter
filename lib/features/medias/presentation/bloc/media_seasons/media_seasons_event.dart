part of 'media_seasons_bloc.dart';

sealed class MediaSeasonsEvent extends Equatable {
  const MediaSeasonsEvent();

  @override
  List<Object> get props => [];
}

final class MediaSeasonsRequested extends MediaSeasonsEvent {
  final Media media;

  const MediaSeasonsRequested(this.media);

  @override
  List<Object> get props => [media];
}
