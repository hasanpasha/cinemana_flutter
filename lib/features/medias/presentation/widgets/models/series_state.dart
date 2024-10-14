import 'dart:collection';

import '../../../domain/entities/entities.dart';

typedef MediaChanged = Function(Media);
typedef SeasonEpisodePair = (Season, Episode);
typedef EpisodeEntries = DoubleLinkedQueue<SeasonEpisodePair>;
typedef EpisodeEntry = DoubleLinkedQueueEntry<SeasonEpisodePair>;

class SeriesState {
  SeriesState({
    required this.entries,
    required this.entry,
    required this.onMediaChanged,
  }) {
    currentMedia = entry.element.$2;
  }

  late Media media;
  EpisodeEntries entries;
  EpisodeEntry entry;
  final MediaChanged onMediaChanged;

  Media get currentMedia => media;
  set currentMedia(Media newMedia) {
    media = newMedia;
    onMediaChanged.call(currentMedia);
  }

  EpisodeEntry get currentEntry => entry;
  set currentEntry(EpisodeEntry newEntry) {
    entry = newEntry;
    currentMedia = currentEpisode;
  }

  Season get currentSeason => entry.element.$1;

  Episode get currentEpisode => entry.element.$2;
  bool setCurrentEpisode(Episode newEpisode) {
    final episodeEntry = entries.seekToEpisode(newEpisode);
    if (episodeEntry == null) return false;
    currentEntry = episodeEntry;
    return true;
  }

  bool get hasNext => currentEntry.nextEntry() != null;
  bool get hasPrevious => currentEntry.previousEntry() != null;

  bool switchToNextEpisode() {
    final nextEntry = currentEntry.nextEntry();
    if (nextEntry != null) {
      currentEntry = nextEntry;
      return true;
    } else {
      return false;
    }
  }

  bool switchToPreviousEpisode() {
    final previousEntry = currentEntry.previousEntry();
    if (previousEntry != null) {
      currentEntry = previousEntry;
      return true;
    } else {
      return false;
    }
  }

  factory SeriesState.fromSeriesSeasons({
    required List<Season> seasons,
    required MediaChanged onMediaChanged,
    Episode? currentEpisode,
  }) {
    final episodes = seasons.mapToSeasonEpisodePairList();
    final entries = EpisodeEntries.from(episodes);
    EpisodeEntry? entry;
    if (currentEpisode != null) {
      entries.seekToEpisode(currentEpisode);
    }
    entry ??= entries.firstEntry();

    return SeriesState(
      entries: entries,
      entry: entry!,
      onMediaChanged: onMediaChanged,
    );
  }
}

extension on EpisodeEntries {
  EpisodeEntry? seekToEpisode(Episode episode) {
    EpisodeEntry? newEntry;
    forEachEntry((entry) {
      if (entry.element.$2 == episode) {
        newEntry = entry;
      }
    });
    return newEntry;
  }
}

extension SeasonListUtils on List<Season> {
  List<SeasonEpisodePair> mapToSeasonEpisodePairList() {
    List<SeasonEpisodePair> episodes = [];
    for (var season in this) {
      episodes.addAll((season.episodes.map((e) => (season, e))));
    }
    return episodes;
  }
}
