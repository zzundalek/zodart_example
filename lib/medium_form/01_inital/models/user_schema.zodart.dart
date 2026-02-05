// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'user_schema.dart';

// **************************************************************************
// ZodArtGenerator
// **************************************************************************

/// Inferred Dart type returned from the schema defined in [UserSchema].
///
/// This corresponds to the structure described by [UserSchema.schema].
typedef _UserSchemaDef = ({
  ZDateTime birthDate,
  ZString firstName,
  ZString lastName,
});

/// Enum for fields declared in [UserSchema].
///
/// Values mirror the keys of [UserSchema.schema].
enum UserSchemaProps { birthDate, firstName, lastName }

/// Helper class for [UserSchema].
///
/// Wrapper used to access [UserSchemaProps] values as getters.
final class _UserSchemaPropsWrapper {
  const _UserSchemaPropsWrapper();

  UserSchemaProps get birthDate => UserSchemaProps.birthDate;

  UserSchemaProps get firstName => UserSchemaProps.firstName;

  UserSchemaProps get lastName => UserSchemaProps.lastName;
}

/// Mixin used as interface for [User].
///
/// Providing getters and overriding methods.
mixin _UserSchema {
  DateTime get birthDate;
  String get firstName;
  String get lastName;
  @override
  int get hashCode => Object.hash(runtimeType, birthDate, firstName, lastName);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is User &&
            (identical(birthDate, other.birthDate) ||
                birthDate == other.birthDate) &&
            (identical(firstName, other.firstName) ||
                firstName == other.firstName) &&
            (identical(lastName, other.lastName) ||
                lastName == other.lastName));
  }

  @override
  String toString() {
    return 'User(birthDate: $birthDate, firstName: $firstName, lastName: $lastName)';
  }
}

/// Class used as implementation for [User] and [_UserSchema].
///
/// Providing fields and a default constructor.
final class _UserSchemaImpl with _UserSchema implements User {
  const _UserSchemaImpl({
    required this.birthDate,
    required this.firstName,
    required this.lastName,
  });

  @override
  final DateTime birthDate;

  @override
  final String firstName;

  @override
  final String lastName;
}

/// Instantiates the output class [User] using [_UserSchemaImpl].
User _instantiateUserSchema({
  required DateTime birthDate,
  required String firstName,
  required String lastName,
}) => _UserSchemaImpl(
  birthDate: birthDate,
  firstName: firstName,
  lastName: lastName,
);

/// Generated utility class for working with the schema defined in [UserSchema].
///
/// Provides:
/// - The `ZObject` instance for parsing/validating the schema.
/// - Enum-style access to the schema properties.
/// - Strongly-typed field access
/// - Runtime `Type` of the schema record
final class _UserSchemaUtils
    implements ZGenSchemaUtils<_UserSchemaPropsWrapper, User> {
  const _UserSchemaUtils();

  static const _props = _UserSchemaPropsWrapper();

  static const _keys = ['birthDate', 'firstName', 'lastName'];

  static final Map<String, ZBase<dynamic>> _schemaMap = {
    'birthDate': UserSchema.schema.birthDate,
    'firstName': UserSchema.schema.firstName,
    'lastName': UserSchema.schema.lastName,
  };

  @override
  _UserSchemaPropsWrapper get props => _props;

  @override
  List<String> get keys => _keys;

  @override
  ZObject<User> get zObject {
    return ZObject.withMapper(_schemaMap, fromJson: _toResult);
  }

  @override
  Type get schema => _UserSchemaDef;

  User _toResult(Map<String, dynamic> val) => _instantiateUserSchema(
    birthDate: val['birthDate'] as DateTime,
    firstName: val['firstName'] as String,
    lastName: val['lastName'] as String,
  );
}
