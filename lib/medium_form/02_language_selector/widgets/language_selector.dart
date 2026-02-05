import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodart/zodart.dart';

import '../providers/zodart_language.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(zodArtLanguageProvider);

    return DropdownMenu(
      leadingIcon: const Icon(Icons.language),
      initialSelection: language,
      dropdownMenuEntries: Language.values
          .map((lang) => DropdownMenuEntry(value: lang, label: lang.name))
          .toList(),
      onSelected: (val) =>
          ref.read(zodArtLanguageProvider.notifier).setLanguage(val!),
    );
  }
}
