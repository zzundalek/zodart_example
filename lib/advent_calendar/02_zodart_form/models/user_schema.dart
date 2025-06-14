import 'package:zodart/zodart.dart';

part 'user_schema.zodart.dart';
part 'user_schema.zodart.type.dart';

const usageAgeLimit = 13;

/// 指定した年齢以上かどうかを判定する関数を返します。
///
/// [years] 歳以上なら `true`、それ未満なら `false` を返します。
bool Function(DateTime) isNYearsOld(int years) => (DateTime birthDate) {
  final now = DateTime.now();
  final minimumBirthday = now.copyWith(year: now.year - years);
  return !birthDate.isAfter(minimumBirthday);
};

@ZodArt.generateNewClass(outputClassName: 'User')
abstract class UserSchema {
  static final schema = (
    firstName: ZString().trim().min(1).max(5),
    lastName: ZString().trim().min(1).max(5),
    email: ZString().trim().regex(
      r'^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$',
    ),
    birthDate: ZString().toDateTime().refine(
      isNYearsOld(usageAgeLimit),
      message: '$usageAgeLimit歳未満の方はご利用いただけません。',
    ),
  );

  static const z = _UserSchemaUtils();
  static final ZObject<User> zObject = z.zObject;
}
