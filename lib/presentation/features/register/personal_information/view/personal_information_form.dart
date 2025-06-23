import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/external/form_models/nationality.dart';
import 'package:tecas_app/presentation/features/register/personal_information/state/personal_information_bloc.dart';

class PersonalInformationForm extends StatelessWidget {
  const PersonalInformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<PersonalInformationBloc>().add(LoadNationalities());
    });
    return BlocListener<PersonalInformationBloc, PersonalInformationState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Personal Information Registered Successfully!'),
            ),
          );

          context.read<AppBloc>().add(AppProfileRefreshRequested());

        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Personal Information Register Failure',
                ),
              ),
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
            _FullNameInput(),
            const SizedBox(height: 8),
            _UsernameInput(),
            const SizedBox(height: 8),
            _NationalityInput(),
            const SizedBox(height: 4),
            _PhoneNumberInput(),
            const SizedBox(height: 4),
            _PersonalInformationRegisterButton(),
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
      (PersonalInformationBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('personalInformationRegister_emailInput_textField'),
      onChanged:
          (email) =>
              context.read<PersonalInformationBloc>().add(EmailChanged(email)),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email',
        helperText: '',
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (PersonalInformationBloc bloc) => bloc.state.fullName.displayError,
    );

    return TextField(
      key: const Key('personalInformationRegister_fullNameInput_textField'),
      onChanged:
          (fullName) => context.read<PersonalInformationBloc>().add(
            FullNameChanged(fullName),
          ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'full name',
        helperText: '',
        errorText: displayError != null ? 'invalid full name' : null,
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (PersonalInformationBloc bloc) => bloc.state.username.displayError,
    );

    return TextField(
      key: const Key('personalInformationRegister_usernameInput_textField'),
      onChanged:
          (username) => context.read<PersonalInformationBloc>().add(
            UsernameChanged(username),
          ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'username',
        helperText: '',
        errorText: displayError != null ? 'invalid username' : null,
      ),
    );
  }
}

class _NationalityInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nationalityState = context.select(
      (PersonalInformationBloc bloc) => bloc.state.nationality,
    );
    final nationalities = context.select(
      (PersonalInformationBloc bloc) => bloc.state.nationalities,
    );
    final displayError = nationalityState.displayError;

    print(
      "🟡 Nationalities cargadas (${nationalities.length}): $nationalities",
    );

    return DropdownButtonFormField<String>(
      key: const Key('personalInformationRegister_nationalityInput_dropdown'),
      value:
          nationalityState.value.isNotEmpty &&
                  nationalities.contains(nationalityState.value)
              ? nationalityState.value
              : null,
      decoration: InputDecoration(
        labelText: 'nationality',
        errorText:
            displayError != null
                ? (displayError == NationalityValidationError.required
                    ? 'Nationality can\'t be empty'
                    : 'Selected nationality is not valid.')
                : null,
      ),
      items:
          nationalities
              .map(
                (key) => DropdownMenuItem<String>(
                  value: key,
                  child: Text('nationalities.$key'.tr()),
                ),
              )
              .toList(),
      onChanged: (selected) {
        if (selected != null) {
          context.read<PersonalInformationBloc>().add(
            NationalityChanged(selected),
          );
        }
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (PersonalInformationBloc bloc) => bloc.state.phoneNumber.displayError,
    );

    return TextField(
      key: const Key('personalInformationRegister_phoneNumberInput_textField'),
      onChanged:
          (phoneNumber) => context.read<PersonalInformationBloc>().add(
            PhoneNumberChanged(phoneNumber),
          ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'phone number',
        helperText: '',
        errorText: displayError != null ? 'invalid phone number' : null,
      ),
    );
  }
}

class _PersonalInformationRegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (PersonalInformationBloc bloc) => bloc.state.status.isInProgress,
    );

    if (isInProgress) return const CircularProgressIndicator();

    final isValid = context.select(
      (PersonalInformationBloc bloc) => bloc.state.isValid,
    );

    return ElevatedButton(
      key: const Key('personalInformationRegister_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.orangeAccent,
      ),
      onPressed:
          isValid
              ? () => context.read<PersonalInformationBloc>().add(
                PersonalInformationFormSubmitted(),
              )
              : null,
      child: const Text('CONTINUE'),
    );
  }
}
