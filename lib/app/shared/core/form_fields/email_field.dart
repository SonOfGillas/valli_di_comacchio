import 'package:formz/formz.dart';

// Define input validation errors
enum EmailCodeError { empty, invalid }

class EmailField extends FormzInput<String, EmailCodeError> {
  const EmailField.pure() : super.pure('');

  const EmailField.dirty({String value = ''}) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(r'''
(?:[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+))\]
''');

  @override
  EmailCodeError? validator(String value) {
    if (value.isEmpty) return EmailCodeError.empty;
    return _emailRegExp.hasMatch(value) ? null : EmailCodeError.invalid;
  }
}
