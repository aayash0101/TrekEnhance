import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/app/shared_pref/token_shared_prefs.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/login_view.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view/main_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SplashViewModel extends Cubit<void> {
  final TokenSharedPrefs tokenSharedPrefs;

  SplashViewModel({required this.tokenSharedPrefs}) : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final tokenResult = await tokenSharedPrefs.getToken();

    if (tokenResult.isRight()) {
      final token = tokenResult.getOrElse(() => null);

      if (token != null && token.isNotEmpty) {
        // Navigate to MainView if token exists
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainView(),
            ),
          );
        }
        return;
      }
    }

    // If no token, navigate to LoginView
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: serviceLocator<LoginViewModel>(),
            child: const LoginView(),
          ),
        ),
      );
    }
  }
}
