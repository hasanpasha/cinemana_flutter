import '../../domain/entities/media.dart';
import 'media_kind_model.dart';

class MediaModel extends Media {
  MediaModel({
    required super.id,
    required super.title,
    required this.kindModel,
    required super.year,
    super.rate,
    super.description,
    super.poster,
    super.thumbnail,
  }) : super(kind: kindModel.mapToEntity());

  final MediaKindModel kindModel;

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
      description: map['en_content'],
      rate: num.tryParse(map['stars']),
      poster: validateImageUrl(map['imgObjUrl']),
      thumbnail: validateImageUrl(map['imgMediumThumbObjUrl']),
    );
  }

  Map<String, dynamic> toJson() => {
        "nb": id,
        "en_title": title,
        "kind": kindModel.number.toString(),
        "year": year.toString(),
        "en_content": description ?? "",
        "stars": rate.toString(),
        "imgObjUrl": poster,
        "imgMediumThumbObjUrl": thumbnail,
      };
}
