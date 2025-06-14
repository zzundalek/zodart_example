import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:zodart/zodart.dart';

import 'models/user_schema.dart';

class MyForm extends HookWidget {
  MyForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('フォームがbuildされました。');

    // 保存用マップ: 入力値を一時的に保持。useRefを使ってフォーム全体のリビルドを避ける
    final rawValue = useRef<Map<String, String?>>({});

    // バリデーション結果: ZodArtで解析された結果を保持
    final parsedValue = useState<ZRes<User>?>(null);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: '名前',
              errorText: parsedValue.value?.getSummaryFor(
                UserSchemaProps.firstName.name,
              ),
            ),
            onSaved: (val) {
              rawValue.value[UserSchemaProps.firstName.name] = val;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: '名字',
              errorText: parsedValue.value?.getSummaryFor(
                UserSchemaProps.lastName.name,
              ),
            ),
            onSaved: (val) {
              rawValue.value[UserSchemaProps.lastName.name] = val;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'メール',
              errorText: parsedValue.value?.getSummaryFor(
                UserSchemaProps.email.name,
              ),
            ),
            onSaved: (val) {
              rawValue.value[UserSchemaProps.email.name] = val;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              // フィールドの値を[rawValue]に保存
              _formKey.currentState!.save();

              // ユーザをバリデーションして[parsedValue]に保存
              final user = UserSchema.zObject.parse(rawValue.value);
              parsedValue.value = user;

              // 結果によってのSnackBar
              final snackBar = user.match(
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
      ),
    );
  }
}
