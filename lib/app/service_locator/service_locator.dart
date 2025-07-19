import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_application_trek_e/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initAuthModule();
  await _initHomeModule();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  final hiveService = HiveService();
  await hiveService.init();  // Initialize before registering
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

Future<void> _initAuthModule() async {
  // 📡 Local data source
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // 🧩 Local repository (implements IUserRepository)
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDataSource>(),
    ),
  );

  // 📦 Use cases
  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UploadImageUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  // 🧠 ViewModels
  serviceLocator.registerFactory(
    () => RegisterViewModel(
      serviceLocator<UserRegisterUsecase>(),
      serviceLocator<UploadImageUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
