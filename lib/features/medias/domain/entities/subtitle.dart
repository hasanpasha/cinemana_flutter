import 'package:equatable/equatable.dart';
import 'package:sealed_languages/sealed_languages.dart';

class Subtitle extends Equatable {
  const Subtitle({
    required this.url,
    required this.name,
    required this.language,
    this.subtitleKind,
  });

  final String url;
  final String name;
  final NaturalLanguage language;
  final String? subtitleKind;

  @override
  List<Object?> get props => [url, name, language, subtitleKind];
}
