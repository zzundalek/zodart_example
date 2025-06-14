import 'package:zodart/zodart.dart';

part 'user_schema.zodart.dart';
part 'user_schema.zodart.type.dart';

@ZodArt.generateNewClass(outputClassName: 'User')
abstract class UserSchema {
  static final schema = (
    firstName: ZString().trim().min(1).max(5),
    lastName: ZString().trim().min(1).max(5),
    email: ZString().trim().regex(
      r'^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$',
    ),
  );

  static const z = _UserSchemaUtils();
  static final ZObject<User> zObject = z.zObject;
}
