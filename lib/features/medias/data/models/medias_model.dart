import '../../domain/entities/medias.dart';
import 'media_model.dart';

class MediasModel extends Medias {
  const MediasModel({required super.hasNext, required this.mediaModelList})
      : super(medias: mediaModelList);

  final List<MediaModel> mediaModelList;

  factory MediasModel.fromJson(List<dynamic> list) {
    final medias = list
        .map((element) => MediaModel.fromJson(element as Map<String, dynamic>))
        .toList();
    return MediasModel(
      hasNext: medias.isNotEmpty,
      mediaModelList: medias,
    );
  }

  List<Map<String, dynamic>> toJson() {
    return mediaModelList.map((e) => e.toJson()).toList();
  }

  // @override
  // MediasModel copyWith({bool? hasNext, List<MediaModel>? medias}) {
  //   return MediasModel(
  //     hasNext: hasNext ?? this.hasNext,
  //     mediaModelList: medias ?? mediaModelList,
  //   );
  // }
}
