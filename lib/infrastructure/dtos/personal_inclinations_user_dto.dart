class PersonalInclinationsUserDTO {
  final String gender;
  final String sexualOrientation;

  PersonalInclinationsUserDTO({
    required this.gender,
    required this.sexualOrientation,
  });

  factory PersonalInclinationsUserDTO.fromFirestore(Map<String, dynamic> data) {
    return PersonalInclinationsUserDTO(
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
