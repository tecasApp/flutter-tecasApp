part of 'counter_cubit.dart';

//Equatable es una libreria que permite realizar comparaciones entre 2 objetos no a nivel de
//memoria si no a nivel de atributos, para evitar rerenders innecesarios.
class CounterState extends Equatable {
  final int counter;
  final int transactionCount;

  const CounterState({required this.counter, required this.transactionCount});

  copyWith({int? counter, int? transactionCount}) => CounterState(
    counter: counter ?? this.counter,
    transactionCount: transactionCount ?? this.transactionCount,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [counter, transactionCount];
}
