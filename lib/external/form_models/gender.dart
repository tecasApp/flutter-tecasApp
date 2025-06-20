import 'package:formz/formz.dart';

enum GenderValidationError {
  required('Gender can\'t be empty'),
  invalid('Selected gender is not valid.');

  final String message;
  const GenderValidationError(this.message);
}

class Gender extends FormzInput<String, GenderValidationError> {
  final Set<String> validKeys;

  const Gender.pure({this.validKeys = const {}}) : super.pure('');
  const Gender.dirty(String value, {this.validKeys = const {}})
      : super.dirty(value);

  @override
  GenderValidationError? validator(String value) {
    if (value.isEmpty) return GenderValidationError.required;
    return validKeys.contains(value)
        ? null
        : GenderValidationError.invalid;
  }
}
