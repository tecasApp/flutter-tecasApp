import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tecas_app/domain/services_def/user_service_def.dart';
import 'package:tecas_app/infrastructure/dtos/user_firestore_dto.dart';

class UserServiceImpl implements UserService {
  final FirebaseFirestore _firestore;

  UserServiceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  DocumentReference<Map<String, dynamic>> _userDocRef(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  @override
  Future<UserFirestoreDTO?> getUserProfile(String uid) async {
    try {
      final doc = await _userDocRef(uid).get();

      if (!doc.exists || doc.data() == null) return null;

      return UserFirestoreDTO.fromMap(doc.data()!, id: doc.id);
    } catch (e) {
      print('Error getting user profile for uid "$uid": $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _userDocRef(uid).update(data);
    } catch (e) {
      print('Error updating user "$uid" with data $data: $e');
      rethrow;
    }
  }

  @override
  Future<void> setUser(String uid, Map<String, dynamic> data) async {
    try {
      await _userDocRef(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error setting user "$uid" with data $data: $e');
      rethrow;
    }
  }
}
