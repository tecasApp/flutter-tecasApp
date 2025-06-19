import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/entities/app_user.dart';

import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/presentation/features/login/state/login_bloc.dart';
import 'package:tecas_app/presentation/features/login/view/login_form.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginBloc(context.read<AuthenticationRepository>()),
          child: MultiBlocListener(
            listeners: [
              // LoginBloc listener
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.status.isFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content:
                              Text(state.errorMessage ?? 'Login Failure'),
                        ),
                      );
                  }
                  if (state.status.isSuccess) {
                    context
                        .read<AppBloc>()
                        .add(AppUserSubscriptionRequested());
                  }
                },
              ),
              // AppBloc listener
              BlocListener<AppBloc, AppState>(
                listenWhen: (previous, current) =>
                    previous.user != current.user ||
                    previous.profile != current.profile,
                listener: (context, state) {
                  if (state.user != AppUser.empty &&
                      state.profile!.isComplete) {
                    context.go('/home');
                  }
                },
              ),
            ],
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
