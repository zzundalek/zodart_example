import 'package:flutter/material.dart';
import 'package:zodart/zodart.dart';

/// Simple reusable ZodArt form state
mixin ZodArtFormState<T, S extends StatefulWidget> on State<S> {
  // Map used to temporary store the raw values.
  final _rawValue = <String, String?>{};

  // Validation result - output from .parse() method.
  ZRes<T>? _parsedValue;

  // Helper method for saving the raw value for a field
  void Function(String?) rawValueSaver(String fieldName) =>
      (String? val) => _rawValue[fieldName] = val;

  // Helper method for obtaining validation error for a field
  String? getErrorText(String fieldName) =>
      _parsedValue?.getSummaryFor(fieldName);

  /// Form key used in the form
  GlobalKey<FormState> get formKey;

  /// ZodArt parse function
  ZRes<T> parseFunction(dynamic val);

  // Validation result
  ZRes<T>? get parsedValue => _parsedValue;

  /// Updates the parsedValue
  ZRes<T> submitForm() {
    // Save all values to [rawValue] map
    formKey.currentState!.save();

    // Validate the values and save the output to [parsedValue]
    final parsedValue = parseFunction(_rawValue);
    setState(() {
      _parsedValue = parsedValue;
    });
    return parsedValue;
  }
}
