import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/app/use_case/usecase.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String fname;
  final String lname;
  final String phone;
  final String username;
  final String password;
  final String? image;

  const RegisterUserParams({
    required this.fname,
    required this.lname,
    required this.phone,
    required this.username,
    required this.password,
    this.image,
  });

  //intial constructor
  const RegisterUserParams.initial({
    required this.fname,
    required this.lname,
    required this.phone,
    required this.username,
    required this.password,
    this.image,
  });

  @override
  List<Object?> get props => [
    fname,
    lname,
    phone,
    username,
    password,
  ];
}

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _studentRepository;

  UserRegisterUsecase({required IUserRepository studentRepository})
    : _studentRepository = studentRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final studentEntity = UserEntity(
      fName: params.fname,
      lName: params.lname,
      phone: params.phone,
      username: params.username,
      password: params.password,
      image: params.image,
    );
    return _studentRepository.registerStudent(studentEntity);
  }
}