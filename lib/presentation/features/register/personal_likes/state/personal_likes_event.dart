part of 'personal_likes_bloc.dart';

abstract class PersonalLikesEvent extends Equatable {
  const PersonalLikesEvent();

  @override
  List<Object> get props => [];
}

class LoadMusicalTastes extends PersonalLikesEvent {}
class LoadHobbies extends PersonalLikesEvent {}

class MusicalTastesChanged extends PersonalLikesEvent {
  final List<String> musicalTastes;
  const MusicalTastesChanged(this.musicalTastes);

  @override
  List<Object> get props => [musicalTastes];
}

class HobbiesChanged extends PersonalLikesEvent {
  final List<String> hobbies;
  const HobbiesChanged(this.hobbies);

  @override
  List<Object> get props => [hobbies];
}


class PersonalLikesFormSubmitted extends PersonalLikesEvent {}