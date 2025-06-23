import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/external/form_models/confirm_password.dart';
import 'package:tecas_app/external/form_models/email.dart';
import 'package:tecas_app/external/form_models/password.dart';
import 'package:tecas_app/infrastructure/failures/authentication_failures.dart';

part 'email_and_password_event.dart';
part 'email_and_password_state.dart';

class EmailAndPasswordBloc
    extends Bloc<EmailAndPasswordEvent, EmailAndPasswordState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  EmailAndPasswordBloc(this._authenticationRepository, this._userRepository)
      : super(const EmailAndPasswordState()){
        on<EmailChanged>(_onEmailChanged);
        on<PasswordChanged>(_onPasswordChanged);
        on<ConfirmedPasswordChanged>(_onConfirmedPasswordChanged);
        on<SignUpFormSubmitted>(_onSignUpFormSubmitted);
      }


  void _onEmailChanged(EmailChanged event, Emitter<EmailAndPasswordState> emit) async {
    final email = Email.dirty(event.email);
    emit (state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password, state.confirmedPassword]),
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<EmailAndPasswordState> emit) async {
    final password = Password.dirty(event.password);
    emit (state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password, state.confirmedPassword]),
    ));
  }

  void _onConfirmedPasswordChanged( ConfirmedPasswordChanged event, Emitter<EmailAndPasswordState> emit) async {
      final confirmedPassword = ConfirmedPassword.dirty(
        password: state.password.value, 
        value: event.confirmedPassword,
      );

      emit(state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([state.email, state.password, confirmedPassword]),
      ));
  }

 Future<void> _onSignUpFormSubmitted(SignUpFormSubmitted event, Emitter<EmailAndPasswordState> emit) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );

      await _userRepository.registerUser();
      
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}