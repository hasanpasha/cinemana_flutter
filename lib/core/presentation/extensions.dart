import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../features/medias/domain/entities/entities.dart';
import 'providers/providers.dart';

double width(BuildContext context) => MediaQuery.of(context).size.width;

extension ContextExtension on BuildContext {
  bool get isPhone => width(this) < 600;
  bool get isTablet => width(this) > 600 && width(this) < 1200;
  bool get isDesktop => width(this) > 1200;
}

extension EitherHelpers<L, R> on Either<L, R> {
  R? unwrapRight() {
    return toOption().toNullable();
  }
}

extension EpisodeEntriesOperations on EpisodeEntries {
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

extension SeasonsListTransformations on List<Season> {
  EpisodeEntries toEpisodeEntries() {
    List<SeasonEpisodePair> pairs = [];
    for (var season in this) {
      pairs.addAll((season.episodes.map((e) => (season, e))));
    }
    return EpisodeEntries.from(pairs);
  }
}
