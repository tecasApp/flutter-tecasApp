import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/domain/services_def/authentication_service_def.dart';
import 'package:tecas_app/domain/services_def/miscellaneous_service_def.dart';
import 'package:tecas_app/domain/services_def/user_service.dart';
import 'package:tecas_app/infrastructure/repositories_impl/authentication_repository_impl.dart';
import 'package:tecas_app/infrastructure/repositories_impl/miscellaneous_repository_impl.dart';
import 'package:tecas_app/infrastructure/repositories_impl/user_repository_impl.dart';
import 'package:tecas_app/infrastructure/routes/app_router.dart';
import 'package:tecas_app/infrastructure/services_impl/authentication_service_impl.dart';
import 'package:tecas_app/infrastructure/services_impl/miscellaneous_service_impl.dart';
import 'package:tecas_app/infrastructure/services_impl/user_service_impl.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide MiscellaneousService
        Provider<MiscellaneousService>(
          create:
              (_) => MiscellaneousServiceImpl(
                firestore: FirebaseFirestore.instance,
              ),
        ),

        // Provide AuthenticationService
        Provider<AuthenticationService>(
          create:
              (_) => AuthenticationServiceImpl(
                firebaseAuth: FirebaseAuth.instance,
                googleSignIn: GoogleSignIn(),
              ),
        ),

        // Provide UserService
        Provider<UserService>(
          create: (_) => UserServiceImpl(firestore: FirebaseFirestore.instance),
        ),

        // Provide MiscellaneousRepository
        Provider<MiscellaneousRepository>(
          create:
              (context) => MiscellaneousRepositoryImpl(
                miscellaneousService: context.read<MiscellaneousService>(),
              ),
        ),

        // Provide AuthenticationRepository
        Provider<AuthenticationRepository>(
          create:
              (context) => AuthenticationRepositoryImpl(
                authService: context.read<AuthenticationService>(),
              ),
        ),

        // Provide UserRepository
        Provider<UserRepository>(
          create:
              (context) => UserRepositoryImpl(
                authRepository: context.read<AuthenticationRepository>(),
                userService: context.read<UserService>(),
              ),
        ),

        // Provide AppBloc
        BlocProvider(
          create:
              (context) => AppBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              )..add(const AppUserSubscriptionRequested()),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'assets/langs',
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        AppRouter.router.refresh();
      },
      child: MaterialApp.router(
        routeInformationParser: AppRouter.router.routeInformationParser,
        routerDelegate: AppRouter.router.routerDelegate,
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
