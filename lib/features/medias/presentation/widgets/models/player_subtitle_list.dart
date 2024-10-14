import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:cinemana/features/medias/presentation/widgets/models/player_subtitle.dart';
import 'package:sealed_languages/sealed_languages.dart';

class PlayerSubtitleList {
  PlayerSubtitleList({
    required this.subtitles,
    required PlayerSubtitle? defaultSubtitle,
    this.onChanged,
  }) : subtitle = defaultSubtitle {
    onChanged?.call(subtitle);
  }

  final Set<PlayerSubtitle> subtitles;
  PlayerSubtitle? subtitle;

  final Function(PlayerSubtitle?)? onChanged;

  bool add(PlayerSubtitle newSubtitle) {
    return subtitles.add(newSubtitle);
  }

  PlayerSubtitle? get currentSubtitle => subtitle;
  set currentSubtitle(PlayerSubtitle? subtitle) {
    subtitle != null ? add(subtitle) : {};
    this.subtitle = subtitle;
    onChanged?.call(subtitle);
  }

  factory PlayerSubtitleList.fromSubtitleEntityList({
    required List<Subtitle> subtitles,
    NaturalLanguage? defaultLanguage,
    String? defaultSubtitleKind,
    Function(PlayerSubtitle?)? onChanged,
  }) {
    final playerSubtitles =
        subtitles.map(PlayerSubtitle.fromSubtitleEntity).toSet();
    PlayerSubtitle? defaultSubtitle;
    for (var subtitle in playerSubtitles) {
      if (defaultLanguage != null) {
        if (subtitle.nLanguage != defaultLanguage) continue;
      }
      if (defaultSubtitleKind != null) {
        if (subtitle.extension != defaultSubtitleKind) continue;
      }
      defaultSubtitle = subtitle;
      break;
    }
    defaultSubtitle ??= playerSubtitles.firstOrNull ?? PlayerSubtitle.none();

    return PlayerSubtitleList(
      subtitles: playerSubtitles,
      defaultSubtitle: defaultSubtitle,
      onChanged: onChanged,
    );
  }
}
