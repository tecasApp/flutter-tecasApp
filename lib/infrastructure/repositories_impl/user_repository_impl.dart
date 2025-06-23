import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tecas_app/domain/entities/user_profile.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/domain/services_def/user_service_def.dart';
import 'package:tecas_app/infrastructure/dtos/personal_inclinations_user_dto.dart';
import 'package:tecas_app/infrastructure/dtos/personal_information_user_dto.dart';
import 'package:tecas_app/infrastructure/dtos/personal_likes_user_dto.dart';

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
  Future<UserProfile?> getUserProfile(String uid) async {
    final dto = await _userService.getUserProfile(uid);
    if (dto == null) {
      return null;
    }
    final profile = dto.toDomain();
    return profile;
  }

  @override
  Future<void> deactivateAccount({required String reason}) async {
    return _userService.updateUser(
      await _getCurrentUserId(),
      {'isActive': false, 'deactivationReason': reason},
    );
  }

  @override
  Future<void> updateWithStep(
    Map<String, dynamic> data,
    ProfileCompletionStep step,
  ) async {
    final uid = await _getCurrentUserId();

    final dataWithStep = {...data, 'profileCompletionStep': step.name};

    await _userService.updateUser(uid, dataWithStep);
  }

  @override
  Future<void> registerUser() async {
    final uid = await _getCurrentUserId();
    await _userService.setUser(uid, {
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'profileCompletionStep': ProfileCompletionStep.personalInformation.name,
    });
  }

  @override
  Future<void> registerPersonalInformation({
    required String email,
    required String fullName,
    required String username,
    required String nationality,
    required String phoneNumber,
  }) async {
    final dto = PersonalInformationUserDTO(
      email: email,
      fullName: fullName,
      username: username,
      nationality: nationality,
      phoneNumber: phoneNumber,
    );

    await updateWithStep(
      dto.toFirestore(),
      ProfileCompletionStep.birthdayFilter,
    );
  }

  @override
  Future<void> registerPersonalInclinations({
    required String gender,
    required String sexualOrientation,
  }) async {
    final dto = PersonalInclinationsUserDTO(
      gender: gender,
      sexualOrientation: sexualOrientation,
    );

    await updateWithStep(
      dto.toFirestore(),
      ProfileCompletionStep.personalLikes,
    );
  }

  @override
  Future<void> registerBirthday(DateTime birthday) async {
    await updateWithStep({
      'birthdayDate': birthday,
    }, ProfileCompletionStep.personalInclinations);
  }

  @override
  Future<void> registerPersonalLikes({
    required List<String> musicalTastes,
    required List<String> hobbies,
  }) async {
    final dto = PersonalLikesUserDTO(
      musicalTastes: musicalTastes,
      hobbies: hobbies,
    );

    await updateWithStep(dto.toFirestore(), ProfileCompletionStep.complete);
  }
}