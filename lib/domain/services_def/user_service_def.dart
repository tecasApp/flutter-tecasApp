
import 'package:tecas_app/infrastructure/dtos/user_firestore_dto.dart';

abstract class UserService {

  Future<UserFirestoreDTO?> getUserProfile(String uid);

  Future<void> updateUser(String uid, Map<String, dynamic> data);

  Future<void> setUser(String uid, Map<String, dynamic> data);

}
