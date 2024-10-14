part of 'media_info_bloc.dart';

sealed class MediaInfoState extends Equatable {
  const MediaInfoState();

  @override
  List<Object> get props => [];
}

final class MediaInfoInitial extends MediaInfoState {}

final class MediaInfoLoaded extends MediaInfoState {
  final Media media;

  const MediaInfoLoaded(this.media);

  @override
  List<Object> get props => [media];
}

final class MediaInfoLoading extends MediaInfoState {
  const MediaInfoLoading();
}

final class MediaInfoError extends MediaInfoState {
  final String message;

  const MediaInfoError(this.message);

  @override
  List<Object> get props => [message];
}
