import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';



class HiveService {
  Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}student_management.db';

    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(UserHiveModelAdapter());

    // Add Dummy Data
    // await addBatchData();
    // await addCourseData();

    // clearAll();
  }

  // Add Dummy data for batch and course
  

  // Batch Queries
  

  // Auth Queries
  Future<void> register(UserHiveModel auth) async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.studentBox,
    );
    await box.put(auth.studentId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.studentBox,
    );
    await box.delete(id);
  }

  Future<List<UserHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.studentBox,
    );
    return box.values.toList();
  }

  // Login using username and password
  Future<UserHiveModel?> login(String username, String password) async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.studentBox,
    );
    var student = box.values.firstWhere(
      (element) => element.username == username && element.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );
    box.close();
    return student;
  }

  // Clear all data and delete database
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.studentBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}