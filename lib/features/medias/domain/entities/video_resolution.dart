enum VideoResolution {
  p144("144p"),
  p240("240p"),
  p360("360p"),
  p480("SD"),
  p720("HD"),
  p1080("FHD"),
  p1440("2K"),
  p2160("4K"),
  p4320("8K"),
  unknown("unknown");

  const VideoResolution(this.name);

  final String name;
}
