abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {
  final String userId;
  LoadUserProfile(this.userId);
}

class UpdateUserProfile extends UserProfileEvent {
  final String username;
  final String bio;
  final String location;

  UpdateUserProfile({
    required this.username,
    required this.bio,
    required this.location,
  });
}

class UploadProfilePicture extends UserProfileEvent {
  final String filePath;
  UploadProfilePicture(this.filePath);
}
