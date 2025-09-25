import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../../../core/services/firebase_service.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signInWithEmailAndPassword(String email, String password);
  Future<AuthResponseModel> signUpWithEmailAndPassword(String email, String password, String displayName);
  Future<AuthResponseModel> signInWithGoogle();
  Future<AuthResponseModel> signInWithFacebook();
  Future<AuthResponseModel> signInWithApple();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<void> sendPasswordResetEmail(String email);
  Future<UserModel> updateUserProfile(UserModel user);
  Future<void> deleteUserAccount();
  Stream<UserModel?> get authStateChanges;
}

/// Firebase implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseService firebaseService;

  AuthRemoteDataSourceImpl(this.firebaseService);

  @override
  Future<AuthResponseModel> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await firebaseService.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel.fromFirebaseUser(userCredential.user!);
    return AuthResponseModel(user: user);
  }

  @override
  Future<AuthResponseModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final userCredential = await firebaseService.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.updateDisplayName(displayName);

    final user = UserModel.fromFirebaseUser(userCredential.user!);
    return AuthResponseModel(user: user);
  }

  @override
  Future<AuthResponseModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Google sign in cancelled');

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await firebaseService.auth.signInWithCredential(credential);
    final user = UserModel.fromFirebaseUser(userCredential.user!);
    return AuthResponseModel(user: user);
  }

  @override
  Future<AuthResponseModel> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) {
      throw Exception('Facebook sign in failed: ${result.message}');
    }

    final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
    final userCredential = await firebaseService.auth.signInWithCredential(credential);
    final user = UserModel.fromFirebaseUser(userCredential.user!);
    return AuthResponseModel(user: user);
  }

  @override
  Future<AuthResponseModel> signInWithApple() async {
    // TODO: Implement Apple sign-in using sign_in_with_apple package
    // This requires adding the package to pubspec.yaml and configuring Apple developer account
    throw UnimplementedError('Apple sign-in not implemented yet');
  }

  @override
  Future<void> signOut() async {
    await firebaseService.auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = firebaseService.auth.currentUser;
    return firebaseUser != null ? UserModel.fromFirebaseUser(firebaseUser) : null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return firebaseService.auth.currentUser != null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseService.auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    final firebaseUser = firebaseService.auth.currentUser;
    if (firebaseUser == null) throw Exception('No authenticated user');

    await firebaseUser.updateDisplayName(user.displayName);
    if (user.photoUrl != null) {
      await firebaseUser.updatePhotoURL(user.photoUrl);
    }

    // Update in Firestore
    await firebaseService.firestore
        .collection('users')
        .doc(user.id)
        .update(user.toFirestore());

    return user;
  }

  @override
  Future<void> deleteUserAccount() async {
    final firebaseUser = firebaseService.auth.currentUser;
    if (firebaseUser == null) throw Exception('No authenticated user');

    // Delete from Firestore
    await firebaseService.firestore.collection('users').doc(firebaseUser.uid).delete();

    // Delete from Auth
    await firebaseUser.delete();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseService.auth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? UserModel.fromFirebaseUser(firebaseUser) : null;
    });
  }
}
