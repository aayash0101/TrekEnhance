import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:flutter_application_trek_e/features/journal/data/model/journal_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  late Box<UserHiveModel> _userBox;
  late Box<JournalHiveModel> _savedJournalBox;
  late Box<JournalHiveModel> _favoriteJournalBox;

  /// Initialize Hive and open necessary boxes
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    if (!Hive.isAdapterRegistered(HiveTableConstant.userTableId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.journalTableId)) {
      Hive.registerAdapter(JournalHiveModelAdapter());
    }

    _userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    _savedJournalBox = await Hive.openBox<JournalHiveModel>(HiveTableConstant.savedJournalBox);
    _favoriteJournalBox = await Hive.openBox<JournalHiveModel>(HiveTableConstant.favoriteJournalBox);

    print('DEBUG: HiveService initialized with user, saved, and favorite journal boxes');
  }

  /// Open a Hive box of generic type [T], if not already open.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      print('DEBUG: Opening Hive box: $boxName');
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  /// Registers a user.
  Future<void> register(UserHiveModel user) async {
    if (user.userId == null) {
      throw Exception('User ID missing, cannot register user without backend ID');
    }
    await _userBox.put(user.userId!, user);
    print('DEBUG: Registered user in Hive with userId: ${user.userId}');
  }

  /// Login
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

  Future<UserHiveModel?> getCurrentUser() async {
    if (_userBox.isNotEmpty) {
      final user = _userBox.values.first;
      print('DEBUG: getCurrentUser found userId: ${user.userId}');
      return user;
    }
    print('DEBUG: getCurrentUser - box is empty');
    return null;
  }

  Future<UserHiveModel?> updateUserProfile({
    required String username,
    String? bio,
    String? location,
    String? profileImageUrl,
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
        profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
      );
      await _userBox.put(currentUser.userId!, updatedUser);
      print('DEBUG: Updated user profile for userId: ${currentUser.userId}');
      return updatedUser;
    }
    print('DEBUG: updateUserProfile - no current user');
    return null;
  }

  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
    print('DEBUG: Deleted user with userId: $id');
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    print('DEBUG: getAllUsers called, count: ${_userBox.values.length}');
    return _userBox.values.toList();
  }

  Future<void> clearAll() async {
    await _userBox.clear();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    print('DEBUG: Cleared all users and deleted box from disk');
  }

  Future<void> clearUserData() async {
    await _userBox.clear();
    print('DEBUG: Cleared all user data from user box');
  }

  Future<void> logout() async {
    await clearUserData();
    print('DEBUG: User logged out');
  }

  Future<void> close() async {
    await _userBox.close();
    await Hive.close();
    print('DEBUG: HiveService closed');
  }

  Future<String?> getUserId() async {
    final user = await getCurrentUser();
    print('DEBUG: getUserId returned: ${user?.userId}');
    return user?.userId;
  }

  // --------------------- NEW METHODS -----------------------

  Future<List<JournalHiveModel>> getSavedJournals() async {
    print('DEBUG: Fetching saved journals...');
    return _savedJournalBox.values.toList();
  }

  Future<List<JournalHiveModel>> getFavoriteJournals() async {
    print('DEBUG: Fetching favorite journals...');
    return _favoriteJournalBox.values.toList();
  }

  Future<void> saveJournal(JournalHiveModel journal) async {
    await _savedJournalBox.put(journal.id, journal);
    print('DEBUG: Saved journal with id: ${journal.id}');
  }

  Future<void> favoriteJournal(JournalHiveModel journal) async {
    await _favoriteJournalBox.put(journal.id, journal);
    print('DEBUG: Favorited journal with id: ${journal.id}');
  }

  Future<void> clearSavedJournals() async {
    await _savedJournalBox.clear();
    print('DEBUG: Cleared saved journals');
  }

  Future<void> clearFavoriteJournals() async {
    await _favoriteJournalBox.clear();
    print('DEBUG: Cleared favorite journals');
  }
}
