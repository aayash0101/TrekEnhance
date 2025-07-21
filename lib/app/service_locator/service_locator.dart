import 'package:dio/dio.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/core/network/api_service.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:flutter_application_trek_e/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/remote_datasource/home_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/local_datasource/home_local_datasource.dart';
import 'package:flutter_application_trek_e/features/home/data/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_application_trek_e/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  _initApiModule();
  _initAuthModule();
  _initHomeModule();
  _initSplashModule();
}

Future<void> _initHiveService() async {
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

void _initApiModule() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.serverAddress, // base only, endpoints handle rest
      connectTimeout: ApiEndpoints.connectionTimeout,
      receiveTimeout: ApiEndpoints.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  serviceLocator.registerSingleton<Dio>(dio);

  serviceLocator.registerSingleton<ApiService>(ApiService(dio));
}

void _initAuthModule() {
  // Local data source (Hive)
  serviceLocator.registerFactory<UserLocalDataSource>(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // Remote data source
  serviceLocator.registerFactory<UserRemoteDataSource>(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerFactory<UserRemoteRepository>(
    () => UserRemoteRepository(remoteDataSource: serviceLocator<UserRemoteDataSource>()),
  );

  serviceLocator.registerFactory<UserLocalRepository>(
    () => UserLocalRepository(userLocalDatasource: serviceLocator<UserLocalDataSource>()),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => UserLoginUsecase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUsecase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => UploadImageUsecase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

  // ViewModels
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

void _initHomeModule() {
  // Local datasource (Hive) - optional, if you want local caching
  serviceLocator.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSource(),
  );

  // Remote datasource
  serviceLocator.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasource(dio: serviceLocator<Dio>()),
  );

  // Repository — use remote for live data (you can create hybrid if you want)
  serviceLocator.registerLazySingleton<IHomeRepository>(
    () => HomeRepository(serviceLocator<HomeRemoteDatasource>()),
  );

  // ViewModel
  serviceLocator.registerFactory(
    () => HomeViewModel(serviceLocator<IHomeRepository>()),
  );
}

void _initSplashModule() {
  serviceLocator.registerFactory(() => SplashViewModel());
}
