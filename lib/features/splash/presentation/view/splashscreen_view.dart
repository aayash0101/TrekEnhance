import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/login_view.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view/main_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    // Wait at least 2 seconds so splash shows nicely
    await Future.delayed(const Duration(seconds: 2));

    try {
      final getCurrentUserUsecase = serviceLocator<UserGetCurrentUsecase>();
      final result = await getCurrentUserUsecase();

      if (!mounted) return;

      result.fold(
        (failure) {
          debugPrint('⚠️ Failed to get current user: ${failure.message}');
          // Go to LoginView
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => serviceLocator<LoginViewModel>(),
                child: const LoginView(),
              ),
            ),
          );
        },
        (user) {
          debugPrint('✅ Current user found: ${user.username}');
          // Go to MainView
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainView()),
          );
        },
      );
    } catch (e) {
      debugPrint('⚠️ Unexpected error in splash: $e');
      if (!mounted) return;
      // Even on unexpected error, go to LoginView
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => serviceLocator<LoginViewModel>(),
            child: const LoginView(),
          ),
        ),
      );
    } finally {
      // Restore system UI overlays after navigation
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pink],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('assets/images/ab.png'),
          ),
        ),
      ),
    );
  }
}
