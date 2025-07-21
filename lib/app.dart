import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/app/theme/app_theme.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/home_view.dart';
import 'package:flutter_application_trek_e/features/splash/presentation/view/splashscreen_view.dart';
import 'package:flutter_application_trek_e/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashViewModel>.value(
          value: serviceLocator<SplashViewModel>(),
        ),
        BlocProvider<LoginViewModel>.value(
          value: serviceLocator<LoginViewModel>(),
        ),
        // If you need: add RegisterViewModel, HomeViewModel here too
      ],
      child: MaterialApp(
        title: 'trekEnhance',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getApplicationTheme(isDarkMode: false),
        home: const Splashscereen(),
      ),
    );
  }
}
