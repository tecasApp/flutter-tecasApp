import 'package:formz/formz.dart';

enum SexualOrientationValidationError {
  required('Sexual orientation can\'t be empty'),
  invalid('Selected sexual orientation is not valid.');

  final String message;
  const SexualOrientationValidationError(this.message);
}

class SexualOrientation
    extends FormzInput<String, SexualOrientationValidationError> {
  final Set<String> validKeys;

  const SexualOrientation.pure({this.validKeys = const {}}) : super.pure('');
  const SexualOrientation.dirty(String value, {this.validKeys = const {}})
      : super.dirty(value);

  @override
  SexualOrientationValidationError? validator(String value) {
    if (value.isEmpty) return SexualOrientationValidationError.required;
    return validKeys.contains(value)
        ? null
        : SexualOrientationValidationError.invalid;
  }
}
