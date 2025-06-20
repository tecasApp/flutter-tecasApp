import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';

import 'package:tecas_app/presentation/features/register/birthday_filter/state/birthday_filter_bloc.dart';
import 'package:tecas_app/presentation/features/register/birthday_filter/view/birthday_filter_form.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/state/email_and_password_bloc.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/view/email_and_password_form.dart';
import 'package:tecas_app/presentation/features/register/personal_inclinations/state/personal_inclinations_bloc.dart';
import 'package:tecas_app/presentation/features/register/personal_inclinations/view/personal_inclinations_form.dart';
import 'package:tecas_app/presentation/features/register/personal_information/state/personal_information_bloc.dart';
import 'package:tecas_app/presentation/features/register/personal_information/view/personal_information_form.dart';
import 'package:tecas_app/presentation/features/register/state/register_flow_bloc.dart';

class RegisterStepperPage extends StatelessWidget {
  const RegisterStepperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFlowBloc, RegisterFlowState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Registro')),
          body: Stepper(
            type: StepperType.horizontal,
            currentStep: state.step.index,
            onStepContinue: null,
            onStepCancel: null,
            controlsBuilder: (_, __) => const SizedBox.shrink(),
            steps: [
              Step(
                title: const Text('M'),
                isActive: state.step.index >= 0,
                content: BlocProvider<EmailAndPasswordBloc>(
                  create:
                      (_) => EmailAndPasswordBloc(
                        context.read<AuthenticationRepository>(),
                      ),
                  child: const EmailAndPasswordForm(),
                ),
              ),
              Step(
                title: const Text('G'),
                isActive: state.step.index >= 1,
                content: BlocProvider<PersonalInformationBloc>(
                  create:
                      (_) => PersonalInformationBloc(
                        context.read<UserRepository>(),
                        context.read<MiscellaneousRepository>(),
                      ),
                  child: const PersonalInformationForm(),
                ),
              ),
              Step(
                title: const Text('B'),
                isActive: state.step.index >= 2,
                content: BlocProvider<BirthdayFilterBloc>(
                  create:
                      (_) => BirthdayFilterBloc(context.read<UserRepository>()),
                  child: const BirthdayFilterForm(),
                ),
              ),
              Step(
                title: const Text('I'),
                isActive: state.step.index >= 3,
                content: BlocProvider<PersonalInclinationsBloc>(
                  create:
                      (_) => PersonalInclinationsBloc(
                        context.read<UserRepository>(),
                        context.read<MiscellaneousRepository>(),
                      ),
                  child: const PersonalInclinationsForm(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
