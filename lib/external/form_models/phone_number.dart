import 'package:formz/formz.dart';

enum PhoneNumberValidationError { empty, invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  const PhoneNumber.pure() : super.pure('');
  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneNumberValidationError? validator(String value) {
    if (value.isEmpty) return PhoneNumberValidationError.empty;
    final regex = RegExp(r'^\+\d{7,15}$');
    return regex.hasMatch(value) ? null : PhoneNumberValidationError.invalid;
  }
}