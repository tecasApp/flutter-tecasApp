import 'package:tecas_app/domain/entities/user_profile.dart';

abstract class UserRepository {
  Future<bool> personalInformationRegister({
    required String email,
    required String username,
    required String nationality,
    required String fullName,
    required String phoneNumber,
  }
  );

   Future<UserProfile?> getUserProfile(String uid);
}