import 'package:tecas_app/domain/entities/user_profile.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';

class CachedUserProfile {
  static final CachedUserProfile _instance = CachedUserProfile._internal();
  factory CachedUserProfile() => _instance;
  CachedUserProfile._internal();

  UserProfile? _profile;

  Future<UserProfile?> getProfile(UserRepository userRepository, String uid) async {
    if (_profile != null) {
      print('🟡 [CachedUserProfile] Retornando perfil desde caché');
      return _profile;
    }

    print('🔵 [CachedUserProfile] No hay caché, solicitando al repositorio...');
    _profile = await userRepository.getUserProfile(uid);

    if (_profile == null) {
      print('⚠️ [CachedUserProfile] No se encontró perfil en Firestore.');
    } else {
      print('✅ [CachedUserProfile] Perfil obtenido y almacenado en caché: $_profile');
    }

    return _profile;
  }

  void clear() {
    print('🧹 [CachedUserProfile] Caché eliminada');
    _profile = null;
  }
}
