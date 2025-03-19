part of 'email_and_password_bloc.dart';

abstract class EmailAndPasswordEvent extends Equatable {
  const EmailAndPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends EmailAndPasswordEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends EmailAndPasswordEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class ConfirmedPasswordChanged extends EmailAndPasswordEvent {
  final String confirmedPassword;

  const ConfirmedPasswordChanged(this.confirmedPassword);

  @override
  List<Object> get props => [confirmedPassword];
}

class SignUpFormSubmitted extends EmailAndPasswordEvent {}