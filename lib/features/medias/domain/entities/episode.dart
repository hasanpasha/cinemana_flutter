import 'entities.dart';

class Episode extends Media {
  const Episode({
    required this.number,
    this.isSpecial = false,
    required super.id,
    required super.title,
    required super.year,
    super.thumbnail,
    super.poster,
  }) : super(kind: MediaKind.series);

  final int number;
  final bool isSpecial;

  @override
  List<Object?> get props => [number, isSpecial, ...super.props];
}
