import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';

import 'package:tecas_app/domain/entities/app_user.dart';
import 'package:tecas_app/domain/entities/user_profile.dart';
import 'package:tecas_app/presentation/features/register/birthday_filter/state/birthday_filter_bloc.dart';
import 'package:tecas_app/presentation/features/register/birthday_filter/view/birthday_filter_form.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/state/email_and_password_bloc.dart';
import 'package:tecas_app/presentation/features/register/email_and_password/view/email_and_password_form.dart';
import 'package:tecas_app/presentation/features/register/personal_inclinations/state/personal_inclinations_bloc.dart';
import 'package:tecas_app/presentation/features/register/personal_inclinations/view/personal_inclinations_form.dart';
import 'package:tecas_app/presentation/features/register/personal_information/state/personal_information_bloc.dart';
import 'package:tecas_app/presentation/features/register/personal_information/view/personal_information_form.dart';
import 'package:tecas_app/presentation/features/register/personal_likes/state/personal_likes_bloc.dart';
import 'package:tecas_app/presentation/features/register/personal_likes/view/personal_likes_form.dart';

class RegisterStepperPage extends StatelessWidget {
  const RegisterStepperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final user = state.user;
        final profile = state.profile;

        if (profile.isComplete == true) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentStep = getStepFromUserAndProfile(user, profile);

        return Scaffold(
          appBar: AppBar(title: const Text('Registro')),
          body: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepContinue: null,
            onStepCancel: null,
            controlsBuilder: (_, __) => const SizedBox.shrink(),
            steps: [
              Step(
                title: const Text('M'),
                isActive: currentStep >= 0,
                content: BlocProvider(
                  create:
                      (_) => EmailAndPasswordBloc(
                        context.read<AuthenticationRepository>(),
                        context.read<UserRepository>(),
                      ),
                  child: const EmailAndPasswordForm(),
                ),
              ),
              Step(
                title: const Text('G'),
                isActive: currentStep >= 1,
                content: BlocProvider(
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
                isActive: currentStep >= 2,
                content: BlocProvider(
                  create:
                      (_) => BirthdayFilterBloc(context.read<UserRepository>()),
                  child: const BirthdayFilterForm(),
                ),
              ),
              Step(
                title: const Text('I'),
                isActive: currentStep >= 3,
                content: BlocProvider(
                  create:
                      (_) => PersonalInclinationsBloc(
                        context.read<UserRepository>(),
                        context.read<MiscellaneousRepository>(),
                      ),
                  child: const PersonalInclinationsForm(),
                ),
              ),
              Step(
                title: const Text('L'),
                isActive: currentStep >= 4,
                content: BlocProvider(
                  create:
                      (_) => PersonalLikesBloc(
                        context.read<UserRepository>(),
                        context.read<MiscellaneousRepository>(),
                      ),
                  child: const PersonalLikesForm(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

int getStepFromUserAndProfile(AppUser user, UserProfile profile) {
  if (user == AppUser.empty) return 0;

  final step = profile.profileCompletionStep;

  return switch (step) {
    ProfileCompletionStep.personalInformation => 1,
    ProfileCompletionStep.birthdayFilter => 2,
    ProfileCompletionStep.personalInclinations => 3,
    ProfileCompletionStep.personalLikes => 4,
    ProfileCompletionStep.complete => 4,
    null => 0,
  };
}
