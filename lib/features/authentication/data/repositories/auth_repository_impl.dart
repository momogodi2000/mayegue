import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthResponseEntity> signInWithEmailAndPassword(String email, String password) async {
    final result = await remoteDataSource.signInWithEmailAndPassword(email, password);
    return result;
  }

  @override
  Future<AuthResponseEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final result = await remoteDataSource.signUpWithEmailAndPassword(
      email,
      password,
      displayName,
    );
    return result;
  }

  @override
  Future<AuthResponseEntity> signInWithGoogle() async {
    final result = await remoteDataSource.signInWithGoogle();
    return result;
  }

  @override
  Future<AuthResponseEntity> signInWithFacebook() async {
    final result = await remoteDataSource.signInWithFacebook();
    return result;
  }

  @override
  Future<AuthResponseEntity> signInWithApple() async {
    final result = await remoteDataSource.signInWithApple();
    return result;
  }

  @override
  Future<AuthResponseEntity> signInWithPhoneNumber(String phoneNumber) async {
    // TODO: Implement phone authentication
    throw UnimplementedError('Phone authentication not implemented');
  }

  @override
  Future<AuthResponseEntity> verifyPhoneNumber(String verificationId, String smsCode) async {
    // TODO: Implement phone verification
    throw UnimplementedError('Phone verification not implemented');
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = await remoteDataSource.getCurrentUser();
    return user;
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
    final userModel = UserModel.fromEntity(user);
    final updatedUser = await remoteDataSource.updateUserProfile(userModel);
    return updatedUser;
  }

  @override
  Future<void> deleteUserAccount() async {
    await remoteDataSource.deleteUserAccount();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }
}
