import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/core/common/snackbar/my_snackbar.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUsecase _userRegisterUsecase;
  final UploadImageUsecase _uploadImageUsecase;

  RegisterViewModel(
    this._userRegisterUsecase,
    this._uploadImageUsecase,
  ) : super(const RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<UploadImageEvent>(_onUploadImage);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUsecase(
      RegisterUserParams(
        email: event.email,
        username: event.username,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
        );
      },
    );
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _uploadImageUsecase(
      UploadImageParams(file: event.file),
    );

    result.fold(
      (_) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (imageName) {
        emit(state.copyWith(isLoading: false, isSuccess: true, imageName: imageName));
      },
    );
  }
}