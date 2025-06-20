part of 'birthday_filter_bloc.dart';

abstract class BirthdayFilterEvent extends Equatable {
  const BirthdayFilterEvent();

  @override
  List<Object> get props => [];
}

class DayChanged extends BirthdayFilterEvent {
  final String day;
  const DayChanged(this.day);

  @override
  List<Object> get props => [day];
}

class MonthChanged extends BirthdayFilterEvent {
  final String month;
  const MonthChanged(this.month);

  @override
  List<Object> get props => [month];
}

class YearChanged extends BirthdayFilterEvent {
  final String year;
  const YearChanged(this.year);

  @override
  List<Object> get props => [year];
}

class BirthdaySubmitted extends BirthdayFilterEvent {}
