part of 'personal_information_bloc.dart';

abstract class PersonalInformationEvent extends Equatable {
  const PersonalInformationEvent();

  @override
  List<Object> get props => [];
}

class LoadNationalities extends PersonalInformationEvent {}

class EmailChanged extends PersonalInformationEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class FullNameChanged extends PersonalInformationEvent {
  final String fullName;

  const FullNameChanged(this.fullName);

  @override
  List<Object> get props => [fullName];
}

class UsernameChanged extends PersonalInformationEvent {
  final String username;

  const UsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class NationalityChanged extends PersonalInformationEvent {
  final String nationality;

  const NationalityChanged(this.nationality);

  @override
  List<Object> get props => [nationality];
}

class PhoneNumberChanged extends PersonalInformationEvent {
  final String phoneNumber;

  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}


class PersonalInformationFormSubmitted extends PersonalInformationEvent {}