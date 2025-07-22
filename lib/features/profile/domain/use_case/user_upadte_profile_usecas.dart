import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';

class UpdateUserProfileUsecase {
  final IUserRepository userRepository;

  UpdateUserProfileUsecase({required this.userRepository});

  Future<Either<Failure, UserEntity>> call({
    required String username,
    String? bio,
    String? location,
  }) async {
    return await userRepository.updateUserProfile(
      username: username,
      bio: bio,
      location: location,
    );
  }
}
