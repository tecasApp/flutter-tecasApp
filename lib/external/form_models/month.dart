import 'package:formz/formz.dart';

enum MonthValidationError { empty, invalid }

class MonthInput extends FormzInput<String, MonthValidationError> {
  const MonthInput.pure() : super.pure('');
  const MonthInput.dirty([String value = '']) : super.dirty(value);

  @override
  MonthValidationError? validator(String value) {
    final intValue = int.tryParse(value);
    if (value.isEmpty) return MonthValidationError.empty;
    if (intValue == null || intValue < 1 || intValue > 12) {
      return MonthValidationError.invalid;
    }
    return null;
  }
}
