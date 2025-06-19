import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tecas_app/domain/entities/app_user.dart';
import 'package:tecas_app/domain/entities/user_profile.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/infrastructure/cache/firestore_user_cache.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final CachedUserProfile _cachedProfile = CachedUserProfile();

  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository,
       super(AppState(user: AppUser.empty)) {
    on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AppLogoutPressed>(_onLogoutPressed);
    on<AppProfileRefreshRequested>(_onProfileRefreshRequested);
  }

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      final firebaseUser = await _authenticationRepository.getCurrentUser();
      final user = AppUser.fromFirebaseUser(firebaseUser);

      if (user != AppUser.empty) {
        final profile = await _cachedProfile.getProfile(
          _userRepository,
          user.uid,
        );
        emit(state.copyWith(user: user, profile: profile));
      } else {
        emit(state.copyWith(user: AppUser.empty, profile: UserProfile.empty));
      }
    } catch (e) {
      emit(state.copyWith(user: AppUser.empty));
    }
  }

  Future<void> _onLogoutPressed(
    AppLogoutPressed event,
    Emitter<AppState> emit,
  ) async {
    await _authenticationRepository.logOut();
    CachedUserProfile().clear();

    emit(const AppState(user: AppUser.empty, profile: UserProfile.empty));
  }

  Future<void> _onProfileRefreshRequested(
    AppProfileRefreshRequested event,
    Emitter<AppState> emit,
  ) async {
    print('🔄 Actualizando el perfil...');
    final firebaseUser = await _authenticationRepository.getCurrentUser();
    final user = AppUser.fromFirebaseUser(firebaseUser);

    if (user == AppUser.empty) {
      print('⚠️ Usuario vacío');
      return;
    }
    print('usuario: ${user.uid}');

    final profile = await _userRepository.getUserProfile(user.uid);

    print('📥 Perfil obtenido: $profile');
    print('📦 Estado anterior: ${state.profile}');
    print('📊 Son iguales? ${state.profile == profile}');

    emit(state.copyWith(user: user, profile: profile ?? UserProfile.empty));
  }
}
