import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/state/email_and_password_bloc.dart';

class EmailAndPasswordForm extends StatelessWidget {
  const EmailAndPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailAndPasswordBloc, EmailAndPasswordState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Created Successfully!')),
          );

          context.read<AppBloc>().add(AppUserSubscriptionRequested());

          Future.delayed(const Duration(milliseconds: 300), () {
            final profile = context.read<AppBloc>().state.profile;

            if (!profile!.isComplete) {
              context.go('/personal_information_register');
            } else {
              context.go('/home');
            }
          });
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _EmailInput(),
            const SizedBox(height: 8),
            _PasswordInput(),
            const SizedBox(height: 8),
            _ConfirmPasswordInput(),
            const SizedBox(height: 8),
            _SignUpButton(),
            const SizedBox(height: 4),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (EmailAndPasswordBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('signUpForm_emailInput_textField'),
      onChanged:
          (email) =>
              context.read<EmailAndPasswordBloc>().add(EmailChanged(email)),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email',
        helperText: '',
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (EmailAndPasswordBloc bloc) => bloc.state.password.displayError,
    );

    return TextField(
      key: const Key('signUpForm_passwordInput_textField'),
      onChanged:
          (password) => context.read<EmailAndPasswordBloc>().add(
            PasswordChanged(password),
          ),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'password',
        helperText: '',
        errorText: displayError != null ? 'invalid password' : null,
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (EmailAndPasswordBloc bloc) => bloc.state.confirmedPassword.displayError,
    );

    return TextField(
      key: const Key('signUpForm_confirmedPasswordInput_textField'),
      onChanged:
          (confirmPassword) => context.read<EmailAndPasswordBloc>().add(
            ConfirmedPasswordChanged(confirmPassword),
          ),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'confirm password',
        helperText: '',
        errorText: displayError != null ? 'passwords do not match' : null,
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (EmailAndPasswordBloc bloc) => bloc.state.status.isInProgress,
    );

    if (isInProgress) return const CircularProgressIndicator();

    final isValid = context.select(
      (EmailAndPasswordBloc bloc) => bloc.state.isValid,
    );

    return ElevatedButton(
      key: const Key('signUpForm_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.orangeAccent,
      ),
      onPressed:
          isValid
              ? () => context.read<EmailAndPasswordBloc>().add(
                SignUpFormSubmitted(),
              )
              : null,
      child: const Text('SIGN UP'),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_login_flatButton'),
      onPressed: () => context.go('/login'),
      child: Text('LOG IN', style: TextStyle(color: theme.primaryColor)),
    );
  }
}
