import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/entities/app_user.dart';
import 'package:tecas_app/infrastructure/routes/refresh_stream.dart';

import 'package:tecas_app/presentation/features/home/view/home_page.dart';
import 'package:tecas_app/presentation/features/login/view/login_page.dart';
import 'package:tecas_app/presentation/features/register/state/register_flow_bloc.dart';
import 'package:tecas_app/presentation/features/register/view/register_stepper_page.dart';
import 'package:tecas_app/presentation/features/underage/view/underage_page.dart';

class AppRouter {
  static GoRouter create(AppBloc appBloc) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(appBloc.stream),
      routes: [
        GoRoute(path: '/underage', builder: (_, __) => const UnderagePage()),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(
          path: '/register',
          builder: (context, _) {
            final user = appBloc.state.user;
            final profile = appBloc.state.profile;
            return BlocProvider(
              create: (_) => RegisterFlowBloc(initialProfile: profile, initialUser: user, ),
              child: const RegisterStepperPage(),
            );
          },
        ),
      ],
      redirect: (_, state) {
        final user = appBloc.state.user;
        final profile = appBloc.state.profile;
        final location = state.uri.toString();

        print('🚦 Redirect evaluando...');
        print('👤 User: $user');
        print('📄 Profile: $profile');
        print('🧭 Location: $location');

        final isLoggedIn = user != AppUser.empty;
        final isProfileComplete = profile.isComplete == true;

        final isOnLogin = location.startsWith('/login');
        final isOnRegister = location.startsWith('/register');

        if (!isLoggedIn) {
          if (!isOnLogin && !isOnRegister) {
            return '/login';
          }
          return null;
        }

        if (isLoggedIn && !isProfileComplete) {
          if (!isOnRegister) {
            return '/register';
          }
          return null;
        }

        if (isLoggedIn && isProfileComplete && (isOnLogin || isOnRegister)) {
          return '/home';
        }

        final isDeactivated = profile.isActive == false;
        final isUnderage = profile.deactivationReason == 'underage';
        final isOnUnderage = location.startsWith('/underage');

        if (isLoggedIn && isDeactivated && isUnderage && !isOnUnderage) {
          return '/underage';
        }

        return null;
      },
    );
  }
}
