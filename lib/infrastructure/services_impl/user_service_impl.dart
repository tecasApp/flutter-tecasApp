import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tecas_app/domain/services_def/user_service.dart';
import 'package:tecas_app/infrastructure/services_impl/dtos/personal_information_user_dto.dart';

class UserServiceImpl implements UserService {
  final FirebaseFirestore _firestore;

  UserServiceImpl({required firestore}): _firestore = firestore;

  @override
  Future<bool> personalInformationRegister(
    PersonalInformationUserDTO personalInformationUserDTO,
  ) async {
    try {
      CollectionReference usersCollection = _firestore.collection('users');

      await usersCollection
          .doc(personalInformationUserDTO.id)
          .set(personalInformationUserDTO.toFirestore());

      return true;
    } catch (e) {
      return false;
    }
  }
}
