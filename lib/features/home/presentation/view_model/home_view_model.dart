import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/login_view.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  final LoginViewModel loginViewModel;

  HomeViewModel({required this.loginViewModel})
      : super(HomeState.initial());

  /// Updates selected tab index
  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  /// Logs out user and navigates to login view after a short delay
  Future<void> logout(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: loginViewModel,
            child: const LoginView(),
          ),
        ),
      );
    }
  }
}
