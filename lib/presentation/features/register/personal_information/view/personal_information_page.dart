import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/presentation/features/register/personal_information/state/personal_information_bloc.dart';
import 'package:tecas_app/presentation/features/register/personal_information/view/personal_information_form.dart';


class PersonalInformationRegisterPage extends StatelessWidget {
  const PersonalInformationRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<PersonalInformationBloc>(
          create: (_) => PersonalInformationBloc(context.read<UserRepository>(), context.read<MiscellaneousRepository>()),
          child: const PersonalInformationForm(),
        ),
      ),
    );
  }
}