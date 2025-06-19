import 'package:tecas_app/domain/entities/user_profile.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/domain/services_def/user_service_def.dart';
import 'package:tecas_app/infrastructure/dtos/personal_information_user_dto.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthenticationRepository _authRepository;
  final UserService _userService;

  UserRepositoryImpl({required authRepository, required userService})
    : _authRepository = authRepository,
      _userService = userService;

  Future<String> _getCurrentUserId() async {
    final id = await _authRepository.getCurrentUserId();
    if (id == null) {
      throw Exception('No se pudo obtener el ID del usuario');
    }
    return id;
  }

  @override
  Future<bool> personalInformationRegister({
    required String email,
    required String fullName,
    required String username,
    required String nationality,
    required String phoneNumber,
  }) async {
    final personalInformationDTO = PersonalInformationUserDTO(
      id: await _getCurrentUserId(),
      email: email,
      fullName: fullName,
      username: username,
      nationality: nationality,
      phoneNumber: phoneNumber,
    );

    print('📤 [UserRepository] Enviando DTO a UserService:');
    print('  ID: ${personalInformationDTO.id}');
    print('  Email: $email');
    print('  Nombre: $fullName');
    print('  Usuario: $username');
    print('  Nacionalidad: $nationality');
    print('  Teléfono: $phoneNumber');

    final result = await _userService.personalInformationRegister(
      personalInformationDTO,
    );

    print(
      result
          ? '✅ [UserRepository] Registro de información personal exitoso.'
          : '❌ [UserRepository] Falló el registro de información personal.',
    );

    return result;
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    final dto = await _userService.getUserProfile(uid);
    print('📤 [UserRepository] Solicitando perfil para UID: $uid');
    if (dto == null) {
      print('❌ [UserRepository] No se encontró perfil para UID: $uid');
      return null; // <-- aquí devuelve null
    }
    final profile = dto.toDomain();
    print('✅ [UserRepository] Perfil encontrado para UID: $uid → $profile');
    return profile;
  }
}
