import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/models/app_user.dart';
import 'package:tecas_app/presentation/features/home/view/home_page.dart';
import 'package:tecas_app/presentation/features/login/view/login_page.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/view/email_and_password_page.dart';
import 'package:tecas_app/presentation/features/register/personal_information/view/personal_information_page.dart';

abstract class AppRouter extends ChangeNotifier {
  static GoRouter router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/email_and_password',
          builder: (context, state) => const EmailAndPasswordPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/personal_information_register',
          builder: (context, state) => const PersonalInformationRegisterPage(),
        )
      ],
      // Redirect use for 
      redirect: (BuildContext context, GoRouterState state) {
        final status = context.read<AppBloc>().state.user;
        final location = state.uri.toString();

        if (status == AppUser.empty &&  
        !location.contains('/login') && 
        !location.contains('/email_and_password')) {
      return '/login';
    }

        return null;
      },
    );
}
