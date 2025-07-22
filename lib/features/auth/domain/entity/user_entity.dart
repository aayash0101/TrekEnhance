import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String username;
  final String email;
  final String password; 
  final String? bio;
  final String? location;
  final String? profileImageUrl;


  const UserEntity({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    this.bio,
    this.location,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [userId, username, email, password, bio, location, profileImageUrl];
}
