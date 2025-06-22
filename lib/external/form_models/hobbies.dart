import 'package:formz/formz.dart';

enum HobbiesValidationError {
  required('Debes seleccionar al menos un hobby'),
  invalid('Uno o más hobbies seleccionados no son válidos.');

  final String message;
  const HobbiesValidationError(this.message);
}

class Hobbies extends FormzInput<List<String>, HobbiesValidationError> {
  final Set<String> validOptions;

  const Hobbies.pure({this.validOptions = const {}}) : super.pure(const []);
  const Hobbies.dirty(List<String> value, {this.validOptions = const {}})
      : super.dirty(value);

  @override
  HobbiesValidationError? validator(List<String> value) {
    if (value.isEmpty) return HobbiesValidationError.required;
    if (!value.every((v) => validOptions.contains(v))) {
      return HobbiesValidationError.invalid;
    }
    return null;
  }
}
