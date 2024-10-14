import 'package:equatable/equatable.dart';

import 'media.dart';

class Medias extends Equatable {
  final bool hasNext;
  final List<Media> medias;

  const Medias({required this.hasNext, required this.medias});

  Medias copyWith({bool? hasNext, List<Media>? medias}) {
    return Medias(
      hasNext: hasNext ?? this.hasNext,
      medias: medias ?? this.medias,
    );
  }

  @override
  List<Object?> get props => [hasNext, medias];
}
