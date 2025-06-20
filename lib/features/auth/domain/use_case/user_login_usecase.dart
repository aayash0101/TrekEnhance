import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/app/use_case/usecase.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';


class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  // Initial Constructor
  const LoginParams.initial() : username = '', password = '';
  @override
  List<Object?> get props => [username, password];
}

class UserLoginUsecase implements UsecaseWithParams<String, LoginParams> {
  final IUserRepository _studentRepository;

  UserLoginUsecase({required IUserRepository studentRepository})
    : _studentRepository = studentRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await _studentRepository.loginStudent(
      params.username,
      params.password,
    );
  }
}