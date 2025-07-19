import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/core/common/snackbar/my_snackbar.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/register_view.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/home_view.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
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
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: serviceLocator<RegisterViewModel>()),
            ],
            child: RegisterView(),
          ),
        ),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: serviceLocator<HomeViewModel>(),
            child: const HomeView(),
          ),
        ),
      );
    }
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUsecase(
      LoginParams(username: event.username, password: event.password),
    );

    result.fold(
      (failure) {
        // Handle failure case
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) {
        // Handle success case
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(NavigateToHomeViewEvent(context: event.context));
      },
    );
  }
}