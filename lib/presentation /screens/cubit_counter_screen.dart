import 'package:block_qbit/presentation%20/blocs/counter_cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitCounterScreen extends StatelessWidget {
  const CubitCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: _CubitCounterView(),
    );
  }
}

class _CubitCounterView extends StatelessWidget {
  const _CubitCounterView();


  @override
  Widget build(BuildContext context) {

    //Usar la siguiente linea implica que flutter evalue la reconstrucción de los widgets,
    //que es eficiente, pero si se puede evitar mejor, Se puede usar un context.selector, o un 
    //widget wrapper como BlocBuilder.  
    //  final counterState = context.watch<CounterCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: context.select((CounterCubit value ) {
          return Text('Cubit counter: ${value.state.transactionCount} ');
        }),
        actions: [
          IconButton(onPressed: () => {
            
            context.read<CounterCubit>().reset()

          }, icon: Icon(Icons.refresh_rounded)),
        ],
      ),

      body: Center(
        child: BlocBuilder<CounterCubit, CounterState>(
          //With flutter block we can specify which  component must permut,  for example:
          //buildWhen: (previous, current) => current.counter !=  previous.counter ,
          builder: (context, state) {
            return Text('Counter value: ${state.counter}');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => {context.read<CounterCubit>().increaseBy(3) },
            heroTag: "1",
            child: const Text("+3"),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () => {context.read<CounterCubit>().increaseBy(2)},
            heroTag: "2",
            child: const Text("+2"),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () => {context.read<CounterCubit>().increaseBy(1)},
            heroTag: "3",
            child: const Text("+1"),
          ),
 
        ],
      ),
    );
  }
}
