part of 'media_player_data_bloc.dart';

sealed class MediaPlayerDataEvent extends Equatable {
  const MediaPlayerDataEvent();

  @override
  List<Object> get props => [];
}

final class MediaPlayerDataRequested extends MediaPlayerDataEvent {
  final Media media;

  const MediaPlayerDataRequested(this.media);

  @override
  List<Object> get props => [media];
}
