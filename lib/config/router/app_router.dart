import 'package:block_qbit/presentation%20/screens/block_counter_screen.dart';
import 'package:block_qbit/presentation%20/screens/cubit_counter_screen.dart';
import 'package:block_qbit/presentation%20/screens/home_screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: "/cubits",
      builder: (context, state) => const CubitCounterScreen(),
    ),

    GoRoute(
      path: "/counter-bloc",
      builder: (context, state) => const BlockCounterScreen(),
    ),
  ],
);
