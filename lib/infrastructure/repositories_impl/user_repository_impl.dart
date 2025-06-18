import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/domain/services_def/user_service.dart';
import 'package:tecas_app/infrastructure/services_impl/dtos/personal_information_user_dto.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthenticationRepository _authRepository;
  final UserService _userService;

  String? _cachedId;

  UserRepositoryImpl({ required authRepository, required userService}): _authRepository = authRepository, _userService = userService;

  Future<String> _getCurrentUserId() async {
    if (_cachedId == null) {
      _cachedId = await _authRepository.getCurrentUserId();
      if (_cachedId == null) {
      }
    }
    return _cachedId!;
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

     return _userService.personalInformationRegister(personalInformationDTO);
  }
}
