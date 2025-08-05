import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/app/shared_pref/token_shared_prefs.dart';
import 'package:flutter_application_trek_e/core/common/snackbar/my_snackbar.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/register_view.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view/main_view.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;
  final TokenSharedPrefs _tokenSharedPrefs;

  LoginViewModel(this._userLoginUsecase, this._tokenSharedPrefs)
      : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => serviceLocator<RegisterViewModel>(),
            child: const RegisterView(),
          ),
        ),
      );
    }
  }

  Future<void> _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginParams(username: event.username, password: event.password),
    );

    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) async {
        final saveResult = await _tokenSharedPrefs.saveToken(token);
        saveResult.fold(
          (saveFailure) {
            showMySnackBar(
              context: event.context,
              message: 'Failed to save token: ${saveFailure.message}',
              color: Colors.red,
            );
          },
          (_) {
            emit(state.copyWith(isLoading: false, isSuccess: true));
            // ✅ Navigate directly to MainView with bottom navigation
            if (event.context.mounted) {
              Navigator.of(event.context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainView()),
                (route) => false,
              );
            }
          },
        );
      },
    );
  }
}
