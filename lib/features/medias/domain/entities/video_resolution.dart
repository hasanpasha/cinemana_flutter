enum VideoResolution {
  p144("144p", 144),
  p240("240p", 240),
  p360("360p", 360),
  p480("SD", 480),
  p720("HD", 720),
  p1080("FHD", 1080),
  p1440("2K", 1440),
  p2160("4K", 2160),
  p4320("8K", 4320),
  unknown("unknown", 720);

  const VideoResolution(this.name, this.height);

  final String name;
  final int height;
}
