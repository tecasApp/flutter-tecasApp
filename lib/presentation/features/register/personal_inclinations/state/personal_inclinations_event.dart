part of 'personal_inclinations_bloc.dart';

abstract class PersonalInclinationsEvent extends Equatable {
  const PersonalInclinationsEvent();

  @override
  List<Object> get props => [];
}

class LoadGenders extends PersonalInclinationsEvent {}

class LoadSexualOrientations extends PersonalInclinationsEvent {}

class GenderChanged extends PersonalInclinationsEvent {
  final String gender;
  const GenderChanged(this.gender);

  @override
  List<Object> get props => [gender];
}

class SexualOrientationChanged extends PersonalInclinationsEvent {
  final String sexualOrientation;
  const SexualOrientationChanged(this.sexualOrientation);

  @override
  List<Object> get props => [sexualOrientation];
}

class PersonalInclinationsFormSubmitted extends PersonalInclinationsEvent {}
