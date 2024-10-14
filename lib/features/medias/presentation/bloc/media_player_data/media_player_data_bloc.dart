import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/domain/usecases/get_subtitles.dart';
import 'package:cinemana/features/medias/domain/usecases/get_videos.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

part 'media_player_data_event.dart';
part 'media_player_data_state.dart';

class MediaPlayerDataBloc
    extends Bloc<MediaPlayerDataEvent, MediaPlayerDataState> {
  static final logger = Logger('MediaPlayerDataBloc');

  final GetVideos getVideos;
  final GetSubtitles getSubtitles;

  MediaPlayerDataBloc({
    required this.getVideos,
    required this.getSubtitles,
  }) : super(MediaPlayerDataInitial()) {
    on<MediaPlayerDataRequested>(
      transformer: restartable(),
      (event, emit) async {
        logger.info("getting data for ${event.media}");

        emit(const MediaPlayerDataLoading());
        await getVideos(event.media).then((videosResult) async {
          if (emit.isDone) return;
          await videosResult.fold(
            (failure) async => emit(MediaPlayerDataError(failure.toString())),
            (videos) async {
              if (emit.isDone) return;
              await getSubtitles(event.media).then((subtitlesResult) async {
                subtitlesResult.fold(
                  (failure) => emit(MediaPlayerDataError(failure.toString())),
                  (subtitles) => emit(
                    MediaPlayerDataLoaded(videos: videos, subtitles: subtitles),
                  ),
                );
              });
            },
          );
        });
      },
    );
  }
}
