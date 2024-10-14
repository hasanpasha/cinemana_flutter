import 'package:sealed_languages/sealed_languages.dart';

import '../../domain/entities/subtitle.dart';

class SubtitleModel extends Subtitle {
  const SubtitleModel({
    required super.url,
    required super.name,
    required super.language,
    super.subtitleKind,
  });

  factory SubtitleModel.fromJson(Map<String, dynamic> map) {
    String langCode = map['type'];
    NaturalLanguage? naturalLanguage;
    naturalLanguage ??= NaturalLanguage.maybeFromCodeShort(langCode);
    naturalLanguage ??= NaturalLanguage.maybeFromCode(langCode);
    naturalLanguage ??= NaturalLanguage.maybeFromAnyCode(langCode);
    naturalLanguage ??= NaturalLanguage.maybeFromValue(langCode.toLowerCase(),
        where: (l) => l.name.toLowerCase());

    return SubtitleModel(
      url: map['file'],
      name: map['name'],
      language: naturalLanguage!,
      subtitleKind: map['extention'],
    );
  }
}
