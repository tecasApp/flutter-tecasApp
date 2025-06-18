import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/external/form_models/email.dart';
import 'package:tecas_app/external/form_models/full_name.dart';
import 'package:tecas_app/external/form_models/nationality.dart';
import 'package:tecas_app/external/form_models/phone_number.dart';
import 'package:tecas_app/external/form_models/username.dart';
import 'package:tecas_app/infrastructure/cache/registration_options_cache.dart';
import 'package:tecas_app/infrastructure/failures/user_failures.dart';

part 'personal_information_event.dart';
part 'personal_information_state.dart';

class PersonalInformationBloc
    extends Bloc<PersonalInformationEvent, PersonalInformationState> {
  final UserRepository _userRepository;
  final MiscellaneousRepository _miscellaneousRepository;

  PersonalInformationBloc(this._userRepository, this._miscellaneousRepository)
    : super(const PersonalInformationState()) {
    on<LoadNationalities>(_onLoadNationalities);
    on<EmailChanged>(_onEmailChanged);
    on<FullNameChanged>(_onFullNameChanged);
    on<UsernameChanged>(_onUsernameChanged);
    on<NationalityChanged>(_onNationalityChanged);
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<PersonalInformationFormSubmitted>(_onPersonalInformationFormSubmitted);
  }

  Future<void> _onLoadNationalities(
    LoadNationalities event,
    Emitter<PersonalInformationState> emit,
  ) async {
    print("🟢 Entró a _onLoadNationalities");

    final options = await CachedRegistrationOptions().getOptions(
      _miscellaneousRepository,
    );
    print("📦 Options obtenidas: $options");

    final nationalities = options['nationalities'] ?? [];
    print("🌍 Nationalities encontradas: $nationalities");

    emit(state.copyWith(nationalities: nationalities));
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<PersonalInformationState> emit,
  ) async {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.fullName,
          state.username,
          state.nationality,
          state.phoneNumber,
        ]),
      ),
    );
  }

  void _onFullNameChanged(
    FullNameChanged event,
    Emitter<PersonalInformationState> emit,
  ) async {
    final fullName = FullName.dirty(event.fullName);
    emit(
      state.copyWith(
        fullName: fullName,
        isValid: Formz.validate([
          state.email,
          fullName,
          state.username,
          state.nationality,
          state.phoneNumber,
        ]),
      ),
    );
  }

  void _onUsernameChanged(
    UsernameChanged event,
    Emitter<PersonalInformationState> emit,
  ) async {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([
          state.email,
          state.fullName,
          username,
          state.nationality,
          state.phoneNumber,
        ]),
      ),
    );
  }

  void _onNationalityChanged(
    NationalityChanged event,
    Emitter<PersonalInformationState> emit,
  ) async {
    final validNationalities = state.nationalities.toSet();
    final nationality = Nationality.dirty(
      event.nationality,
      validKeys: validNationalities,
    );
    emit(
      state.copyWith(
        nationality: nationality,
        isValid: Formz.validate([
          state.email,
          state.fullName,
          state.username,
          nationality,
          state.phoneNumber,
        ]),
      ),
    );
  }

  void _onPhoneNumberChanged(
    PhoneNumberChanged event,
    Emitter<PersonalInformationState> emit,
  ) async {
    final phoneNumber = PhoneNumber.dirty(event.phoneNumber);
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([
          state.email,
          state.fullName,
          state.username,
          state.nationality,
          phoneNumber,
        ]),
      ),
    );
  }

  Future<void> _onPersonalInformationFormSubmitted(
    PersonalInformationEvent event,
    Emitter<PersonalInformationState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.personalInformationRegister(
        email: state.email.value,
        fullName: state.fullName.value,
        username: state.username.value,
        nationality: state.nationality.value,
        phoneNumber: state.phoneNumber.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on PersonalInformationRegisterFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
