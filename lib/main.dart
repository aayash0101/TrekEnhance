import 'package:flutter/cupertino.dart';
import 'package:flutter_application_trek_e/app.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // init Hive service
  await HiveService().init();
  // Delete database
  // await HiveService().clearAll();
  runApp(App());
}