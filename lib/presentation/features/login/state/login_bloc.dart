import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/external/form_models/email.dart';
import 'package:tecas_app/external/form_models/password.dart';
import 'package:tecas_app/infrastructure/failures/authentication_failures.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc(this._authenticationRepository)
      : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LogInWithCredentials>(_onLogInWithCredentials);
    on<LogInWithGoogle>(_onLogInWithGoogle);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    
    final email =  Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email,state.password]),
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password =  Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email,password]),
    ));
  }


  Future<void> _onLogInWithCredentials(
      LogInWithCredentials event, Emitter<LoginState> emit) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));

    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_){
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> _onLogInWithGoogle(
      LogInWithGoogle event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_){
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
