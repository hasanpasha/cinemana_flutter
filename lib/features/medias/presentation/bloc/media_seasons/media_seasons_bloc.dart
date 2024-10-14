import 'package:bloc/bloc.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/season.dart';
import 'package:cinemana/features/medias/domain/usecases/get_seasons.dart';
import 'package:equatable/equatable.dart';

part 'media_seasons_event.dart';
part 'media_seasons_state.dart';

class MediaSeasonsBloc extends Bloc<MediaSeasonsEvent, MediaSeasonsState> {
  final GetSeasons getSeasons;

  MediaSeasonsBloc({required this.getSeasons}) : super(MediaSeasonsInitial()) {
    on<MediaSeasonsRequested>((event, emit) async {
      emit(const MediaSeasonsLoading());
      // await Future.delayed(
      //   const Duration(seconds: 3),
      //   () => ,
      // );
      await getSeasons(event.media).then(
        (result) {
          if (emit.isDone) return;
          result.fold(
            (failure) => emit(MediaSeasonsError(failure.toString())),
            (seasons) => emit(MediaSeasonsLoaded(seasons)),
          );
        },
      );
    });
  }
}
