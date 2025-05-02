import 'package:formz/formz.dart';

enum PasswordError { empty, invalid }

class PasswordField extends FormzInput<String, PasswordError> {
  const PasswordField.pure() : super.pure('');

  const PasswordField.dirty({String value = ''}) : super.dirty(value);

  @override
  PasswordError? validator(String value) {
    return value.isEmpty ? PasswordError.empty : null;
  }
}
