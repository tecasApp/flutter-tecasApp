import 'package:formz/formz.dart';

enum NationalityValidationError {
  required('Nationality can\'t be empty'),
  invalid('Selected nationality is not valid.');

  final String message;
  const NationalityValidationError(this.message);
}

class Nationality extends FormzInput<String, NationalityValidationError> {
  final Set<String> validKeys;

  const Nationality.pure({this.validKeys = const {}}) : super.pure('');
  const Nationality.dirty(String value, {this.validKeys = const {}})
      : super.dirty(value);

  @override
  NationalityValidationError? validator(String value) {
    print('🔎 Validando nacionalidad: $value');
    print('✅ Claves válidas: $validKeys');
    if (value.isEmpty) return NationalityValidationError.required;
    return validKeys.contains(value)
        ? null
        : NationalityValidationError.invalid;
  }
}
