class PersonalInformationUserDTO {
  final String email;
  final String fullName;
  final String username;
  final String nationality;
  final String phoneNumber;

  PersonalInformationUserDTO({
    required this.email,
    required this.fullName,
    required this.username,
    required this.nationality,
    required this.phoneNumber,
  });

  factory PersonalInformationUserDTO.fromFirestore(Map<String, dynamic> data) {
    return PersonalInformationUserDTO(
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      nationality: data['nationality'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'username': username,
      'nationality': nationality,
      'phoneNumber': phoneNumber,
      'isActive': true,
    };
  }
}
