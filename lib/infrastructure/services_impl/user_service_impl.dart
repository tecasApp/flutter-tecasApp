import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tecas_app/domain/services_def/user_service_def.dart';
import 'package:tecas_app/infrastructure/dtos/personal_information_user_dto.dart';
import 'package:tecas_app/infrastructure/dtos/user_firestore_dto.dart';

class UserServiceImpl implements UserService {
  final FirebaseFirestore _firestore;

  UserServiceImpl({required firestore}) : _firestore = firestore;

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

@override
Future<UserFirestoreDTO?> getUserProfile(String uid) async {
  final doc = await _firestore.collection('users').doc(uid).get();

  if (!doc.exists || doc.data() == null) {
    return null;
  }

  return UserFirestoreDTO.fromMap(doc.data()!, id: doc.id);
}
}
