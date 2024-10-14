import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/usecases/get_subtitles.dart';
import 'package:cinemana/features/medias/presentation/widgets/models/player_subtitle.dart';
import 'package:cinemana/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:sealed_languages/sealed_languages.dart';

class PlayerSubtitleController extends ChangeNotifier {
  PlayerSubtitleController({
    this.defaultSubtitleLanguage,
    this.defaultSubtitleExtension,
  });

  final GetSubtitles getSubtitles = sl();
  NaturalLanguage? defaultSubtitleLanguage;
  String? defaultSubtitleExtension;

  PlayerSubtitle? subtitle;
  List<PlayerSubtitle>? subtitles;

  // String? error;

  // void _notifyAnError(String message) {
  //   error = message;
  //   notifyListeners();
  // }

  Future<void> changeMedia(Media media) async {
    final result = await getSubtitles(media);
    result.fold(
      (failure) {
        // _notifyAnError(failure.toString());
      },
      (newSubtitles) {
        subtitles =
            newSubtitles.map(PlayerSubtitle.fromSubtitleEntity).toList();
        // notifyListeners();

        _selectNewPlayerSubtitle(
          subtitles: subtitles!,
          language: defaultSubtitleLanguage,
          subtitleExtension: defaultSubtitleExtension,
        );
      },
    );
  }

  void _selectNewPlayerSubtitle({
    required List<PlayerSubtitle> subtitles,
    NaturalLanguage? language,
    String? subtitleExtension,
  }) {
    PlayerSubtitle? newSubtitle;

    for (final subtitle in subtitles) {
      if (language != null) {
        if (subtitle.nLanguage == language) {
          newSubtitle = subtitle;
          break;
        }
      }
    }
    if ((subtitleExtension != null && language != null) ||
        (newSubtitle == null && subtitleExtension != null)) {
      for (final subtitle in subtitles) {
        if (subtitle.nLanguage == language &&
            subtitle.extension == subtitleExtension) {
          newSubtitle = subtitle;
          break;
        }
      }
    }

    newSubtitle ??= subtitles.firstOrNull;

    subtitle = newSubtitle;
    notifyListeners();
  }
}
