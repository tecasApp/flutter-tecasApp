part of 'personal_likes_bloc.dart';

final class PersonalLikesState extends Equatable {
  const PersonalLikesState({
    this.musicalTastes = const MusicalTastes.pure(),
    this.hobbies = const Hobbies.pure(),
    this.musicalTastesOptions = const [],
    this.hobbiesOptions = const [],
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final MusicalTastes musicalTastes;
  final Hobbies hobbies;
  final List<String> musicalTastesOptions;
  final List<String> hobbiesOptions;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        musicalTastes,
        hobbies,
        musicalTastesOptions,
        hobbiesOptions,
        status,
        isValid,
        errorMessage,
      ];

  PersonalLikesState copyWith({
    MusicalTastes? musicalTastes,
    Hobbies? hobbies,
    List<String>? musicalTastesOptions,
    List<String>? hobbiesOptions,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return PersonalLikesState(
      musicalTastes: musicalTastes ?? this.musicalTastes,
      hobbies: hobbies ?? this.hobbies,
      musicalTastesOptions: musicalTastesOptions ?? this.musicalTastesOptions,
      hobbiesOptions: hobbiesOptions ?? this.hobbiesOptions,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
