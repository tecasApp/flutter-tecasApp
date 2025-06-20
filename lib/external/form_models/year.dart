import 'package:formz/formz.dart';

enum YearValidationError { empty, invalid }

class YearInput extends FormzInput<String, YearValidationError> {
  const YearInput.pure() : super.pure('');
  const YearInput.dirty([String value = '']) : super.dirty(value);

  @override
  YearValidationError? validator(String value) {
    final intValue = int.tryParse(value);
    final currentYear = DateTime.now().year;
    if (value.isEmpty) return YearValidationError.empty;
    if (intValue == null || intValue < 1900 || intValue > currentYear) {
      return YearValidationError.invalid;
    }
    return null;
  }
}
