import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/entities/app_user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(AppLogoutPressed());
            },
          ),
        ],
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state.user == AppUser.empty) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state.profile;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Text(
                  'Email: ${state.user.email ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 10),
                const Text(
                  'Profile Info:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                Text('Full Name: ${profile?.fullName ?? 'N/A'}'),
                Text('Username: ${profile?.username ?? 'N/A'}'),
                Text('Nationality: ${profile?.nationality ?? 'N/A'}'),
                Text('Phone Number: ${profile?.phoneNumber ?? 'N/A'}'),
                Text('Birthday: ${profile?.birthdayDate != null ? profile!.birthdayDate!.toLocal().toString().split(' ')[0] : 'N/A'}'),
                Text('Gender: ${profile?.gender ?? 'N/A'}'),
                Text('Sexual Orientation: ${profile?.sexualOrientation ?? 'N/A'}'),
                Text('Hobbies: ${profile?.hobbies.join(', ') ?? 'N/A'}'),
                Text('Musical Tastes: ${profile?.musicalTastes.join(', ') ?? 'N/A'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
