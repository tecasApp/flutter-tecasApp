import 'package:formz/formz.dart';

enum DayValidationError { empty, invalid }

class DayInput extends FormzInput<String, DayValidationError> {
  const DayInput.pure() : super.pure('');
  const DayInput.dirty([String value = '']) : super.dirty(value);

  @override
  DayValidationError? validator(String value) {
    final intValue = int.tryParse(value);
    if (value.isEmpty) return DayValidationError.empty;
    if (intValue == null || intValue < 1 || intValue > 31) {
      return DayValidationError.invalid;
    }
    return null;
  }
}
