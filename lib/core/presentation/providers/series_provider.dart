import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/medias/domain/entities/entities.dart';
import '../../../features/medias/domain/usecases/get_seasons.dart';
import '../../../injection_container.dart';
import '../extensions.dart';
import 'media_provider.dart';

typedef SeasonEpisodePair = (Season, Episode);
typedef EpisodeEntries = DoubleLinkedQueue<SeasonEpisodePair>;
typedef EpisodeEntry = DoubleLinkedQueueEntry<SeasonEpisodePair>;

final allSeasonsProvider = FutureProvider<List<Season>?>((ref) async {
  final GetSeasons getSeasons = sl();

  final media = ref.watch(mediaProvider);

  if (media == null || media.kind == MediaKind.movies) return null;

  final result = await getSeasons(media);
  return result.unwrapRight();
});

class SeriesController extends ChangeNotifier {
  SeriesController({
    required List<Season> seasons,
  }) {
    _setEntries(seasons.toEpisodeEntries());
  }

  bool get hasNext => _entry.nextEntry() != null;
  bool get hasPrevious => _entry.previousEntry() != null;

  Season get season => _entry.element.$1;
  Episode get episode => _entry.element.$2;
  set episode(Episode newEpisode) {
    final newEntry = _entries.seekToEpisode(newEpisode);
    if (newEntry != null) {
      _setEntry(newEntry);
    }
  }

  late EpisodeEntries _entries;
  void _setEntries(EpisodeEntries newEntries) {
    _entries = newEntries;
    final firstEntry = _entries.firstEntry();
    if (firstEntry != null) {
      _setEntry(firstEntry);
    }
  }

  late EpisodeEntry _entry;
  void _setEntry(EpisodeEntry newEntry) {
    _entry = newEntry;
    notifyListeners();
  }

  void switchToNextEpisode() {
    final nextEntry = _entry.nextEntry();
    if (nextEntry == null) return;
    _setEntry(nextEntry);
  }

  void switchToPreviousEpisode() {
    final previousEntry = _entry.previousEntry();
    if (previousEntry == null) return;
    _setEntry(previousEntry);
  }
}

final seriesControllerProvider =
    ChangeNotifierProvider<SeriesController?>((ref) {
  final seasonsValue = ref.watch(allSeasonsProvider);

  final seasons = seasonsValue.valueOrNull;
  if (seasons == null) return null;

  return SeriesController(seasons: seasons);
});
