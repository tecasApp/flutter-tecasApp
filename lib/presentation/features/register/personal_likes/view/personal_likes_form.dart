import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/external/form_models/hobbies.dart';
import 'package:tecas_app/external/form_models/musical_tastes.dart';
import 'package:tecas_app/presentation/features/register/personal_likes/state/personal_likes_bloc.dart';

class PersonalLikesForm extends StatelessWidget {
  const PersonalLikesForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<PersonalLikesBloc>().add(LoadMusicalTastes());
      context.read<PersonalLikesBloc>().add(LoadHobbies());
    });

    return BlocListener<PersonalLikesBloc, PersonalLikesState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preferencias guardadas con éxito')),
          );
          context.read<AppBloc>().add(AppProfileRefreshRequested());
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'No se pudieron guardar las preferencias personales.',
                ),
              ),
            );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            SizedBox(height: 12),
            _MusicalTastesInput(),
            SizedBox(height: 12),
            _HobbiesInput(),
            SizedBox(height: 20),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}


class _MusicalTastesInput extends StatelessWidget {
  const _MusicalTastesInput();

  @override
  Widget build(BuildContext context) {
    final selected = context.select(
      (PersonalLikesBloc bloc) => bloc.state.musicalTastes.value,
    );
    final options = context.select(
      (PersonalLikesBloc bloc) => bloc.state.musicalTastesOptions,
    );
    final error = context.select(
      (PersonalLikesBloc bloc) => bloc.state.musicalTastes.displayError,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('musical_tastes'),
        ...options.map(
          (option) => CheckboxListTile(
            title: Text('registration.options.musical_tastes.$option'.tr()),
            value: selected.contains(option),
            onChanged: (checked) {
              final newList = List<String>.from(selected);
              if (checked == true) {
                newList.add(option);
              } else {
                newList.remove(option);
              }
              context.read<PersonalLikesBloc>().add(MusicalTastesChanged(newList));
            },
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              error == MusicalTastesValidationError.required
                  ? 'Debes seleccionar al menos un gusto musical'
                  : 'Una o más opciones no son válidas.',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _HobbiesInput extends StatelessWidget {
  const _HobbiesInput();

  @override
  Widget build(BuildContext context) {
    final selected = context.select(
      (PersonalLikesBloc bloc) => bloc.state.hobbies.value,
    );
    final options = context.select(
      (PersonalLikesBloc bloc) => bloc.state.hobbiesOptions,
    );
    final error = context.select(
      (PersonalLikesBloc bloc) => bloc.state.hobbies.displayError,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('hobbies'),
        ...options.map(
          (option) => CheckboxListTile(
            title: Text('registration.options.hobbies.$option'.tr()),
            value: selected.contains(option),
            onChanged: (checked) {
              final newList = List<String>.from(selected);
              if (checked == true) {
                newList.add(option);
              } else {
                newList.remove(option);
              }
              context.read<PersonalLikesBloc>().add(HobbiesChanged(newList));
            },
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              error == HobbiesValidationError.required
                  ? 'Debes seleccionar al menos un hobby'
                  : 'Uno o más hobbies seleccionados no son válidos.',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}


class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PersonalLikesBloc>();
    final isSubmitting = bloc.state.status.isInProgress;
    final isValid = bloc.state.isValid;

    if (isSubmitting) return const CircularProgressIndicator();

    return ElevatedButton(
      key: const Key('submitPreferencesButton'),
      onPressed: isValid
          ? () => context.read<PersonalLikesBloc>().add(PersonalLikesFormSubmitted())
          : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.orangeAccent,
      ),
      child: const Text('CONTINUAR'),
    );
  }
}
