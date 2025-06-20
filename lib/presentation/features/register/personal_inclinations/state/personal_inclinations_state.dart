part of 'personal_inclinations_bloc.dart';

final class PersonalInclinationsState extends Equatable {
  const PersonalInclinationsState({
    this.gender = const Gender.pure(),
    this.sexualOrientation = const SexualOrientation.pure(),
    this.genderOptions = const [],
    this.sexualOrientationOptions = const [],
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Gender gender;
  final SexualOrientation sexualOrientation;
  final List<String> genderOptions;
  final List<String> sexualOrientationOptions;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        gender,
        sexualOrientation,
        genderOptions,
        sexualOrientationOptions,
        status,
        isValid,
        errorMessage,
      ];

  PersonalInclinationsState copyWith({
    Gender? gender,
    SexualOrientation? sexualOrientation,
    List<String>? genderOptions,
    List<String>? sexualOrientationOptions,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return PersonalInclinationsState(
      gender: gender ?? this.gender,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      genderOptions: genderOptions ?? this.genderOptions,
      sexualOrientationOptions:
          sexualOrientationOptions ?? this.sexualOrientationOptions,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
