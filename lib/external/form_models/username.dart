import 'package:formz/formz.dart';

enum UsernameValidationError {
  required('Username can\'t be empty'),
  invalid('Username must be 3-20 characters and contain only letters, numbers, and underscores.');

  final String message;
  const UsernameValidationError(this.message);
}

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  // Valid usernames: 3–20 characters, letters, numbers, underscores
  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.required;
    return _usernameRegex.hasMatch(value)
        ? null
        : UsernameValidationError.invalid;
  }
}
