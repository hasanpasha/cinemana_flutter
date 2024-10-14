import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../../../injection_container.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/get_seasons.dart';

typedef SeasonEpisodePair = (Season, Episode);
typedef EpisodeEntries = DoubleLinkedQueue<SeasonEpisodePair>;
typedef EpisodeEntry = DoubleLinkedQueueEntry<SeasonEpisodePair>;

class MediaController extends ChangeNotifier {
  MediaController();

  final GetSeasons getSeasons = sl();

  Media? media;
  List<Season>? seasons;
  Episode? get episode => currentEpisode;

  EpisodeEntries? _entries;
  EpisodeEntry? _entry;

  void _setEpisodeEntry(EpisodeEntry newEntry) {
    _entry = newEntry;
    final newEpisode = currentEpisode;
    if (newEpisode != null) {
      _setNewMedia(newEpisode);
    }
  }

  Season? get currentSeason => _entry?.element.$1;
  Episode? get currentEpisode => _entry?.element.$2;

  bool get hasNext => _entry?.nextEntry() != null;
  bool get hasPrevious => _entry?.previousEntry() != null;

  String? error;

  void _notifyAnError(String message) {
    error = message;
    notifyListeners();
  }

  bool switchToNextEpisode() {
    if (_entry == null) return false;
    final nextEntry = _entry?.nextEntry();
    if (nextEntry == null) return false;
    _setEpisodeEntry(nextEntry);
    return true;
  }

  bool switchToPreviousEpisode() {
    if (_entry == null) return false;
    final previousEntry = _entry?.previousEntry();
    if (previousEntry == null) return false;
    _setEpisodeEntry(previousEntry);
    return true;
  }

  Future<void> _setNewSeasons(Media media) async {
    final result = await getSeasons(media);
    result.fold(
      (failure) {
        _notifyAnError(failure.toString());
      },
      (newSeasons) {
        seasons = newSeasons;
        notifyListeners();

        _entries = EpisodeEntries.from(newSeasons.mapToSeasonEpisodePairList());
        _selectNewEpisode(entries: _entries!);
      },
    );
  }

  void _setNewMedia(Media newMedia) {
    media = newMedia;
    notifyListeners();
  }

  void changeEpisode(Episode episode) {
    if (media != episode) {
      _setNewMedia(episode);
    }
  }

  Future<void> openMedia(Media newMedia) async {
    if (media == newMedia) return;

    if (newMedia.kind == MediaKind.series) {
      await _setNewSeasons(newMedia);
    } else {
      _setNewMedia(newMedia);
    }
  }

  void _selectNewEpisode({
    required EpisodeEntries entries,
    Episode? targetEpisode,
  }) {
    EpisodeEntry? entry;
    if (targetEpisode != null) {
      entries.seekToEpisode(targetEpisode);
    }
    entry ??= entries.firstEntry();

    if (entry != null) {
      _setEpisodeEntry(entry);
    }
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
