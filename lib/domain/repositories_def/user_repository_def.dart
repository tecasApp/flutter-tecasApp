abstract class UserRepository {
  Future<bool> personalInformationRegister({
    required String email,
    required String username,
    required String nationality,
    required String fullName,
    required String phoneNumber,
  }

  );
}
