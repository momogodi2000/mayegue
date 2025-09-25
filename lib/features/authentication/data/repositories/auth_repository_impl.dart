import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/services/sync_manager.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

/// Implementation of AuthRepository with offline support
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final Connectivity connectivity;
  final SyncManager syncManager;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
    required this.syncManager,
  });

  @override
  Future<AuthResponseEntity> signInWithEmailAndPassword(String email, String password) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Offline mode - try to get cached user
      final cachedUser = await localDataSource.getCurrentUser();
      if (cachedUser != null && cachedUser.email == email) {
        return AuthResponseEntity(
          user: cachedUser,
          success: true,
          message: 'Signed in offline',
        );
      } else {
        // Create a dummy user for error case - this is not ideal but required by the entity
        final dummyUser = UserEntity(
          id: 'offline',
          email: email,
          createdAt: DateTime.now(),
        );
        return AuthResponseEntity(
          user: dummyUser,
          success: false,
          message: 'No internet connection and no cached credentials',
        );
      }
    }

    // Online mode
    final result = await remoteDataSource.signInWithEmailAndPassword(email, password);

    if (result.success) {
      // Cache user locally
      await localDataSource.saveUser(result.user);

      // Queue sync operation
      await syncManager.queueOperation(SyncOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        operationType: SyncOperationType.update,
        tableName: 'users',
        recordId: result.user.id,
        data: {
          'email': result.user.email,
          'displayName': result.user.displayName,
          'lastLoginAt': DateTime.now().toIso8601String(),
        },
        timestamp: DateTime.now(),
      ));
    }

    return result;
  }

  @override
  Future<AuthResponseEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final dummyUser = UserEntity(
        id: 'offline',
        email: email,
        createdAt: DateTime.now(),
      );
      return AuthResponseEntity(
        user: dummyUser,
        success: false,
        message: 'Internet connection required for registration',
      );
    }

    final result = await remoteDataSource.signUpWithEmailAndPassword(
      email,
      password,
      displayName,
    );

    if (result.success) {
      // Cache user locally
      await localDataSource.saveUser(result.user);

      // Queue sync operation
      await syncManager.queueOperation(SyncOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        operationType: SyncOperationType.insert,
        tableName: 'users',
        recordId: result.user.id,
        data: {
          'email': result.user.email,
          'displayName': result.user.displayName,
          'createdAt': result.user.createdAt.toIso8601String(),
        },
        timestamp: DateTime.now(),
      ));
    }

    return result;
  }

  @override
  Future<AuthResponseEntity> signInWithGoogle() async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final dummyUser = UserEntity(
        id: 'offline',
        email: 'offline@example.com',
        createdAt: DateTime.now(),
      );
      return AuthResponseEntity(
        user: dummyUser,
        success: false,
        message: 'Internet connection required for Google sign-in',
      );
    }

    final result = await remoteDataSource.signInWithGoogle();

    if (result.success) {
      // Cache user locally
      await localDataSource.saveUser(result.user);

      // Queue sync operation
      await syncManager.queueOperation(SyncOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        operationType: SyncOperationType.update,
        tableName: 'users',
        recordId: result.user.id,
        data: {
          'email': result.user.email,
          'displayName': result.user.displayName,
          'lastLoginAt': DateTime.now().toIso8601String(),
        },
        timestamp: DateTime.now(),
      ));
    }

    return result;
  }

  @override
  Future<AuthResponseEntity> signInWithFacebook() async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final dummyUser = UserEntity(
        id: 'offline',
        email: 'offline@example.com',
        createdAt: DateTime.now(),
      );
      return AuthResponseEntity(
        user: dummyUser,
        success: false,
        message: 'Internet connection required for Facebook sign-in',
      );
    }

    final result = await remoteDataSource.signInWithFacebook();

    if (result.success) {
      await localDataSource.saveUser(result.user);
      await syncManager.queueOperation(SyncOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        operationType: SyncOperationType.update,
        tableName: 'users',
        recordId: result.user.id,
        data: {
          'email': result.user.email,
          'displayName': result.user.displayName,
          'lastLoginAt': DateTime.now().toIso8601String(),
        },
        timestamp: DateTime.now(),
      ));
    }

    return result;
  }

  @override
  Future<AuthResponseEntity> signInWithApple() async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final dummyUser = UserEntity(
        id: 'offline',
        email: 'offline@example.com',
        createdAt: DateTime.now(),
      );
      return AuthResponseEntity(
        user: dummyUser,
        success: false,
        message: 'Internet connection required for Apple sign-in',
      );
    }

    final result = await remoteDataSource.signInWithApple();

    if (result.success) {
      await localDataSource.saveUser(result.user);
      await syncManager.queueOperation(SyncOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        operationType: SyncOperationType.update,
        tableName: 'users',
        recordId: result.user.id,
        data: {
          'email': result.user.email,
          'displayName': result.user.displayName,
          'lastLoginAt': DateTime.now().toIso8601String(),
        },
        timestamp: DateTime.now(),
      ));
    }

    return result;
  }

  // Add remaining methods from the interface
  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
    // Clear local user data
    final currentUser = await localDataSource.getCurrentUser();
    if (currentUser != null) {
      await localDataSource.deleteUser(currentUser.id);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return await localDataSource.getCurrentUser();
    }

    final remoteUser = await remoteDataSource.getCurrentUser();
    if (remoteUser != null) {
      await localDataSource.saveUser(remoteUser);
    }
    return remoteUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    return await remoteDataSource.isAuthenticated();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<UserEntity> updateUserProfile(UserEntity user) async {
    final result = await remoteDataSource.updateUserProfile(UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoUrl,
      role: user.role,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      isEmailVerified: user.isEmailVerified,
      preferences: user.preferences,
    ));

    await localDataSource.saveUser(result);
    return result;
  }

  @override
  Future<void> deleteUserAccount() async {
    await remoteDataSource.deleteUserAccount();
    final currentUser = await localDataSource.getCurrentUser();
    if (currentUser != null) {
      await localDataSource.deleteUser(currentUser.id);
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((userModel) {
      if (userModel != null) {
        localDataSource.saveUser(userModel);
      }
      return userModel;
    });
  }

  @override
  Future<AuthResponseEntity> signInWithPhoneNumber(String phoneNumber) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final dummyUser = UserEntity(
        id: 'offline',
        email: 'offline@example.com',
        createdAt: DateTime.now(),
      );
      return AuthResponseEntity(
        user: dummyUser,
        success: false,
        message: 'Internet connection required for phone sign-in',
      );
    }

    // For now, return error as phone auth is not fully implemented
    final dummyUser = UserEntity(
      id: 'phone_auth_not_implemented',
      email: 'phone@example.com',
      createdAt: DateTime.now(),
    );
    return AuthResponseEntity(
      user: dummyUser,
      success: false,
      message: 'Phone authentication not yet implemented',
    );
  }

  @override
  Future<AuthResponseEntity> verifyPhoneNumber(String verificationId, String smsCode) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final dummyUser = UserEntity(
        id: 'offline',
        email: 'offline@example.com',
        createdAt: DateTime.now(),
      );
      return AuthResponseEntity(
        user: dummyUser,
        success: false,
        message: 'Internet connection required for phone verification',
      );
    }

    // For now, return error as phone auth is not fully implemented
    final dummyUser = UserEntity(
      id: 'phone_auth_not_implemented',
      email: 'phone@example.com',
      createdAt: DateTime.now(),
    );
    return AuthResponseEntity(
      user: dummyUser,
      success: false,
      message: 'Phone authentication not yet implemented',
    );
  }
}
