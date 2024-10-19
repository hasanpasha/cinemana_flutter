import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/medias/domain/entities/media.dart';
import '../../../features/medias/domain/usecases/get_info.dart';
import '../../../injection_container.dart';
import '../extensions.dart';
import 'media_provider.dart';

final mediaDetailProvider = FutureProvider<Media?>((ref) async {
  final GetInfo getInfo = sl();

  final media = ref.watch(mediaProvider);
  if (media == null) return null;

  final result = await getInfo(media);
  return result.unwrapRight();
});
