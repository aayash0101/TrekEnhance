import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await serviceLocator<HiveService>().init();
  runApp(App());
}
