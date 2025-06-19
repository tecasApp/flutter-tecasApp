class UserProfile {
  final String fullName;
  final String username;
  final String nationality;
  final String phoneNumber;
  final DateTime? birthdayDate;
  final String? gender;
  final String? sexualOrientation;
  final List<String> hobbies;
  final List<String> musicalTastes;

  const UserProfile({
    required this.fullName,
    required this.username,
    required this.nationality,
    required this.phoneNumber,
    required this.birthdayDate,
    this.gender,
    this.sexualOrientation,
    this.hobbies = const [],
    this.musicalTastes = const [],
  });

  static const empty = UserProfile(
    fullName: '',
    username: '',
    nationality: '',
    phoneNumber: '',
    birthdayDate: null,
  );

  bool get isComplete {
  final complete = fullName.isNotEmpty && username.isNotEmpty;
  print('🧩 Evaluando isComplete → $complete');
  return complete;
}

  @override
  String toString() {
    return '''
UserProfile(
  fullName: $fullName,
  username: $username,
  nationality: $nationality,
  phoneNumber: $phoneNumber,
  birthdayDate: $birthdayDate,
  gender: $gender,
  sexualOrientation: $sexualOrientation,
  hobbies: $hobbies,
  musicalTastes: $musicalTastes
)
''';
  }
}
