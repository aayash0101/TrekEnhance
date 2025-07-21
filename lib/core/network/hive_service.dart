import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class HiveService {
  late Box<UserHiveModel> _userBox;
  final _uuid = Uuid();

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    if (!Hive.isAdapterRegistered(HiveTableConstant.userTableId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    _userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
  }

  // Register user - generates key if userId is null
  Future<void> register(UserHiveModel user) async {
    final key = user.userId ?? _uuid.v4();

    final userToSave = (user.userId == key)
        ? user
        : UserHiveModel(
            userId: key,
            username: user.username,
            email: user.email,
            password: user.password,
            bio: user.bio,
            location: user.location,
          );

    await _userBox.put(key, userToSave);
  }

  Future<UserHiveModel?> login(String username, String password) async {
    try {
      return _userBox.values.firstWhere(
        (u) => u.username == username && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<UserHiveModel?> getCurrentUser() async {
    if (_userBox.isNotEmpty) {
      return _userBox.values.first;
    }
    return null;
  }

  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    return _userBox.values.toList();
  }

  Future<void> clearAll() async {
    await _userBox.clear();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await _userBox.close();
    await Hive.close();
  }
}
