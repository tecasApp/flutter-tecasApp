import 'package:tecas_app/infrastructure/dtos/personal_information_user_dto.dart';
import 'package:tecas_app/infrastructure/dtos/user_firestore_dto.dart';

abstract class UserService {
  Future<bool> personalInformationRegister(
    PersonalInformationUserDTO personalInformationUserDTO,
  );

  Future<UserFirestoreDTO?> getUserProfile(String uid);
}
