// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zodart_language.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ZodArtLanguage)
const zodArtLanguageProvider = ZodArtLanguageProvider._();

final class ZodArtLanguageProvider
    extends $NotifierProvider<ZodArtLanguage, Language> {
  const ZodArtLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zodArtLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zodArtLanguageHash();

  @$internal
  @override
  ZodArtLanguage create() => ZodArtLanguage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Language value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Language>(value),
    );
  }
}

String _$zodArtLanguageHash() => r'f9a16333c47d1afdff045a285cad06a9ac576f82';

abstract class _$ZodArtLanguage extends $Notifier<Language> {
  Language build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Language, Language>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Language, Language>,
              Language,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
