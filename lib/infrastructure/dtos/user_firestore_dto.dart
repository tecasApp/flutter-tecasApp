import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tecas_app/domain/entities/user_profile.dart';

class UserFirestoreDTO {
  final String id;
  final String email;
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
  final String? profileCompletionStep;
  final String? deactivationReason;

  const UserFirestoreDTO({
    required this.id,
    required this.email,
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
    this.profileCompletionStep,
  });

  factory UserFirestoreDTO.fromMap(Map<String, dynamic> map, {required String id}) {
    return UserFirestoreDTO(
      id: id,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      nationality: map['nationality'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      birthdayDate: (map['birthdayDate'] as Timestamp?)?.toDate(),
      gender: map['gender'],
      sexualOrientation: map['sexualOrientation'],
      hobbies: List<String>.from(map['hobbies'] ?? []),
      musicalTastes: List<String>.from(map['musicalTastes'] ?? []),
      isActive: map['isActive'] ?? true,
      deactivationReason: map['deactivationReason'],
      profileCompletionStep: map['profileCompletionStep'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'username': username,
      'nationality': nationality,
      'phoneNumber': phoneNumber,
      'birthdayDate': birthdayDate != null ? Timestamp.fromDate(birthdayDate!) : null,
      'gender': gender,
      'sexualOrientation': sexualOrientation,
      'hobbies': hobbies,
      'musicalTastes': musicalTastes,
      'isActive': isActive,
      'deactivationReason': deactivationReason,
      'profileCompletionStep': profileCompletionStep,
    };
  }

  UserProfile toDomain() {
    return UserProfile(
      fullName: fullName,
      username: username,
      nationality: nationality,
      phoneNumber: phoneNumber,
      birthdayDate: birthdayDate,
      gender: gender,
      sexualOrientation: sexualOrientation,
      hobbies: hobbies,
      musicalTastes: musicalTastes,
      isActive: isActive,
      deactivationReason: deactivationReason,
      profileCompletionStep: _mapProfileStepFromString(profileCompletionStep),
    );
  }

  factory UserFirestoreDTO.fromDomain(
    UserProfile profile, {
    required String id,
    required String email,
  }) {
    return UserFirestoreDTO(
      id: id,
      email: email,
      fullName: profile.fullName,
      username: profile.username,
      nationality: profile.nationality,
      phoneNumber: profile.phoneNumber,
      birthdayDate: profile.birthdayDate,
      gender: profile.gender,
      sexualOrientation: profile.sexualOrientation,
      hobbies: profile.hobbies,
      musicalTastes: profile.musicalTastes,
      isActive: profile.isActive,
      deactivationReason: profile.deactivationReason,
      profileCompletionStep: profile.profileCompletionStep?.name,
    );
  }

  ProfileCompletionStep? _mapProfileStepFromString(String? step) {
    if (step == null) return null;
    return ProfileCompletionStep.values.firstWhere(
      (e) => e.name == step,
      orElse: () => ProfileCompletionStep.personalInformation,
    );
  }
}
