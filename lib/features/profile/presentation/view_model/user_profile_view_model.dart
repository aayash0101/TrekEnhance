import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view_model/user_profile_event.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view_model/user_profile_state.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/domain/repository/user_repository.dart';

class UserProfileViewModel extends Bloc<UserProfileEvent, UserProfileState> {
  final IUserRepository userRepository;

  UserProfileViewModel(this.userRepository) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UploadProfilePicture>(_onUploadProfilePicture);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());

    final result = await userRepository.getCurrentUser();
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (user) => emit(UserProfileLoaded(user)),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());

    final result = await userRepository.updateUserProfile(
      username: event.username,
      bio: event.bio,
      location: event.location,
    );

    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (updatedUser) => emit(UserProfileLoaded(updatedUser)),
    );
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePicture event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfilePictureUploading());

    final result = await userRepository.uploadProfilePicture(File(event.filePath));
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (url) => emit(UserProfilePictureUploaded(url)),
    );
  }
}
