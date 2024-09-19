import '../../domain/entities/media.dart';
import 'media_kind_model.dart';

class MediaModel extends Media {
  final MediaKindModel kindModel;

  MediaModel({
    required super.id,
    required super.title,
    required this.kindModel,
    required super.year,
    super.poster,
    super.thumbnail,
  }) : super(kind: kindModel.mapToEntity());

  factory MediaModel.fromJson(Map<String, dynamic> map) {
    String? validateImageUrl(String? url) {
      if (url != null) {
        if (url.isEmpty || url.endsWith("loading.gif")) {
          return null;
        }
      }
      return url;
    }

    return MediaModel(
      id: map['nb'],
      title: map['en_title'],
      kindModel: MediaKindModel.fromNumber(map['kind']),
      year: int.parse(map['year']),
      poster: validateImageUrl(map['imgObjUrl']),
      thumbnail: validateImageUrl(map['imgMediumThumbObjUrl']),
    );
  }

  Map<String, dynamic> toJson() => {
        "nb": id,
        "en_title": title,
        "year": year.toString(),
        "kind": kindModel.number,
        "imgObjUrl": poster ?? "",
        "imgMediumThumbObjUrl": thumbnail ?? "",
      };
}
