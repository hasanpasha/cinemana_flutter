part of 'media_info_bloc.dart';

sealed class MediaInfoEvent extends Equatable {
  const MediaInfoEvent();

  @override
  List<Object> get props => [];
}

final class MediaInfoRequested extends MediaInfoEvent {
  final Media media;

  const MediaInfoRequested(this.media);

  @override
  List<Object> get props => [media];
}
