import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
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
  final String? profileImageUrl;

  const UserApiModel({
    this.userId,
    required this.username,
    required this.email,
    this.password,
    this.bio,
    this.location,
    this.profileImageUrl,
  });

  /// From JSON (API) to model
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  /// To JSON (model to API)
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      username: username,
      email: email,
      password: password ?? '',
      bio: bio,
      location: location,
      profileImageUrl: profileImageUrl,
    );
  }

  /// Convert from domain entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      password: entity.password,
      bio: entity.bio,
      location: entity.location,
      profileImageUrl: entity.profileImageUrl,
    );
  }

  /// ✅ Convert to Hive model (for local cache)
  UserHiveModel toHiveModel() {
    return UserHiveModel(
      userId: userId,
      username: username,
      email: email,
      password: password ?? '',
      bio: bio,
      location: location,
    );
  }

  /// (Optional) create from Hive model if needed
  factory UserApiModel.fromHiveModel(UserHiveModel hiveModel) {
    return UserApiModel(
      userId: hiveModel.userId,
      username: hiveModel.username,
      email: hiveModel.email,
      password: hiveModel.password,
      bio: hiveModel.bio,
      location: hiveModel.location,
      profileImageUrl: null, // Hive doesn’t store this
    );
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        email,
        password,
        bio,
        location,
        profileImageUrl,
      ];
}
