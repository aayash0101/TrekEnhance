import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/domain/repository/user_repository.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileViewModel extends Bloc<UserProfileEvent, UserProfileState> {
  final IUserRepository userRepository;

  UserProfileViewModel(this.userRepository) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UploadProfilePicture>(_onUploadProfilePicture);
  }

  /// Load current logged-in user profile
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

  /// Update user profile (username, bio, location, and optional profileImageUrl)
  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());

    final result = await userRepository.updateUserProfile(
      username: event.username,
      bio: event.bio,
      location: event.location,
      profileImageUrl: event.profileImageUrl,
    );

    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (updatedUser) => emit(UserProfileLoaded(updatedUser)),
    );
  }

  /// Upload profile picture and update user profile with new image URL
  Future<void> _onUploadProfilePicture(
    UploadProfilePicture event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfilePictureUploading());

    final uploadResult = await userRepository.uploadProfilePicture(File(event.filePath));

    uploadResult.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (imageUrl) async {
        // After upload, fetch current user data
        final currentUserResult = await userRepository.getCurrentUser();

        currentUserResult.fold(
          (failure) => emit(UserProfileError(failure.message)),
          (user) async {
            // Update user profile with new profileImageUrl
            final updateResult = await userRepository.updateUserProfile(
              username: user.username,
              bio: user.bio,
              location: user.location,
              profileImageUrl: imageUrl,
            );

            updateResult.fold(
              (failure) => emit(UserProfileError(failure.message)),
              (updatedUser) => emit(UserProfileLoaded(updatedUser)),
            );
          },
        );
      },
    );
  }

  /// Helper: pick image from gallery & upload
  Future<void> pickAndUploadProfilePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      add(UploadProfilePicture(picked.path));
    }
  }
}
