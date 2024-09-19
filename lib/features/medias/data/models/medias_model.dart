import '../../domain/entities/medias.dart';
import 'media_model.dart';

class MediasModel extends Medias {
  const MediasModel({required super.hasNext, required super.medias});

  factory MediasModel.fromJson(List<dynamic> list) {
    final medias = list
        .map((element) => MediaModel.fromJson(element as Map<String, dynamic>))
        .toList();
    return MediasModel(
      hasNext: medias.isNotEmpty,
      medias: medias,
    );
  }
}
