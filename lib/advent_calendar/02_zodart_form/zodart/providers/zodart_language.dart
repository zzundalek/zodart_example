import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zodart/zodart.dart';

part 'zodart_language.g.dart';

@riverpod
class ZodArtLanguage extends _$ZodArtLanguage {
  @override
  Language build() {
    // ZodArtの言語を日本語に設定
    const defaultLanguage = Language.ja;
    ZLocalizationContext.current = ZIssueLocalizationService(defaultLanguage);
    return defaultLanguage;
  }

  void setLanguage(Language language) {
    ZLocalizationContext.current = ZIssueLocalizationService(language);
    state = language;
  }
}
