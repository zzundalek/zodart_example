import 'package:zodart/zodart.dart';

part 'user_schema.zodart.dart';
part 'user_schema.zodart.type.dart';

const usageAgeLimit = 13;

/// Returns a function that checks whether a given birthDate
/// is at least [years] years ago.
bool Function(DateTime) isNYearsOld(int years) => (DateTime birthDate) {
  final now = DateTime.now();
  final minimumBirthday = now.copyWith(year: now.year - years);
  return !birthDate.isAfter(minimumBirthday);
};

/// User schema defined using ZodArt
///
/// - trims and validates firstName/lastName length
/// - validates user minimal age
@ZodArt.generateNewClass(outputClassName: 'User')
abstract class UserSchema {
  static final schema = (
    firstName: ZString().trim().min(1).max(5),
    lastName: ZString().trim().min(1).max(5),
    birthDate: ZString().toDateTime().refine(
      isNYearsOld(usageAgeLimit),
      message:
          'You must be at least $usageAgeLimit years old to use this service.',
    ),
  );

  static const z = _UserSchemaUtils();
  static final ZObject<User> zObject = z.zObject;
}
