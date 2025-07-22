import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();
  
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserEntity user;

  const UserProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserProfilePictureUploading extends UserProfileState {}

class UserProfilePictureUploaded extends UserProfileState {
  final String urlOrFilename;

  const UserProfilePictureUploaded(this.urlOrFilename);

  @override
  List<Object?> get props => [urlOrFilename];
}
