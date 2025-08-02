import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';

class UserLogoutUsecase {
  final IUserRepository _userRepository;

  UserLogoutUsecase(this._userRepository);

  Future<void> call() async {
    await _userRepository.logout();
  }
}
