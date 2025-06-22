import 'package:formz/formz.dart';

enum MusicalTastesValidationError {
  required('Debes seleccionar al menos un gusto musical'),
  invalid('Una o más opciones seleccionadas no son válidas.');

  final String message;
  const MusicalTastesValidationError(this.message);
}

class MusicalTastes extends FormzInput<List<String>, MusicalTastesValidationError> {
  final Set<String> validOptions;

  const MusicalTastes.pure({this.validOptions = const {}}) : super.pure(const []);
  const MusicalTastes.dirty(List<String> value, {this.validOptions = const {}})
      : super.dirty(value);

  @override
  MusicalTastesValidationError? validator(List<String> value) {
    if (value.isEmpty) return MusicalTastesValidationError.required;
    if (!value.every((v) => validOptions.contains(v))) {
      return MusicalTastesValidationError.invalid;
    }
    return null;
  }
}
