import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_form.dart';
import 'zodart/providers/zodart_language.dart';
import 'zodart/widgets/language_selector.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(zodArtLanguageProvider);

    return MaterialApp(
      title: 'ZodArt Demo',
      locale: Locale(language.name),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('ZodArt Demo'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: LanguageSelector(),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: const MyForm(),
            ),
          ),
        ),
      ),
    );
  }
}
