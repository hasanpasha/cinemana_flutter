import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sealed_languages/sealed_languages.dart';

import '../../../features/medias/domain/entities/entities.dart';
import '../../../features/medias/domain/usecases/get_subtitles.dart';
import '../../../features/medias/presentation/widgets/models/player_subtitle.dart';
import '../../../injection_container.dart';
import '../extensions.dart';
import 'media_provider.dart';
import 'series_provider.dart';

class AvailableSubtitles extends StateNotifier<List<PlayerSubtitle>?> {
  AvailableSubtitles(super.state);

  void add(PlayerSubtitle newSubtitle) {
    final newSubs = state
      ?..toSet()
      ..add(newSubtitle);
    state = newSubs;
  }
}

final availableSubtitlesProvider =
    StateNotifierProvider<AvailableSubtitles, List<PlayerSubtitle>?>(
  (ref) => AvailableSubtitles(
    ref.watch(allSubtitlesProvider).valueOrNull,
  ),
);

final allSubtitlesProvider = FutureProvider<List<PlayerSubtitle>?>((ref) async {
  final GetSubtitles getSubtitles = sl();

  Media? currentMedia;

  final episode = ref.watch(seriesControllerProvider);
  final media = ref.watch(mediaProvider);

  if (episode != null) {
    currentMedia = episode.episode;
  } else if (media != null) {
    currentMedia = media;
  }

  if (currentMedia == null) return null;

  final result = await getSubtitles(currentMedia);
  return result.unwrapRight()?.map(PlayerSubtitle.fromSubtitleEntity).toList();
});

final subtitleLanguageProvider =
    StateProvider<NaturalLanguage?>((ref) => const LangAra());
final subtitleKindProvider = StateProvider<String?>((ref) => 'ass');

final subtitleProvider = StateProvider<PlayerSubtitle?>((ref) {
  final subtitlesValue = ref.watch(allSubtitlesProvider);
  final subtitleLanguage = ref.watch(subtitleLanguageProvider);
  final subtitleKind = ref.watch(subtitleKindProvider);

  if (!subtitlesValue.hasValue) return null;
  final subtitles = subtitlesValue.value;
  if (subtitles == null) return null;
  if (subtitleLanguage != null) {
    for (final subtitle in subtitles) {
      if (subtitle.nLanguage == subtitleLanguage) {
        if (subtitleKind == null) return subtitle;
        if (subtitle.extension == subtitleKind) return subtitle;
      }
    }
  }
  return subtitles.firstOrNull;
});
