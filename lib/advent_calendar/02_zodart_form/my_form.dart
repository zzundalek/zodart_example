import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/user_schema.dart';
import 'zodart/providers/zodart_language.dart';
import 'zodart/widgets/z_text_field.dart';
import 'zodart/z_form/z_form_controller.dart';

class MyForm extends ConsumerStatefulWidget {
  const MyForm({super.key});

  @override
  ConsumerState<MyForm> createState() => _MyFormState();
}

class _MyFormState extends ConsumerState<MyForm> {
  final formKey = GlobalKey<FormState>();
  final _zFormController = ZFormController(
    zObject: UserSchema.zObject,
    defaultValues: {
      UserSchema.z.props.firstName: 'Zod',
      UserSchema.z.props.lastName: 'Art',
      UserSchema.z.props.birthDate: '2025-06-10',
      UserSchema.z.props.email: '',
    },
  );

  @override
  Widget build(BuildContext context) {
    print('フォームがbuildされました。');

    ref.listen(
      zodArtLanguageProvider,
      (_, _) => _zFormController.validateForm(),
    );

    return Column(
      children: [
        ZFormField(
          labelText: '名前',
          zFormController: _zFormController,
          field: UserSchemaProps.firstName,
        ),
        ZFormField(
          labelText: '名字',
          zFormController: _zFormController,
          field: UserSchemaProps.lastName,
        ),
        ZFormField(
          labelText: '誕生日',
          zFormController: _zFormController,
          field: UserSchemaProps.birthDate,
        ),
        ZFormField(
          labelText: 'メール',
          zFormController: _zFormController,
          field: UserSchemaProps.email,
        ),
        ElevatedButton(
          onPressed: () {
            _zFormController.submitForm();
            // 結果によってのSnackBar
            final snackBar = _zFormController.parsedValue.match(
              (_) => SnackBar(
                content: const Text('バリデーション失敗！'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              (user) => SnackBar(
                content: Text('バリデーション成功： $user'), // [User]オブジェクト
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );

            // 結果をスナックバーで表示
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(snackBar);
          },
          child: const Text('登録'),
        ),
      ],
    );
  }
}
