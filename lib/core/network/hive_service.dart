import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  late Box<UserHiveModel> _userBox;

  /// Initialize Hive and open necessary boxes
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    if (!Hive.isAdapterRegistered(HiveTableConstant.userTableId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    _userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    print('DEBUG: HiveService initialized, user box opened with ${_userBox.length} users.');
  }

  /// Open a Hive box of generic type [T], if not already open.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      print('DEBUG: Opening Hive box: $boxName');
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  /// Registers a user. Expects the user to have a non-null backend userId.
  Future<void> register(UserHiveModel user) async {
    if (user.userId == null) {
      throw Exception('User ID missing, cannot register user without backend ID');
    }
    await _userBox.put(user.userId!, user);
    print('DEBUG: Registered user in Hive with userId: ${user.userId}');
  }

  /// Find a user locally by username and password.
  Future<UserHiveModel?> login(String username, String password) async {
    print('DEBUG: Attempting login with username: $username');
    try {
      final user = _userBox.values.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      print('DEBUG: Login successful, found userId: ${user.userId}');
      return user;
    } catch (_) {
      print('DEBUG: Login failed - user not found');
      return null;
    }
  }

  /// Returns the first user found in the box.
  Future<UserHiveModel?> getCurrentUser() async {
    if (_userBox.isNotEmpty) {
      final user = _userBox.values.first;
      print('DEBUG: getCurrentUser found userId: ${user.userId}');
      return user;
    }
    print('DEBUG: getCurrentUser - box is empty');
    return null;
  }

  /// Update user profile fields for current user.
  Future<UserHiveModel?> updateUserProfile({
    required String username,
    String? bio,
    String? location,
  }) async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final updatedUser = UserHiveModel(
        userId: currentUser.userId,
        username: username,
        email: currentUser.email,
        password: currentUser.password,
        bio: bio ?? currentUser.bio,
        location: location ?? currentUser.location,
        profileImageUrl: currentUser.profileImageUrl,
      );
      await _userBox.put(currentUser.userId!, updatedUser);
      print('DEBUG: Updated user profile for userId: ${currentUser.userId}');
      return updatedUser;
    }
    print('DEBUG: updateUserProfile - no current user');
    return null;
  }

  /// Deletes user by ID.
  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
    print('DEBUG: Deleted user with userId: $id');
  }

  /// Returns all users currently stored locally.
  Future<List<UserHiveModel>> getAllUsers() async {
    print('DEBUG: getAllUsers called, count: ${_userBox.values.length}');
    return _userBox.values.toList();
  }

  /// Clears all users and deletes the user box from disk.
  Future<void> clearAll() async {
    await _userBox.clear();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    print('DEBUG: Cleared all users and deleted box from disk');
  }

  /// Clears user data only, useful for logout (does NOT delete box)
  Future<void> clearUserData() async {
    await _userBox.clear();
    print('DEBUG: Cleared all user data from user box');
  }

  /// Closes the Hive box and Hive itself.
  Future<void> close() async {
    await _userBox.close();
    await Hive.close();
    print('DEBUG: HiveService closed');
  }

  /// Gets the userId of the current user.
  Future<String?> getUserId() async {
    final user = await getCurrentUser();
    print('DEBUG: getUserId returned: ${user?.userId}');
    return user?.userId;
  }
}
