import 'package:dio/dio.dart';
import 'package:flutter_application_trek_e/features/journal/data/data_source/local_datasource/journal_local_datasource.dart';
import 'package:flutter_application_trek_e/features/journal/data/data_source/remote_datasource/journal_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/journal/data/repository/journal_repository_impl.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/journal_usecase.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/core/network/api_service.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';

// Auth modules
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

// Home modules
import 'package:flutter_application_trek_e/features/home/data/data_source/local_datasource/home_local_datasource.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/remote_datasource/home_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/home/data/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';

// Splash
import 'package:flutter_application_trek_e/features/splash/presentation/view_model/splash_view_model.dart';

// Journal modules (new!)
import 'package:flutter_application_trek_e/features/journals/data/datasource/journal_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/journals/data/datasource/journal_local_datasource.dart';
import 'package:flutter_application_trek_e/features/journals/data/repository/journal_repository_impl.dart';
import 'package:flutter_application_trek_e/features/journals/domain/repository/i_journal_repository.dart';
import 'package:flutter_application_trek_e/features/journals/domain/usecases/create_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journals/domain/usecases/get_all_journals_usecase.dart';
import 'package:flutter_application_trek_e/features/journals/domain/usecases/get_journals_by_trek_and_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journals/domain/usecases/get_journals_by_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journals/domain/usecases/update_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journals/domain/usecases/delete_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journals/presentation/view_model/journal_view_model.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  _initApiModule();
  _initAuthModule();
  _initHomeModule();
  _initJournalModule();  // ✅ new journal module
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
      baseUrl: ApiEndpoints.serverAddress,
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
  serviceLocator.registerFactory<UserLocalDataSource>(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory<UserRemoteDataSource>(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory<UserRemoteRepository>(
    () => UserRemoteRepository(remoteDataSource: serviceLocator<UserRemoteDataSource>()),
  );

  serviceLocator.registerFactory<UserLocalRepository>(
    () => UserLocalRepository(userLocalDatasource: serviceLocator<UserLocalDataSource>()),
  );

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
  serviceLocator.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSource(),
  );

  serviceLocator.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasource(dio: serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<IHomeRepository>(
    () => HomeRepository(serviceLocator<HomeRemoteDatasource>()),
  );

  serviceLocator.registerFactory(
    () => HomeViewModel(serviceLocator<IHomeRepository>()),
  );
}

void _initJournalModule() {
  // Local datasource (Hive)
  serviceLocator.registerLazySingleton<JournalLocalDataSource>(
    () => JournalLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // Remote datasource
  serviceLocator.registerLazySingleton<JournalRemoteDataSource>(
    () => JournalRemoteDataSource(dio: serviceLocator<Dio>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<IJournalRepository>(
    () => JournalRepositoryImpl(
      remoteDataSource: serviceLocator<JournalRemoteDataSource>(),
      localDataSource: serviceLocator<JournalLocalDataSource>(),
    ),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => CreateJournalUsecase(serviceLocator<IJournalRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => GetAllJournalsUsecase(serviceLocator<IJournalRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => GetJournalsByTrekAndUserUsecase(serviceLocator<IJournalRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => GetJournalsByUserUsecase(serviceLocator<IJournalRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateJournalUsecase(serviceLocator<IJournalRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteJournalUsecase(serviceLocator<IJournalRepository>()),
  );

  // ViewModel
  serviceLocator.registerFactory(
    () => JournalViewModel(
      createJournalUsecase: serviceLocator<CreateJournalUsecase>(),
      getAllJournalsUsecase: serviceLocator<GetAllJournalsUsecase>(),
      getJournalsByTrekAndUserUsecase: serviceLocator<GetJournalsByTrekAndUserUsecase>(),
      getJournalsByUserUsecase: serviceLocator<GetJournalsByUserUsecase>(),
      updateJournalUsecase: serviceLocator<UpdateJournalUsecase>(),
      deleteJournalUsecase: serviceLocator<DeleteJournalUsecase>(),
    ),
  );
}

void _initSplashModule() {
  serviceLocator.registerFactory(() => SplashViewModel());
}
