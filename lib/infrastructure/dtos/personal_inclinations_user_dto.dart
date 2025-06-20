class PersonalInclinationsUserDTO {
  final String id;
  final String gender;
  final String sexualOrientation;

  PersonalInclinationsUserDTO({
    required this.id,
    required this.gender,
    required this.sexualOrientation,
  });

  factory PersonalInclinationsUserDTO.fromFirestore(Map<String, dynamic> data) {
    return PersonalInclinationsUserDTO(
      id: data['id'] ?? '',
      gender: data['gender'] ?? '',
      sexualOrientation: data['sexualOrientation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'gender': gender,
      'sexualOrientation': sexualOrientation,
    };
  }
}
