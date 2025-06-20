import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';

import 'package:tecas_app/external/form_models/day.dart';
import 'package:tecas_app/external/form_models/month.dart';
import 'package:tecas_app/external/form_models/year.dart';

part 'birthday_filter_event.dart';
part 'birthday_filter_state.dart';

class BirthdayFilterBloc
    extends Bloc<BirthdayFilterEvent, BirthdayFilterState> {
  final UserRepository _userRepository;

  BirthdayFilterBloc(this._userRepository) : super(const BirthdayFilterState()) {
    on<DayChanged>(_onDayChanged);
    on<MonthChanged>(_onMonthChanged);
    on<YearChanged>(_onYearChanged);
    on<BirthdaySubmitted>(_onSubmitted);
  }

  void _onDayChanged(DayChanged event, Emitter<BirthdayFilterState> emit) {
    final day = DayInput.dirty(event.day);
    final isValid = _validateDate(day, state.month, state.year);
    emit(
      state.copyWith(
        day: day,
        isValid: isValid,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onMonthChanged(MonthChanged event, Emitter<BirthdayFilterState> emit) {
    final month = MonthInput.dirty(event.month);
    final isValid = _validateDate(state.day, month, state.year);
    emit(
      state.copyWith(
        month: month,
        isValid: isValid,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onYearChanged(YearChanged event, Emitter<BirthdayFilterState> emit) {
    final year = YearInput.dirty(event.year);
    final isValid = _validateDate(state.day, state.month, year);
    emit(
      state.copyWith(
        year: year,
        isValid: isValid,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

Future<void> _onSubmitted(
  BirthdaySubmitted event,
  Emitter<BirthdayFilterState> emit,
) async {
  if (!state.isValid) {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Fecha inválida. Asegúrate de que día, mes y año formen una fecha real.',
      ),
    );
    return;
  }

  emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

  final d = int.parse(state.day.value);
  final m = int.parse(state.month.value);
  final y = int.parse(state.year.value);
  final birthday = DateTime(y, m, d);

  final today = DateTime.now();
  final age = today.year - birthday.year - ((today.month < birthday.month || (today.month == birthday.month && today.day < birthday.day)) ? 1 : 0);

  try {
    await _userRepository.registerBirthday(birthday);

    if (age < 18) {
      await _userRepository.deactivateAccount(reason: 'underage');

      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Debes tener al menos 18 años para usar la aplicación. Tu cuenta ha sido desactivada.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.success));
  } catch (_) {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Error inesperado al registrar la fecha.',
      ),
    );
  }
}


  bool _validateDate(DayInput day, MonthInput month, YearInput year) {
    final inputsValid = Formz.validate([day, month, year]);
    if (!inputsValid) return false;

    final d = int.tryParse(day.value);
    final m = int.tryParse(month.value);
    final y = int.tryParse(year.value);

    if (d == null || m == null || y == null) return false;

    try {
      final date = DateTime(y, m, d);
      return date.day == d && date.month == m && date.year == y;
    } catch (_) {
      return false;
    }
  }
}
