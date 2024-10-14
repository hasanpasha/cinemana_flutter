import 'package:file_picker/file_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:sealed_languages/sealed_languages.dart';

import '../../../domain/entities/subtitle.dart';

class PlayerSubtitle extends SubtitleTrack {
  PlayerSubtitle({
    required this.url,
    required this.name,
    required this.nLanguage,
    this.extension,
    this.isLocalFile = false,
  }) : super(url, name, nLanguage.codeShort, uri: true);

  final String url;
  final String name;
  final NaturalLanguage nLanguage;
  final String? extension;
  final bool isLocalFile;

  factory PlayerSubtitle.fromSubtitleEntity(Subtitle subtitle) =>
      PlayerSubtitle(
        url: subtitle.url,
        name: subtitle.name,
        nLanguage: subtitle.language,
        extension: subtitle.subtitleKind,
      );

  factory PlayerSubtitle.fromLocalFile(
    PlatformFile file, {
    NaturalLanguage language = const LangEng(),
  }) =>
      PlayerSubtitle(
        url: file.path!,
        name: file.name,
        extension: file.name.split('.').lastOrNull,
        nLanguage: language,
        isLocalFile: true,
      );

  factory PlayerSubtitle.none() =>
      PlayerSubtitle(url: "none", name: "none", nLanguage: const LangEng());

  @override
  String toString() {
    String str = isLocalFile || name == "none" ? name : nLanguage.name;
    if (extension != null) {
      str += " ($extension)";
    }
    return str;
  }
}
