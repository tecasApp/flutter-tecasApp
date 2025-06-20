import 'package:tecas_app/domain/entities/user_profile.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';

class CachedUserProfile {
  static final CachedUserProfile _instance = CachedUserProfile._internal();
  factory CachedUserProfile() => _instance;
  CachedUserProfile._internal();

  UserProfile _profile = UserProfile.empty;

  Future<UserProfile> getProfile(
    UserRepository userRepository,
    String uid,
  ) async {
    if (!_profile.isComplete) {
      print(
        '🔵 [CachedUserProfile] No hay perfil completo en caché, solicitando al repositorio...',
      );
      _profile = await userRepository.getUserProfile(uid) ?? UserProfile.empty;
      print('✅ [CachedUserProfile] Perfil actualizado: $_profile');
    } else {
      print('🟡 [CachedUserProfile] Retornando perfil desde caché');
    }

    return _profile;
  }

  void clear() {
    print('🧹 [CachedUserProfile] Caché eliminada');
    _profile = UserProfile.empty;
  }
}
