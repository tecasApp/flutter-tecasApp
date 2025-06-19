import 'package:go_router/go_router.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/entities/app_user.dart';
import 'package:tecas_app/infrastructure/routes/refresh_stream.dart';
import 'package:tecas_app/presentation/features/home/view/home_page.dart';
import 'package:tecas_app/presentation/features/login/view/login_page.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/view/email_and_password_page.dart';
import 'package:tecas_app/presentation/features/register/personal_information/view/personal_information_page.dart';

class AppRouter {
  static GoRouter create(AppBloc appBloc) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(appBloc.stream),
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(
          path: '/email_and_password',
          builder: (_, __) => const EmailAndPasswordPage(),
        ),
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(
          path: '/personal_information_register',
          builder: (_, __) => const PersonalInformationRegisterPage(),
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

        if (user == AppUser.empty) {
          if (!location.startsWith('/login') &&
              !location.startsWith('/email_and_password')) {
            return '/login';
          }
          return null;
        }

        final needsProfile = profile == null || !profile.isComplete;

        if (needsProfile && location != '/personal_information_register') {
          return '/personal_information_register';
        }

        if (!needsProfile &&
            (location == '/login' ||
                location == '/email_and_password' ||
                location == '/personal_information_register')) {
          return '/home';
        }

        return null;
      },
    );
  }
}
