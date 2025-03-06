import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super( CounterState( counter: 5, transactionCount: 5));

  //EL ESTADO ES INMUTABLE LO QUE YO REALMENTE HAGO ES UNA COPIA DEL ESTADO ANTERIOR Y LE APLICO
  //CIERTAS MODIFICACIONES.
  void increaseBy(int value){
  //Con el uso del copywith definido en ele otro archivo hacemos una copia direcata del estado
  //anterior para luego modificar sus valores.
    emit(

      state.copyWith(counter: state.counter + value, transactionCount: state.transactionCount + 1)   
    );
  }

  void reset( ){

    emit(

      state.copyWith(counter: 0)
    );

  }

}
