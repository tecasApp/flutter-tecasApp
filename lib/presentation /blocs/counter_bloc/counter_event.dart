part of 'counter_bloc.dart';

sealed class CounterEvent {
  const CounterEvent();
}

class CouneterIncreased extends CounterEvent {
  final int value;
  const CouneterIncreased(this.value);
}
