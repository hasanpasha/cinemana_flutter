import '../../domain/entities/media_kind.dart';

enum MediaKindModel {
  movies("movies", "1"),
  series("series", "2");

  const MediaKindModel(this.name, this.number);

  final String name;
  final String number;

  factory MediaKindModel.fromName(String name) =>
      MediaKindModel.all.byName(name);

  factory MediaKindModel.fromNumber(String number) {
    for (var value in all) {
      if (value.number == number) return value;
    }
    throw ArgumentError.value(
        number, "number", "No enum value with that number");
  }

  factory MediaKindModel.fromEntity(MediaKind kind) => switch (kind) {
        MediaKind.movies => MediaKindModel.movies,
        MediaKind.series => MediaKindModel.series,
      };

  MediaKind mapToEntity() => switch (this) {
        MediaKindModel.movies => MediaKind.movies,
        MediaKindModel.series => MediaKind.series,
      };

  static List<MediaKindModel> get all => [movies, series];
}
