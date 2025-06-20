import 'package:tecas_app/domain/entities/user_profile.dart';

abstract class UserRepository {
  Future<void> registerPersonalInformation({
    required String email,
    required String username,
    required String nationality,
    required String fullName,
    required String phoneNumber,
  }
  );

  Future<void> registerPersonalInclinations({
    required String gender,
    required String sexualOrientation,
  });
  
  Future<void> registerBirthday(DateTime birthday);

  Future<void> deactivateAccount({required String reason});

   Future<UserProfile?> getUserProfile(String uid);
}