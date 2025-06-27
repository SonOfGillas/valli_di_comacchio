import 'package:formz/formz.dart';

enum UsernameError { empty, invalid }

class UsernameField extends FormzInput<String, UsernameError> {
  const UsernameField.pure() : super.pure('');

  const UsernameField.dirty({String value = ''}) : super.dirty(value);

  @override
  UsernameError? validator(String value) {
    return value.isEmpty ? UsernameError.empty : null;
  }
}
