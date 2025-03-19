import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/domain/repositories_def/authentication_repository_def.dart';
import 'package:tecas_app/infrastructure/repositories_impl/authentication_repository_impl.dart';
import 'package:tecas_app/infrastructure/routes/app_router.dart';


class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        //We use the provider package to inject the AuthenticationRepositoryImpl instance into the AppBloc.
        Provider<AuthenticationRepository>(
          create: (_) => AuthenticationRepositoryImpl(),
        ),
        BlocProvider(
          // ".." cascade operator sends an event to the bloc  in order to perform  a user authentication check-up.
          //must use the previous provider to inject the AuthenticationRepositoryImpl instance into the AppBloc.
          create: (_) => AppBloc(authenticationRepository: context.read<AuthenticationRepository>())..add(const AppUserSubscriptionRequested()),
        )
      ],

      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'assets/langs',
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});


  @override
  Widget build(BuildContext context) {

    return  BlocListener<AppBloc,AppState>(listener: (context, state){
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
    )); 
  }
}
