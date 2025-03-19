import 'package:formz/formz.dart';

enum NameValidationError {
  required('Name can\'t be empty'),
  invalid('Name you have entered is not valid.');

  final String message;
  const NameValidationError(this.message);
}

class FullName extends FormzInput<String, NameValidationError> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([String value = '']) : super.dirty(value);

  static final _fullNameRegex =
      RegExp(r"[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");

  @override
  NameValidationError? validator(String value) {
    return value.isEmpty
        ? NameValidationError.required
        : _fullNameRegex.hasMatch(value)
            ? null
            : NameValidationError.invalid;
  }
}