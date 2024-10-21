import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'media_detail_provider.dart';
export 'media_provider.dart';
export 'series_provider.dart';
export 'subtitle_provider.dart';
export 'video_player_controller_provider.dart';
export 'video_provider.dart';

final videoBoxFitStateProvider = StateProvider<BoxFit>(
  (ref) => BoxFit.contain,
);
