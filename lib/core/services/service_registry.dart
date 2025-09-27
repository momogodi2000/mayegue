import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

// Core services
import '../database/database_helper.dart';
import '../network/network_info.dart';
import '../sync/sync_manager.dart';
import '../sync/conflict_resolution_service.dart';
import 'ai_service.dart';
import 'notification_service.dart';
import 'media_service.dart';
import 'storage_service.dart';
import 'permission_service.dart';
import 'content_moderation_service.dart';
import 'payout_service.dart';

// Feature services
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/presentation/viewmodels/auth_viewmodel.dart';

import '../../features/dictionary/data/datasources/lexicon_remote_datasource.dart';
import '../../features/dictionary/data/datasources/lexicon_local_datasource.dart';
import '../../features/dictionary/data/repositories/lexicon_repository_impl.dart';
import '../../features/dictionary/domain/repositories/lexicon_repository.dart';
import '../../features/dictionary/presentation/viewmodels/teacher_review_viewmodel.dart';

// Dashboard ViewModels
import '../../features/dashboard/presentation/viewmodels/student_dashboard_viewmodel.dart';
import '../../features/dashboard/presentation/viewmodels/teacher_dashboard_viewmodel.dart';
import '../../features/dashboard/presentation/viewmodels/admin_dashboard_viewmodel.dart';

/// Centralized service registry to manage dependencies and avoid duplication
class ServiceRegistry {
  static final GetIt _getIt = GetIt.instance;

  /// Initialize all services and dependencies
  static Future<void> initialize() async {
    // Register core utilities first
    _getIt.registerLazySingleton(() => Connectivity());
    _getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(_getIt()));

    // Register database
    final database = await DatabaseHelper.database;
    _getIt.registerSingleton<Database>(database);

    // Register core services
    _registerCoreServices();

    // Register feature-specific services
    await _registerAuthenticationServices();
    await _registerDictionaryServices();
    await _registerDashboardServices();

    // Register sync services last
    _registerSyncServices();
  }

  /// Register core application services
  static void _registerCoreServices() {
    // AI Service
    _getIt.registerLazySingleton<AIService>(
      () => AIServiceImpl(
        // Firebase or other AI service configuration
      ),
    );

    // Notification Service
    _getIt.registerLazySingleton<NotificationService>(
      () => NotificationServiceImpl(),
    );

    // Media Service
    _getIt.registerLazySingleton<MediaService>(
      () => MediaServiceImpl(),
    );

    // Storage Service
    _getIt.registerLazySingleton<StorageService>(
      () => StorageServiceImpl(),
    );

    // Permission Service
    _getIt.registerLazySingleton<PermissionService>(
      () => PermissionServiceImpl(),
    );

    // Content Moderation Service
    _getIt.registerLazySingleton<ContentModerationService>(
      () => ContentModerationServiceImpl(),
    );

    // Payout Service
    _getIt.registerLazySingleton<PayoutService>(
      () => PayoutServiceImpl(),
    );
  }

  /// Register authentication-related services
  static Future<void> _registerAuthenticationServices() async {
    // Data sources
    _getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        networkInfo: _getIt<NetworkInfo>(),
      ),
    );

    _getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        database: _getIt<Database>(),
      ),
    );

    // Repository
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: _getIt<AuthRemoteDataSource>(),
        localDataSource: _getIt<AuthLocalDataSource>(),
        networkInfo: _getIt<NetworkInfo>(),
      ),
    );

    // ViewModels
    _getIt.registerLazySingleton<AuthViewModel>(
      () => AuthViewModel(
        authRepository: _getIt<AuthRepository>(),
      ),
    );
  }

  /// Register dictionary/lexicon services
  static Future<void> _registerDictionaryServices() async {
    // Data sources
    _getIt.registerLazySingleton<LexiconRemoteDataSource>(
      () => LexiconRemoteDataSourceImpl(
        networkInfo: _getIt<NetworkInfo>(),
      ),
    );

    _getIt.registerLazySingleton<LexiconLocalDataSource>(
      () => LexiconLocalDataSourceImpl(
        database: _getIt<Database>(),
      ),
    );

    // Repository
    _getIt.registerLazySingleton<LexiconRepository>(
      () => LexiconRepositoryImpl(
        remoteDataSource: _getIt<LexiconRemoteDataSource>(),
        localDataSource: _getIt<LexiconLocalDataSource>(),
        networkInfo: _getIt<NetworkInfo>(),
      ),
    );

    // ViewModels
    _getIt.registerFactory<TeacherReviewViewModel>(
      () => TeacherReviewViewModel(
        lexiconRepository: _getIt<LexiconRepository>(),
        aiEnrichVocabularyUsecase: _getIt(), // Will be registered later
        getCurrentUserUsecase: _getIt(), // Will be registered later
      ),
    );
  }

  /// Register dashboard services
  static Future<void> _registerDashboardServices() async {
    // Student Dashboard
    _getIt.registerFactory<StudentDashboardViewModel>(
      () => StudentDashboardViewModel(
        authViewModel: _getIt<AuthViewModel>(),
        lexiconRepository: _getIt<LexiconRepository>(),
      ),
    );

    // Teacher Dashboard
    _getIt.registerFactory<TeacherDashboardViewModel>(
      () => TeacherDashboardViewModel(
        authViewModel: _getIt<AuthViewModel>(),
        lexiconRepository: _getIt<LexiconRepository>(),
      ),
    );

    // Admin Dashboard
    _getIt.registerFactory<AdminDashboardViewModel>(
      () => AdminDashboardViewModel(
        authViewModel: _getIt<AuthViewModel>(),
        lexiconRepository: _getIt<LexiconRepository>(),
      ),
    );
  }

  /// Register sync and conflict resolution services
  static void _registerSyncServices() {
    // Conflict Resolution Service
    _getIt.registerLazySingleton<ConflictResolutionService>(
      () => ConflictResolutionService(
        localDataSource: _getIt<LexiconLocalDataSource>(),
      ),
    );

    // Sync Manager
    _getIt.registerLazySingleton<SyncManager>(
      () => SyncManager(
        localDataSource: _getIt<LexiconLocalDataSource>(),
        remoteDataSource: _getIt<LexiconRemoteDataSource>(),
        networkInfo: _getIt<NetworkInfo>(),
      ),
    );
  }

  /// Get service instance
  static T get<T extends Object>() {
    return _getIt<T>();
  }

  /// Check if service is registered
  static bool isRegistered<T extends Object>() {
    return _getIt.isRegistered<T>();
  }

  /// Reset all services (useful for testing)
  static Future<void> reset() async {
    await _getIt.reset();
  }

  /// Get service registration status report
  static Map<String, bool> getServiceStatus() {
    return {
      'NetworkInfo': isRegistered<NetworkInfo>(),
      'Database': isRegistered<Database>(),
      'AIService': isRegistered<AIService>(),
      'NotificationService': isRegistered<NotificationService>(),
      'AuthRepository': isRegistered<AuthRepository>(),
      'LexiconRepository': isRegistered<LexiconRepository>(),
      'SyncManager': isRegistered<SyncManager>(),
      'ConflictResolutionService': isRegistered<ConflictResolutionService>(),
    };
  }
}

/// Extension to help with service access throughout the app
extension ServiceAccess on Object {
  T getService<T extends Object>() => ServiceRegistry.get<T>();
}