import 'package:flutter/material.dart';

import '../z_form/z_form_controller.dart';

class ZFormField extends StatefulWidget {
  ZFormField({
    required this.labelText,
    required this.zFormController,
    required Enum field,
    super.key,
  }) : fieldPath = field.name;

  const ZFormField.nested({
    required this.labelText,
    required this.zFormController,
    required this.fieldPath,
    super.key,
  });

  final String labelText;
  final String fieldPath;
  final ZFormController zFormController;

  @override
  State<ZFormField> createState() => _ZFormFieldState();
}

class _ZFormFieldState extends State<ZFormField> {
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    /// エラーメッセージが変更された場合rebuildする。
    return ValueListenableBuilder(
      valueListenable: widget.zFormController.watchIssueMessageFor(
        widget.fieldPath,
      ),
      builder: (context, issueMessage, _) {
        print('${widget.fieldPath}がbuildされました。');
        return TextFormField(
          controller: _textEditingController,
          focusNode: _focusNode,
          onChanged: (val) =>
              widget.zFormController.updateRawValue(widget.fieldPath, val),
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: issueMessage,
          ),
        );
      },
    );
  }

  void onFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.zFormController.setTouched(widget.fieldPath);
    }
  }

  @override
  void initState() {
    final fieldValue = widget.zFormController.getRawValue(widget.fieldPath);

    _focusNode = FocusNode();
    _textEditingController = TextEditingController(text: fieldValue);

    _focusNode.addListener(onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
