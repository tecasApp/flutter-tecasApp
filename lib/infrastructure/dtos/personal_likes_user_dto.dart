class PersonalLikesUserDTO {
  final String id;
  final List<String> musicalTastes;
  final List<String> hobbies;

  PersonalLikesUserDTO({
    required this.id,
    required this.musicalTastes,
    required this.hobbies,
  });

  factory PersonalLikesUserDTO.fromFirestore(Map<String, dynamic> data) {
    return PersonalLikesUserDTO(
      id: data['id'] ?? '',
      musicalTastes: List<String>.from(data['musicalTastes'] ?? []),
      hobbies: List<String>.from(data['hobbies'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'musicalTastes': musicalTastes,
      'hobbies': hobbies,
    };
  }
}
