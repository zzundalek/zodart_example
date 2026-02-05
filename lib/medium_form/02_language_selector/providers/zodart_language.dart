import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodart/zodart.dart';

final zodArtLanguageProvider =
    NotifierProvider<ZodArtLanguageNotifier, Language>(
      ZodArtLanguageNotifier.new,
    );

class ZodArtLanguageNotifier extends Notifier<Language> {
  @override
  Language build() {
    const defaultLanguage = Language.en;
    ZLocalizationContext.current = ZIssueLocalizationService(defaultLanguage);
    return defaultLanguage;
  }

  void setLanguage(Language language) {
    ZLocalizationContext.current = ZIssueLocalizationService(language);
    state = language;
  }
}
