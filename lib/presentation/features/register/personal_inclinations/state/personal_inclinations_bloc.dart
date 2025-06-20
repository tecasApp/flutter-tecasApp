import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/external/form_models/gender.dart';
import 'package:tecas_app/external/form_models/sexual_orientation.dart';
import 'package:tecas_app/infrastructure/cache/registration_options_cache.dart';

part 'personal_inclinations_event.dart';
part 'personal_inclinations_state.dart';

class PersonalInclinationsBloc
    extends Bloc<PersonalInclinationsEvent, PersonalInclinationsState> {
  final UserRepository _userRepository;
  final MiscellaneousRepository _miscellaneousRepository;

  PersonalInclinationsBloc(this._userRepository, this._miscellaneousRepository)
      : super(const PersonalInclinationsState()) {
    on<GenderChanged>(_onGenderChanged);
    on<SexualOrientationChanged>(_onSexualOrientationChanged);
    on<LoadGenders>(_onLoadGenders);
    on<LoadSexualOrientations>(_onLoadSexualOrientations);
    on<PersonalInclinationsFormSubmitted>(_onFormSubmitted);
  }

  Future<void> _onLoadGenders(
    LoadGenders event,
    Emitter<PersonalInclinationsState> emit,
  ) async {
    final options = await CachedRegistrationOptions().getOptions(_miscellaneousRepository);
    print('options: ${options}');
    final genders = options['gender'] ?? [];
    emit(state.copyWith(genderOptions: genders));
  }

  Future<void> _onLoadSexualOrientations(
    LoadSexualOrientations event,
    Emitter<PersonalInclinationsState> emit,
  ) async {
    final options = await CachedRegistrationOptions().getOptions(_miscellaneousRepository);
    final orientations = options['sexual_orientation'] ?? [];
    emit(state.copyWith(sexualOrientationOptions: orientations));
  }

  void _onGenderChanged(
    GenderChanged event,
    Emitter<PersonalInclinationsState> emit,
  ) {
    final gender = Gender.dirty(
      event.gender,
      validKeys: state.genderOptions.toSet(),
    );
    emit(state.copyWith(
      gender: gender,
      isValid: Formz.validate([gender, state.sexualOrientation]),
    ));
  }

  void _onSexualOrientationChanged(
    SexualOrientationChanged event,
    Emitter<PersonalInclinationsState> emit,
  ) {
    final orientation = SexualOrientation.dirty(
      event.sexualOrientation,
      validKeys: state.sexualOrientationOptions.toSet(),
    );
    emit(state.copyWith(
      sexualOrientation: orientation,
      isValid: Formz.validate([state.gender, orientation]),
    ));
  }

  Future<void> _onFormSubmitted(
    PersonalInclinationsFormSubmitted event,
    Emitter<PersonalInclinationsState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _userRepository.registerPersonalInclinations(
        gender: state.gender.value,
        sexualOrientation: state.sexualOrientation.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Error inesperado al guardar inclinaciones.',
      ));
    }
  }
}
