import 'package:tecas_app/domain/entities/user_profile.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/domain/services_def/user_service_def.dart';
import 'package:tecas_app/infrastructure/dtos/personal_inclinations_user_dto.dart';
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
  Future<void> registerPersonalInformation({
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
    await _userService.registerPersonalInformation(personalInformationDTO);
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    final dto = await _userService.getUserProfile(uid);
    if (dto == null) {
      return null;
    }
    final profile = dto.toDomain();
    return profile;
  }

  @override
  Future<void> registerBirthday(DateTime birthday) async {
    return _userService.registerBirthday(await _getCurrentUserId(), birthday);
  }

  @override
  Future<void> deactivateAccount({required String reason}) async {
    return _userService.deactivateUser(
      await _getCurrentUserId(),
      reason: reason,
    );
  }

  @override
  Future<void> registerPersonalInclinations({
    required String gender,
    required String sexualOrientation,
  }) async {
    final personalInclinationsDTO = PersonalInclinationsUserDTO(
      id: await _getCurrentUserId(),
      gender: gender,
      sexualOrientation: sexualOrientation,
    );
    await _userService.registerPersonalInclinations(personalInclinationsDTO);
  }
}
