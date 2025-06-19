import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/miscellaneous_repository_def.dart';
import 'package:tecas_app/domain/repositories_def/user_repository_def.dart';
import 'package:tecas_app/domain/services_def/authentication_service_def.dart';
import 'package:tecas_app/domain/services_def/miscellaneous_service_def.dart';
import 'package:tecas_app/domain/services_def/user_service_def.dart';
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
        Provider<MiscellaneousService>(
          create: (_) => MiscellaneousServiceImpl(
            firestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationServiceImpl(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(),
          ),
        ),
        Provider<UserService>(
          create: (_) => UserServiceImpl(
            firestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<MiscellaneousRepository>(
          create: (context) => MiscellaneousRepositoryImpl(
            miscellaneousService: context.read<MiscellaneousService>(),
          ),
        ),
        Provider<AuthenticationRepository>(
          create: (context) => AuthenticationRepositoryImpl(
            authService: context.read<AuthenticationService>(),
          ),
        ),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(
            authRepository: context.read<AuthenticationRepository>(),
            userService: context.read<UserService>(),
          ),
        ),
      ],
      child: Builder(builder: (context) {
        final appBloc = AppBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(const AppUserSubscriptionRequested());

        final router = AppRouter.create(appBloc);

        return BlocProvider.value(
          value: appBloc,
          child: EasyLocalization(
            supportedLocales: const [Locale('en'), Locale('es')],
            path: 'assets/langs',
            child: AppView(router: router),
          ),
        );
      }),
    );
  }
}


class AppView extends StatelessWidget {
  final GoRouter router;

  const AppView({required this.router, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
