import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/medias/domain/entities/media.dart';
import '../extensions.dart';
import 'media_provider.dart';
import 'usecases_providers.dart';

final mediaDetailProvider = FutureProvider<Media?>((ref) async {
  final getInfo = ref.watch(getInfoUsecaseProvider);

  final media = ref.watch(mediaProvider);
  if (media == null) return null;

  final result = await getInfo(media);
  return result.unwrapRight();
});
