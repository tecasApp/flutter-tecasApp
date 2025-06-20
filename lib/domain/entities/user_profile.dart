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
  final bool isActive;
  final String? deactivationReason;

  const UserProfile({
    required this.fullName,
    required this.username,
    required this.nationality,
    required this.phoneNumber,
    this.birthdayDate,
    this.gender,
    this.sexualOrientation,
    this.hobbies = const [],
    this.musicalTastes = const [],
    this.isActive = true,
    this.deactivationReason,
  });

  bool get isComplete =>
      fullName.isNotEmpty &&
      username.isNotEmpty &&
      nationality.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      birthdayDate != null &&
      gender?.isNotEmpty == true &&
      sexualOrientation?.isNotEmpty == true;
  // hobbies.isNotEmpty &&
  // musicalTastes.isNotEmpty;

  UserProfile copyWith({
    String? fullName,
    String? username,
    String? nationality,
    String? phoneNumber,
    DateTime? birthdayDate,
    String? gender,
    String? sexualOrientation,
    List<String>? hobbies,
    List<String>? musicalTastes,
    bool? isActive,
    String? deactivationReason,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      nationality: nationality ?? this.nationality,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthdayDate: birthdayDate ?? this.birthdayDate,
      gender: gender ?? this.gender,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      hobbies: hobbies ?? this.hobbies,
      musicalTastes: musicalTastes ?? this.musicalTastes,
      isActive: isActive ?? this.isActive,
      deactivationReason: deactivationReason ?? this.deactivationReason,
    );
  }

  static const empty = UserProfile(
    fullName: '',
    username: '',
    nationality: '',
    phoneNumber: '',
    isActive: true,
  );

  @override
  String toString() {
    if (this == UserProfile.empty) {
      return 'UserProfile: empty';
    }
    return 'UserProfile(fullName: $fullName, username: $username, nationality: $nationality, phoneNumber: $phoneNumber, birthdayDate: $birthdayDate, gender: $gender, sexualOrientation: $sexualOrientation, hobbies: $hobbies, musicalTastes: $musicalTastes, isActive: $isActive, deactivationReason: $deactivationReason)';
  }
}