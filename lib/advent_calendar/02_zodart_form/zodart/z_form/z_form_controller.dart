import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zodart/zodart.dart';

import 'z_form_state.dart';

/// フォームバリデーションためのでデバウンス。
class _Debouncer {
  _Debouncer({this.debounceDelay = defaultDelay});

  static const defaultDelay = Duration(milliseconds: 300);

  final Duration debounceDelay;
  Timer? _timer;

  void set(VoidCallback callback) {
    cancel();
    _timer = Timer(debounceDelay, callback);
  }

  void cancel() {
    _timer?.cancel();
  }
}

/// バリデーションエラーメッセージを管理するクラス。
///
/// 各 `fieldPath` ごとに `ValueNotifier` を保持し、
/// 外部から提供される `getIssueMessage` に基づいて
/// 最新のエラーメッセージを通知する。
class _IssueMessagesNotifier {
  _IssueMessagesNotifier({required this.getIssueMessage});

  /// 各 `fieldPath` に対応する `ValueNotifier` を保持するマップ。
  final Map<String, ValueNotifier<String?>> _issueMessageNotifiers = {};

  /// 指定した `fieldPath` の現在のエラーメッセージを返す関数。
  final String? Function(String fieldPath) getIssueMessage;

  /// 指定した `fieldPath` に紐づくエラーメッセージ用の `ValueNotifier` を返す。
  ///
  /// まだ存在しない場合は、現在のバリデーション結果を initial value として
  /// 新しく作成し登録する。
  ValueNotifier<String?> watchIssueMessageFor(String fieldPath) =>
      _issueMessageNotifiers.putIfAbsent(
        fieldPath,
        () => ValueNotifier(getIssueMessage(fieldPath)),
      );

  /// 登録されているすべての `ValueNotifier` を最新のエラーメッセージで更新する。
  ///
  /// バリデーション実行後に呼び出すことで、UI のリスナーへ更新を反映させる。
  void updateIssueMessages() {
    for (final MapEntry(key: fieldPath, value: notifier)
        in _issueMessageNotifiers.entries) {
      notifier.value = getIssueMessage(fieldPath);
    }
  }

  /// 登録されているすべての `ValueNotifier` を破棄する。
  void dispose() {
    for (final notifier in _issueMessageNotifiers.values) {
      notifier.dispose();
    }
    _issueMessageNotifiers.clear();
  }
}

/// フォームを管理するためのクラス。
class ZFormController<T extends Object> {
  /// 通常のコンストラクタ。
  ///
  /// `defaultValues` を基にフィールド群を初期化し、
  /// `zObject` に基づく初回バリデーションを実行する。
  factory ZFormController({
    required ZObject<T> zObject,
    required Map<Enum, String?> defaultValues,
    Duration debounceDelay = _Debouncer.defaultDelay,
  }) {
    return ZFormController._(
      zObject: zObject,
      formFields: ZFormFields.init(defaultValues: defaultValues),
      debounceDelay: debounceDelay,
    );
  }

  /// 実際の初期化処理を行うプライベートコンストラクタ。
  ZFormController._({
    required this.zObject,
    required ZFormFields formFields,
    required Duration debounceDelay,
  }) : _submitCount = 0,
       _formFields = formFields,
       _parseRes = zObject.parse(formFields.rawValues),
       _debouncer = _Debouncer(debounceDelay: debounceDelay) {
    _issueMessageNotifier = _IssueMessagesNotifier(
      getIssueMessage: _getIssueMessage,
    );
  }

  /// エラーメッセージのリスナー
  late final _IssueMessagesNotifier _issueMessageNotifier;

  /// `onChange`がフォームバリデーションのトリガーですので、
  /// バリデーション数を減らすために、debounceを利用します。
  final _Debouncer _debouncer;

  /// バリデーション用のZodArtの[ZObject]
  final ZObject<T> zObject;

  /// フィールドの値とメタデータ
  ZFormFields _formFields;

  /// バリデーションの結果
  ZRes<T> _parseRes;

  /// フォームの送信数
  int _submitCount = 0;

  /// 指定した `fieldPath` に紐づくエラーメッセージ用の `ValueNotifier` を返す。
  ///
  /// まだ存在しない場合は、現在のバリデーション結果を initial value として
  /// 新しく作成し登録する。
  ValueNotifier<String?> watchIssueMessageFor(String fieldPath) =>
      _issueMessageNotifier.watchIssueMessageFor(fieldPath);

  /// 指定したフィールドの値を更新する。
  void updateRawValue(String fieldPath, String? val) {
    _formFields = _formFields.setRawValue(
      fieldPath,
      val,
    );
    _debouncer.set(validateForm);
  }

  /// 指定したフィールドのエラーメッセージを返す。
  String? _getIssueMessage(String fieldPath) {
    final shouldDisplayError =
        _submitCount > 0 || _formFields.isTouched(fieldPath);

    return shouldDisplayError ? _parseRes.getSummaryFor(fieldPath) : null;
  }

  /// 指定したフィールドの値を返す。
  String? getRawValue(String fieldPath) => _formFields.getRawValue(fieldPath);

  /// バリデーションの結果
  ZRes<T> get parsedValue => _parseRes;

  /// フォームの値をバリデートする。
  void validateForm() {
    _debouncer.cancel();
    _parseRes = zObject.parse(_formFields.rawValues);
    _issueMessageNotifier.updateIssueMessages();
  }

  /// フォームを送信する。
  void submitForm() {
    _submitCount++;
    validateForm();
  }

  /// 指定した `fieldPath` のフィールドを
  void setTouched(String fieldPath) {
    _formFields = _formFields.setTouched(fieldPath);
    validateForm();
  }

  /// デバウンサーと登録された`ValueNotifier`を破棄する。
  void dispose() {
    _debouncer.cancel();
    _issueMessageNotifier.dispose();
  }
}
