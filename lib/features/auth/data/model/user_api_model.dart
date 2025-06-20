import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fname;
  final String lname;
  final String? image;
  final String phone;
  final String username;
  final String? password;

  const UserApiModel({
    this.userId,
    required this.fname,
    required this.lname,
    required this.image,
    required this.phone,
    required this.username,
    required this.password,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fName: fname,
      lName: lname,
      image: image,
      phone: phone,
      username: username,
      password: password ?? '',
    );
  }

  // From Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    final student = UserApiModel(
      fname: entity.fName,
      lname: entity.lName,
      image: entity.image,
      phone: entity.phone,
      username: entity.username,
      password: entity.password,
    );
    return student;
  }

  @override
  List<Object?> get props => [
    userId,
    fname,
    lname,
    image,
    phone,
    username,
    password,
  ];
}
