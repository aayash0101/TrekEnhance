import 'dart:io';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_saved_journal_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/domain/repository/user_repository.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileViewModel extends Bloc<UserProfileEvent, UserProfileState> {
  final IUserRepository userRepository;
  final GetSavedJournalsUseCase getSavedJournalsUseCase;
  final GetFavoriteJournalsUseCase getFavoriteJournalsUseCase;

  UserProfileViewModel(
    this.userRepository,
    this.getSavedJournalsUseCase,
    this.getFavoriteJournalsUseCase,
  ) : super(UserProfileInitial()) {
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

    final userResult = await userRepository.getCurrentUser();

    if (userResult.isLeft()) {
      // Extract the failure and emit error
      final failure = userResult.fold(
        (l) => l,
        (r) => throw UnimplementedError(),
      );
      emit(UserProfileError(failure.message));
      return;
    }

    final user = userResult.getOrElse(
      () => throw Exception("Unexpected null user"),
    );
    final savedResult = await getSavedJournalsUseCase(user.userId!);
    final favoriteResult = await getFavoriteJournalsUseCase(user.userId!);

    final savedJournals = savedResult.getOrElse(() => []);
    final favoriteJournals = favoriteResult.getOrElse(() => []);

    emit(UserProfileLoaded(user, savedJournals, favoriteJournals));
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
      (updatedUser) => emit(UserProfileLoaded(updatedUser, [], [])),
    );
  }

  /// Upload profile picture and update user profile with new image URL
  Future<void> _onUploadProfilePicture(
    UploadProfilePicture event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfilePictureUploading());

    final uploadResult = await userRepository.uploadProfilePicture(
      File(event.filePath),
    );

    uploadResult.fold((failure) => emit(UserProfileError(failure.message)), (
      imageUrl,
    ) async {
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
            (updatedUser) => emit(UserProfileLoaded(updatedUser, [], [])),
          );
        },
      );
    });
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
