import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/external/form_models/gender.dart';
import 'package:tecas_app/external/form_models/sexual_orientation.dart';
import 'package:tecas_app/presentation/features/register/personal_inclinations/state/personal_inclinations_bloc.dart';

class PersonalInclinationsForm extends StatelessWidget {
  const PersonalInclinationsForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<PersonalInclinationsBloc>().add(LoadGenders());
      context.read<PersonalInclinationsBloc>().add(LoadSexualOrientations());
    });

    return BlocListener<PersonalInclinationsBloc, PersonalInclinationsState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inclinaciones guardadas con éxito')),
          );

          context.read<AppBloc>().add(AppProfileRefreshRequested());
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'No se pudieron guardar las inclinaciones personales.',
                ),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 8),
            _GenderInput(),
            SizedBox(height: 8),
            _SexualOrientationInput(),
            SizedBox(height: 16),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _GenderInput extends StatelessWidget {
  const _GenderInput();

  @override
  Widget build(BuildContext context) {
    final genderState = context.select(
      (PersonalInclinationsBloc bloc) => bloc.state.gender,
    );
    final genderOptions = context.select(
      (PersonalInclinationsBloc bloc) => bloc.state.genderOptions,
    );
    final displayError = genderState.displayError;

    return DropdownButtonFormField<String>(
      key: const Key('personalInclinations_genderInput_dropdown'),
      value: genderState.value.isNotEmpty &&
              genderOptions.contains(genderState.value)
          ? genderState.value
          : null,
      decoration: InputDecoration(
        labelText: 'gender',
        errorText: displayError != null
            ? (displayError == GenderValidationError.required
                ? 'Gender can\'t be empty'
                : 'Selected gender is not valid.')
            : null,
      ),
      items: genderOptions
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text('registration.options.gender.$option'.tr()),
            ),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) {
          context.read<PersonalInclinationsBloc>().add(
                GenderChanged(selected),
              );
        }
      },
    );
  }
}

class _SexualOrientationInput extends StatelessWidget {
  const _SexualOrientationInput();

  @override
  Widget build(BuildContext context) {
    final orientationState = context.select(
      (PersonalInclinationsBloc bloc) => bloc.state.sexualOrientation,
    );
    final options = context.select(
      (PersonalInclinationsBloc bloc) => bloc.state.sexualOrientationOptions,
    );
    final displayError = orientationState.displayError;

    return DropdownButtonFormField<String>(
      key: const Key('personalInclinations_orientationInput_dropdown'),
      value: orientationState.value.isNotEmpty &&
              options.contains(orientationState.value)
          ? orientationState.value
          : null,
      decoration: InputDecoration(
        labelText: 'sexual orientation',
        errorText: displayError != null
            ? (displayError == SexualOrientationValidationError.required
                ? 'Orientation can\'t be empty'
                : 'Selected orientation is not valid.')
            : null,
      ),
      items: options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text('registration.options.sexual_orientation.$option'.tr()),
            ),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) {
          context.read<PersonalInclinationsBloc>().add(
                SexualOrientationChanged(selected),
              );
        }
      },
    );
  }
}


class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PersonalInclinationsBloc>();
    final isSubmitting = bloc.state.status.isInProgress;
    final isValid = bloc.state.isValid;

    if (isSubmitting) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      key: const Key('submitInclinationsButton'),
      onPressed:
          isValid
              ? () => context.read<PersonalInclinationsBloc>().add(
                PersonalInclinationsFormSubmitted(),
              )
              : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.orangeAccent,
      ),
      child: const Text('CONTINUAR'),
    );
  }
}
