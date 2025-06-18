import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tecas_app/domain/services_def/miscellaneous_service_def.dart';

class MiscellaneousServiceImpl implements MiscellaneousService {
  final FirebaseFirestore _firestore;

  MiscellaneousServiceImpl({required firestore}): _firestore = firestore;

  @override
  Future<Map<String, List<String>>> getRegistrationOptions() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('miscellaneous').doc('registration_options').get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
                return data.map((key, value) => MapEntry(key, List<String>.from(value)));
      }
    } catch (e) {
      print("Error getting registration options: $e");
    }
    return {};
  }
}