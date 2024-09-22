import 'package:equatable/equatable.dart';

import 'media_kind.dart';

class Media extends Equatable {
  final String id;
  final String title;
  final int year;
  final MediaKind kind;
  final String? thumbnail;
  final String? poster;

  const Media({
    required this.id,
    required this.title,
    required this.kind,
    required this.year,
    this.thumbnail,
    this.poster,
  });

  @override
  List<Object?> get props => [id, title, year, kind];

  bool get isMovie => kind == MediaKind.movies;
}
