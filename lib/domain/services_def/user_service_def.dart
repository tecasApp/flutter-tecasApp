import 'package:tecas_app/infrastructure/dtos/personal_inclinations_user_dto.dart';
import 'package:tecas_app/infrastructure/dtos/personal_information_user_dto.dart';
import 'package:tecas_app/infrastructure/dtos/user_firestore_dto.dart';

abstract class UserService {
  Future<void> registerPersonalInformation(
    PersonalInformationUserDTO personalInformationUserDTO,
  );

  Future<void> registerPersonalInclinations(
    PersonalInclinationsUserDTO personalInclinationUserDTO,
);

  Future<UserFirestoreDTO?> getUserProfile(String uid);

  Future<void> registerBirthday(String uid, DateTime birthday);

  Future<void> deactivateUser(String uid, {required String reason});
}
