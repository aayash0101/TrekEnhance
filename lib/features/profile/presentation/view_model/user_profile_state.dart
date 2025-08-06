import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();
  
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserEntity user;
  final List<JournalEntity> savedJournals;
  final List<JournalEntity> favoriteJournals;
  
  const UserProfileLoaded(this.user, this.savedJournals, this.favoriteJournals);

  @override
  List<Object?> get props => [user, savedJournals, favoriteJournals];
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
