import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String? bio;
  @HiveField(5)
  final String? location;

  UserHiveModel({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    this.bio,
    this.location,
  });

  const UserHiveModel.initial()
      : userId = '',
        username = '',
        email = '',
        password = '',
        bio = '',
        location = '';

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      password: entity.password,
      bio: entity.bio,
      location: entity.location,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      username: username,
      email: email,
      password: password,
      bio: bio,
      location: location,
    );
  }

  @override
  List<Object?> get props => [userId, username, email, password, bio, location];
}
