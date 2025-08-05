import 'package:dio/dio.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_logout_usecase.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/local_datasource/home_local_datasource.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/add_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/add_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journal_with_status_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/is_journal_favorite_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/is_journal_saved_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/remove_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/remove_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/toggle_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/toggle_saved_journal_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core and shared
import 'package:flutter_application_trek_e/core/network/api_service.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/app/shared_pref/token_shared_prefs.dart';

// Auth modules
import 'package:flutter_application_trek_e/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:flutter_application_trek_e/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Home modules
import 'package:flutter_application_trek_e/features/home/data/data_source/home_datasource.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/remote_datasource/home_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/home/data/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/domain/use_case/get_all_trek_review__usecase.dart';
import 'package:flutter_application_trek_e/features/home/domain/use_case/get_all_treks_usecase.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_view_model.dart';

// Journal modules
import 'package:flutter_application_trek_e/features/journal/data/data_source/local_datasource/journal_local_datasource.dart';
import 'package:flutter_application_trek_e/features/journal/data/data_source/remote_datasource/journal_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/journal/data/repository/journal_repository_impl.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/create_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/delete_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_all_journals_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journals_by_trek_and_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journals_by_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/update_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view_model/journal_view_model.dart';

// Splash module
import 'package:flutter_application_trek_e/features/splash/presentation/view_model/splash_view_model.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  _initApiModule();
  await _initSharedPrefsModule();
  _initAuthModule();
  _initHomeModule();
  _initJournalModule();
  _initSplashModule();
}

Future<void> _initHiveService() async {
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

Future<void> _initSharedPrefsModule() async {
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(prefs);
  serviceLocator.registerSingleton(TokenSharedPrefs(sharedPreferences: prefs));
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
  // Data sources
  serviceLocator.registerFactory<UserLocalDataSource>(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory<UserRemoteDataSource>(
    () => UserRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      hiveService: serviceLocator<HiveService>(),
    ),
  );

  // Repositories
  serviceLocator.registerLazySingleton<IUserRepository>(
    () => UserRemoteRepository(
      remoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => UserLoginUsecase(userRepository: serviceLocator<IUserRepository>()),
  );
  serviceLocator.registerFactory(
    () =>
        UserRegisterUsecase(userRepository: serviceLocator<IUserRepository>()),
  );
  serviceLocator.registerFactory(
    () => UploadImageUsecase(userRepository: serviceLocator<IUserRepository>()),
  );
  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserLogoutUsecase(serviceLocator<IUserRepository>()),
  );

  // ViewModels
  serviceLocator.registerFactory(
    () => RegisterViewModel(
      serviceLocator<UserRegisterUsecase>(),
      serviceLocator<UploadImageUsecase>(),
    ),
  );
  serviceLocator.registerFactory(
    () => LoginViewModel(
      serviceLocator<UserLoginUsecase>(),
      serviceLocator<TokenSharedPrefs>(),
    ),
  );
}

void _initHomeModule() {
  // Data sources
  serviceLocator.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSource(),
  );

  serviceLocator.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasource(dio: serviceLocator<Dio>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<IHomeRepository>(
    () => HomeRepository(serviceLocator<HomeRemoteDatasource>()),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => GetAllReviewsFromAllTreksUsecase(serviceLocator<IHomeRepository>()),
  );

  serviceLocator.registerFactory(
    () => GetAllTreksUsecase(serviceLocator<IHomeRepository>()),
  );

  // ViewModels
  serviceLocator.registerFactory<HomeViewModel>(
    () => HomeViewModel(serviceLocator<IHomeRepository>()),
  );

  serviceLocator.registerFactory<ReviewViewModel>(
    () => ReviewViewModel(
      getAllTreksUsecase: serviceLocator<GetAllTreksUsecase>(),
    ),
  );
}

void _initJournalModule() {
  serviceLocator.registerLazySingleton(() => JournalLocalDataSource(hiveService: serviceLocator()));
  serviceLocator.registerLazySingleton(() => JournalRemoteDataSource(dio: serviceLocator()));
  serviceLocator.registerLazySingleton<IJournalRepository>(
    () => JournalRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );

  // Basic CRUD
  serviceLocator.registerFactory(() => CreateJournalUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => GetAllJournalsUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => GetJournalsByTrekAndUserUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => GetJournalsByUserUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => UpdateJournalUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => DeleteJournalUsecase(serviceLocator()));

  // Save / Unsave
  serviceLocator.registerFactory(() => SaveJournalUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => UnsaveJournalUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => IsJournalSavedUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => GetSavedJournalsUseCase(serviceLocator()));

  // Favorite / Unfavorite
  serviceLocator.registerFactory(() => FavoriteJournalUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => UnfavoriteJournalUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => IsJournalFavoritedUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => GetFavoriteJournalsUseCase(serviceLocator()));

  // Toggle
  serviceLocator.registerFactory(() => ToggleSaveJournalUseCase(
    saveJournalUseCase: serviceLocator(),
    unsaveJournalUseCase: serviceLocator(),
    isJournalSavedUseCase: serviceLocator(),
  ));
  serviceLocator.registerFactory(() => ToggleFavoriteJournalUseCase(
    favoriteJournalUseCase: serviceLocator(),
    unfavoriteJournalUseCase: serviceLocator(),
    isJournalFavoritedUseCase: serviceLocator(),
  ));

  // Additional
  serviceLocator.registerFactory(() => GetJournalsWithStatusUseCase(serviceLocator()));

  // ViewModel
  serviceLocator.registerFactory(() => JournalViewModel(
    createJournalUsecase: serviceLocator(),
    getAllJournalsUsecase: serviceLocator(),
    getJournalsByTrekAndUserUsecase: serviceLocator(),
    getJournalsByUserUsecase: serviceLocator(),
    updateJournalUsecase: serviceLocator(),
    deleteJournalUsecase: serviceLocator(),
    getSavedJournalsUseCase: serviceLocator(),
    saveJournalUseCase: serviceLocator(),
    unsaveJournalUseCase: serviceLocator(),
    isJournalSavedUseCase: serviceLocator(),
    getFavoriteJournalsUseCase: serviceLocator(),
    favoriteJournalUseCase: serviceLocator(),
    unfavoriteJournalUseCase: serviceLocator(),
    isJournalFavoritedUseCase: serviceLocator(),
    toggleSaveJournalUseCase: serviceLocator(),
    toggleFavoriteJournalUseCase: serviceLocator(),
    getJournalsWithStatusUseCase: serviceLocator(),
  ));
}

void _initSplashModule() {
  serviceLocator.registerFactory(() => SplashViewModel(tokenSharedPrefs: serviceLocator()));
}
