part of 'media_player_data_bloc.dart';

sealed class MediaPlayerDataState extends Equatable {
  const MediaPlayerDataState();

  @override
  List<Object> get props => [];
}

final class MediaPlayerDataInitial extends MediaPlayerDataState {}

final class MediaPlayerDataLoaded extends MediaPlayerDataState {
  final List<Video> videos;
  final List<Subtitle> subtitles;

  const MediaPlayerDataLoaded({
    required this.videos,
    List<Subtitle>? subtitles,
  }) : subtitles = subtitles ?? const [];

  @override
  List<Object> get props => [videos, subtitles];
}

final class MediaPlayerDataLoading extends MediaPlayerDataState {
  const MediaPlayerDataLoading();
}

final class MediaPlayerDataError extends MediaPlayerDataState {
  final String message;

  const MediaPlayerDataError(this.message);
}
