import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  late Box<UserHiveModel> _userBox;

  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/user_management.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());

    _userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
  }

  // Register user
  Future<void> register(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
  }

  // Delete user by id
  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  // Get all users
  Future<List<UserHiveModel>> getAllUsers() async {
    return _userBox.values.toList();
  }

  // Login by username and password
  Future<UserHiveModel?> login(String username, String password) async {
    try {
      final user = _userBox.values.firstWhere(
        (element) => element.username == username && element.password == password,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  // Get the current logged-in user (simple example: first user in the box)
  Future<UserHiveModel?> getCurrentUser() async {
    if (_userBox.isNotEmpty) {
      return _userBox.values.first;
    }
    return null;
  }

  // Clear all data and delete database
  Future<void> clearAll() async {
    await _userBox.clear();
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Close Hive
  Future<void> close() async {
    await _userBox.close();
    await Hive.close();
  }
}
