import 'package:bloc/bloc.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/usecases/get_info.dart';
import 'package:equatable/equatable.dart';

part 'media_info_event.dart';
part 'media_info_state.dart';

class MediaInfoBloc extends Bloc<MediaInfoEvent, MediaInfoState> {
  final GetInfo getInfo;

  MediaInfoBloc({required this.getInfo}) : super(MediaInfoInitial()) {
    on<MediaInfoRequested>((event, emit) async {
      emit(const MediaInfoLoading());
      // await Future.delayed(
      //   const Duration(seconds: 3),
      //   () => ,
      // );
      await getInfo(event.media).then((result) {
        if (emit.isDone) return;
        return result.fold(
          (failure) => emit(MediaInfoError(failure.toString())),
          (media) => emit(MediaInfoLoaded(media)),
        );
      });
    });
  }
}
