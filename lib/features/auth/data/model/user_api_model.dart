import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String username;
  final String email;
  final String? password;
  final String? bio;
  final String? location;
  final String? profileImageUrl;  // <-- new field

  const UserApiModel({
    this.userId,
    required this.username,
    required this.email,
    this.password,
    this.bio,
    this.location,
    this.profileImageUrl,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      username: username,
      email: email,
      password: password ?? '',
      bio: bio,
      location: location,
      profileImageUrl: profileImageUrl,  // <-- map here
    );
  }

  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      password: entity.password,
      bio: entity.bio,
      location: entity.location,
      profileImageUrl: entity.profileImageUrl, // <-- map here
    );
  }

  @override
  List<Object?> get props => [userId, username, email, password, bio, location, profileImageUrl];
}
