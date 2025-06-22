import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/external/form_models/hobbies.dart';
import 'package:tecas_app/external/form_models/musical_tastes.dart';
import 'package:tecas_app/infrastructure/cache/registration_options_cache.dart';

part 'personal_likes_event.dart';
part 'personal_likes_state.dart';

class PersonalLikesBloc extends Bloc<PersonalLikesEvent, PersonalLikesState> {
  final UserRepository _userRepository;
  final MiscellaneousRepository _miscellaneousRepository;

  PersonalLikesBloc(this._userRepository, this._miscellaneousRepository)
      : super(const PersonalLikesState()) {
    on<LoadMusicalTastes>(_onLoadMusicalTastes);
    on<LoadHobbies>(_onLoadHobbies);
    on<MusicalTastesChanged>(_onMusicalTastesChanged);
    on<HobbiesChanged>(_onHobbiesChanged);
    on<PersonalLikesFormSubmitted>(_onFormSubmitted);
  }

  Future<void> _onLoadMusicalTastes(
    LoadMusicalTastes event,
    Emitter<PersonalLikesState> emit,
  ) async {
    final options = await CachedRegistrationOptions().getOptions(_miscellaneousRepository);
    final musicalTastes = options['musical_tastes'] ?? [];
    emit(state.copyWith(musicalTastesOptions: musicalTastes));
  }

  Future<void> _onLoadHobbies(
    LoadHobbies event,
    Emitter<PersonalLikesState> emit,
  ) async {
    final options = await CachedRegistrationOptions().getOptions(_miscellaneousRepository);
    final hobbies = options['hobbies'] ?? [];
    emit(state.copyWith(hobbiesOptions: hobbies));
  }

  void _onMusicalTastesChanged(
    MusicalTastesChanged event,
    Emitter<PersonalLikesState> emit,
  ) {
    final tastes = MusicalTastes.dirty(
      event.musicalTastes,
      validOptions: state.musicalTastesOptions.toSet(),
    );
    emit(state.copyWith(
      musicalTastes: tastes,
      isValid: Formz.validate([
        tastes,
        state.hobbies,
      ]),
    ));
  }

  void _onHobbiesChanged(
    HobbiesChanged event,
    Emitter<PersonalLikesState> emit,
  ) {
    final hobbies = Hobbies.dirty(
      event.hobbies,
      validOptions: state.hobbiesOptions.toSet(),
    );
    emit(state.copyWith(
      hobbies: hobbies,
      isValid: Formz.validate([
        state.musicalTastes,
        hobbies,
      ]),
    ));
  }

  Future<void> _onFormSubmitted(
    PersonalLikesFormSubmitted event,
    Emitter<PersonalLikesState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _userRepository.registerPersonalLikes(
        musicalTastes: state.musicalTastes.value,
        hobbies: state.hobbies.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Error inesperado al guardar gustos.',
      ));
    }
  }
}
