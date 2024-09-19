enum MediaKind {
  movies("movies"),
  series("series");

  final String name;

  const MediaKind(this.name);

  static List<MediaKind> get all => [movies, series];
}
