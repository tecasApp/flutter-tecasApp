import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/state/email_and_password_bloc.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/view/email_and_password_form.dart';


class EmailAndPasswordPage extends StatelessWidget {
  const EmailAndPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email And Password Method')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<EmailAndPasswordBloc>(
          create: (_) => EmailAndPasswordBloc(context.read<AuthenticationRepository>()),
          child: const EmailAndPasswordForm(),
        ),
      ),
    );
  }
}