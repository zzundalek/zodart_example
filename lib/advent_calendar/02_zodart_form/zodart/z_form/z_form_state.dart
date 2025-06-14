/// Map に対する拡張：
///
/// 指定した key の値を返す。
/// 指定した key が存在しない場合に例外を投げる。
extension _FieldMapExt<K, V> on Map<K, V> {
  V getOrThrow(K key) {
    if (!containsKey(key)) {
      throw Exception(
        'Field $key is missing! Start by setting a default value!',
      );
    }

    return this[key]!;
  }
}

/// フィールドの状態（初期値・dirty・touched）を保持するクラス。
class ZFormFieldMetadata<T> {
  const ZFormFieldMetadata._({
    required this.initialValue,
    required this.dirty,
    required this.touched,
  });

  /// 初期状態を生成するためのコンストラクタ。
  const ZFormFieldMetadata.init({
    required this.initialValue,
  }) : dirty = false,
       touched = false;

  /// フィールドの初期値（ZFormFields.init で設定された値）
  final T initialValue;

  /// 値が初期値と異なるかどうか
  final bool dirty;

  /// ユーザーがこのフィールドを一度でも編集したかどうか (実際にonBlurの利用が適切)
  final bool touched;

  /// 新しい入力値 `val` を反映したメタデータを返す。
  ZFormFieldMetadata<T> updateValue({
    required T val,
  }) {
    return ZFormFieldMetadata._(
      initialValue: initialValue,
      dirty: val != initialValue,
      touched: touched,
    );
  }

  /// このフィールドを touched = true にしてメタデータを返す。
  ZFormFieldMetadata<T> setTouched() {
    return ZFormFieldMetadata._(
      initialValue: initialValue,
      dirty: dirty,
      touched: true,
    );
  }
}

/// フォームの全フィールドの値・metadataをまとめて管理するクラス。
class ZFormFields {
  /// フィールド定義をもとに初期状態を生成するファクトリーコンストラクタ。
  factory ZFormFields.init({
    Map<Enum, String?> defaultValues = const {},
  }) {
    final rawValues = <String, String?>{};
    final formFieldsMetadata = <String, ZFormFieldMetadata<String?>>{};

    for (final MapEntry(key: field, :value) in defaultValues.entries) {
      rawValues[field.name] = value;
      formFieldsMetadata[field.name] = ZFormFieldMetadata.init(
        initialValue: value,
      );
    }

    return ZFormFields._(
      formFieldsMetadata: formFieldsMetadata,
      rawValues: rawValues,
    );
  }

  const ZFormFields._({
    required Map<String, String?> rawValues,
    required Map<String, ZFormFieldMetadata<String?>> formFieldsMetadata,
  }) : _rawValues = rawValues,
       _formFieldsMetadata = formFieldsMetadata;

  /// 各フィールドの現在の入力値
  final Map<String, String?> _rawValues;

  /// 各フィールドの dirty/touched などの状態を持つ metadata
  final Map<String, ZFormFieldMetadata<String?>> _formFieldsMetadata;

  /// 不変の raw values を返す
  Map<String, String?> get rawValues => Map.unmodifiable(_rawValues);

  /// 指定したフィールドの値を更新し、新しい ZFormFields を返す。
  ZFormFields setRawValue(String fieldPath, String? val) {
    final currentFieldMetadata = _getFieldMetadata(fieldPath);

    return ZFormFields._(
      rawValues: {
        ..._rawValues,
        fieldPath: val,
      },
      formFieldsMetadata: {
        ..._formFieldsMetadata,
        fieldPath: currentFieldMetadata.updateValue(val: val),
      },
    );
  }

  /// 指定したフィールドを touched = true にし、新しい ZFormFields を返す。
  ZFormFields setTouched(String fieldPath) {
    final currentFieldMetadata = _getFieldMetadata(fieldPath);

    return ZFormFields._(
      rawValues: _rawValues,
      formFieldsMetadata: {
        ..._formFieldsMetadata,
        fieldPath: currentFieldMetadata.setTouched(),
      },
    );
  }

  /// 指定したフィールドの現在の raw 値を返す。
  String? getRawValue(String fieldPath) => _rawValues.getOrThrow(fieldPath);

  ZFormFieldMetadata<String?> _getFieldMetadata(String fieldPath) =>
      _formFieldsMetadata.getOrThrow(fieldPath);

  /// 指定したフィールドが touched かどうかを返す。
  bool isTouched(String fieldPath) => _getFieldMetadata(fieldPath).touched;

  /// 指定したフィールドが dirty かどうかを返す。
  bool isDirty(String fieldPath) => _getFieldMetadata(fieldPath).dirty;

  /// 初期値を取得する
  String? getInitialValue(String fieldPath) =>
      _getFieldMetadata(fieldPath).initialValue;
}
