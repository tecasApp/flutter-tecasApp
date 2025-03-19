import 'package:formz/formz.dart';

class ConfirmedPassword extends FormzInput<String, String> {
  final String password;
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmedPassword.dirty({this.password = '', String value = ''}) : super.dirty(value);

  @override
  String? validator(String value) {
    return value == password ? null : 'Passwords do not match';
  }
}