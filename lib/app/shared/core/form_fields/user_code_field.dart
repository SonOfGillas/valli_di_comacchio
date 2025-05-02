import 'package:formz/formz.dart';

// Define input validation errors
enum UserCodeError { empty, invalid }

class UserCodeField extends FormzInput<String, UserCodeError> {
  const UserCodeField.pure() : super.pure('');

  const UserCodeField.dirty({String value = ''}) : super.dirty(value);

  @override
  UserCodeError? validator(String value) {
    return value.isEmpty ? UserCodeError.empty : null;
  }
}
