import 'package:equatable/equatable.dart';

import 'episode.dart';

class Season extends Equatable {
  const Season({required this.number, required this.episodes});

  final int number;
  final List<Episode> episodes;

  @override
  List<Object?> get props => [number, episodes];
}
