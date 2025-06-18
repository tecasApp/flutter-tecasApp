import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tecas_app/domain/models/app_user.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;

  AppBloc({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(AppState(user: AppUser.empty)) {
    on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AppLogoutPressed>(_onLogoutPressed);
  }

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      final firebaseUser = await _authenticationRepository.getCurrentUser();
      final user = AppUser.fromFirebaseUser(firebaseUser);

      emit(state.copyWith(user: user));
    } catch (e) {
      emit(state.copyWith(user: AppUser.empty));
    }
  }

  Future<void> _onLogoutPressed(
    AppLogoutPressed event,
    Emitter<AppState> emit,
  ) async {
    await _authenticationRepository.logOut();
    emit(state.copyWith(user: AppUser.empty));
  }
}
