import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? studentId;
  @HiveField(1)
  final String fName;
  @HiveField(2)
  final String lName;
  @HiveField(3)
  final String? image;
  @HiveField(4)
  final String phone;
  @HiveField(7)
  final String username;
  @HiveField(8)
  final String password;

  UserHiveModel({
    String? studentId,
    required this.fName,
    required this.lName,
    this.image,
    required this.phone,
    required this.username,
    required this.password,
  }) : studentId = studentId ?? const Uuid().v4();

  // Initial Constructor
  const UserHiveModel.initial()
    : studentId = '',
      fName = '',
      lName = '',
      image = '',
      phone = '',
      username = '',
      password = '';

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      studentId: entity.userId,
      fName: entity.fName,
      lName: entity.lName,
      image: entity.image,
      phone: entity.phone,
      username: entity.username,
      password: entity.password,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: studentId,
      fName: fName,
      lName: lName,
      image: image,
      phone: phone,
      username: username,
      password: password,
    );
  }

  @override
  List<Object?> get props => [
    studentId,
    fName,
    lName,
    image,
    username,
    password,
  ];
}
