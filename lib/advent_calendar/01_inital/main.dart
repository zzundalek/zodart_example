import 'package:flutter/material.dart';
import 'package:zodart/zodart.dart';

import 'my_form.dart';

void main() {
  // ZodArtの言語を日本語に設定
  ZLocalizationContext.current = ZIssueLocalizationService(Language.ja);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZodArt Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('ZodArt Demo'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: MyForm(),
            ),
          ),
        ),
      ),
    );
  }
}
