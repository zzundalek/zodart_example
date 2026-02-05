import 'package:flutter/material.dart';
import 'package:zodart/zodart.dart';

import 'models/user_schema.dart';
import 'zodart_form_state.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>
    with ZodArtFormState<User, SignUpForm> {
  // Returns a SnackBar based on the validation result
  SnackBar _getResultSnackBar<T>(ZRes<T> userParseRes, BuildContext context) =>
      userParseRes.match(
        // error on validation failure
        (_) => SnackBar(
          content: const Text('Validation failure'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),

        /// user is an instance of [User], no unsafe map anymore!
        (user) => SnackBar(
          content: Text('Validation success: $user'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'First name',
              errorText: getErrorText(UserSchemaProps.firstName.name),
            ),
            onSaved: rawValueSaver(UserSchemaProps.firstName.name),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Last name',
              errorText: getErrorText(UserSchemaProps.lastName.name),
            ),
            onSaved: rawValueSaver(UserSchemaProps.lastName.name),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Birthdate',
              errorText: getErrorText(UserSchemaProps.birthDate.name),
            ),
            onSaved: rawValueSaver(UserSchemaProps.birthDate.name),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              final parsedValue = submitForm();

              // Display the snack bar based on the validation result
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(_getResultSnackBar(parsedValue, context));
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  final formKey = GlobalKey<FormState>();

  @override
  ZRes<User> parseFunction(dynamic val) => UserSchema.zObject.parse(val);
}
