part of 'personal_information_bloc.dart';

final class PersonalInformationState extends Equatable {

  const PersonalInformationState({
    this.email = const Email.pure(),
    this.fullName = const FullName.pure(),
    this.username = const Username.pure(),
    this.nationalities = const [],
    this.nationality = const Nationality.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Email email;
  final FullName fullName;
  final Username username;  
  final Nationality nationality;
  final List<String> nationalities;
  final PhoneNumber phoneNumber;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        fullName, 
        username,
        nationality,
        nationalities,
        phoneNumber,
        status,
        isValid,
        errorMessage,
      ];

  PersonalInformationState copyWith({
    Email? email,
    FullName? fullName,
    Username? username,
    List<String>? nationalities,
    Nationality? nationality,
    PhoneNumber? phoneNumber,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return PersonalInformationState(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      nationalities: nationalities ?? this.nationalities,
      nationality: nationality ?? this.nationality,
      phoneNumber: phoneNumber ?? this.phoneNumber, 
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}