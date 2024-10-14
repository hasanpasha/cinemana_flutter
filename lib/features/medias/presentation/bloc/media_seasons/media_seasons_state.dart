part of 'media_seasons_bloc.dart';

sealed class MediaSeasonsState extends Equatable {
  const MediaSeasonsState();

  @override
  List<Object> get props => [];
}

final class MediaSeasonsInitial extends MediaSeasonsState {}

final class MediaSeasonsLoaded extends MediaSeasonsState {
  final List<Season> seasons;

  const MediaSeasonsLoaded(this.seasons);

  @override
  List<Object> get props => [seasons];
}

final class MediaSeasonsLoading extends MediaSeasonsState {
  const MediaSeasonsLoading();
}

final class MediaSeasonsError extends MediaSeasonsState {
  final String message;

  const MediaSeasonsError(this.message);

  @override
  List<Object> get props => [message];
}
