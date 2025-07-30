abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {
  final String userId;
  LoadUserProfile(this.userId);
}

class UpdateUserProfile extends UserProfileEvent {
  final String username;
  final String bio;
  final String location;
  final String? profileImageUrl;  // Add this line as optional

  UpdateUserProfile({
    required this.username,
    required this.bio,
    required this.location,
    this.profileImageUrl,          // Add this line
  });
}

class UploadProfilePicture extends UserProfileEvent {
  final String filePath;
  UploadProfilePicture(this.filePath);
}
