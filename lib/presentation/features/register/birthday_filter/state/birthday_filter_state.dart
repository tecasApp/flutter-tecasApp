part of 'birthday_filter_bloc.dart';

class BirthdayFilterState extends Equatable {
  final DayInput day;
  final MonthInput month;
  final YearInput year;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const BirthdayFilterState({
    this.day = const DayInput.pure(),
    this.month = const MonthInput.pure(),
    this.year = const YearInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  BirthdayFilterState copyWith({
    DayInput? day,
    MonthInput? month,
    YearInput? year,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return BirthdayFilterState(
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [day, month, year, status, isValid, errorMessage];
}
