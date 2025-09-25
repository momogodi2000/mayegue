import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/router.dart';
import '../../../../core/constants/routes.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/facebook_sign_in_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/sign_in_with_phone_number_usecase.dart';
import '../../domain/usecases/verify_phone_number_usecase.dart';
import '../../domain/usecases/apple_sign_in_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/usecases/get_onboarding_status_usecase.dart';

/// Authentication view model
class AuthViewModel extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final GoogleSignInUsecase googleSignInUsecase;
  final FacebookSignInUsecase facebookSignInUsecase;
  final AppleSignInUsecase appleSignInUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final GetOnboardingStatusUsecase getOnboardingStatusUsecase;
  final SignInWithPhoneNumberUsecase signInWithPhoneNumberUsecase;
  final VerifyPhoneNumberUsecase verifyPhoneNumberUsecase;

  AuthViewModel({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.resetPasswordUsecase,
    required this.getCurrentUserUsecase,
    required this.googleSignInUsecase,
    required this.facebookSignInUsecase,
    required this.appleSignInUsecase,
    required this.forgotPasswordUsecase,
    required this.getOnboardingStatusUsecase,
    required this.signInWithPhoneNumberUsecase,
    required this.verifyPhoneNumberUsecase,
  });

  // State
  bool _isLoading = false;
  String? _errorMessage;
  UserEntity? _currentUser;
  bool _isOnboardingCompleted = false;
  // Phone number sign-in state
  String? _phoneNumber;
  String? _smsCode;
  String? _verificationId;
  bool _isPhoneAuthInProgress = false;

  String? get phoneNumber => _phoneNumber;
  String? get smsCode => _smsCode;
  String? get verificationId => _verificationId;
  bool get isPhoneAuthInProgress => _isPhoneAuthInProgress;

  // Start phone number sign-in (request OTP)
  Future<bool> signInWithPhoneNumber(String phoneNumber) async {
    _setLoading(true);
    _clearError();
    _isPhoneAuthInProgress = true;
    _phoneNumber = phoneNumber;
    try {
      final response = await signInWithPhoneNumberUsecase(phoneNumber);
      // Assume response.message contains verificationId if success
      if (response.success == true && response.message != null) {
        _verificationId = response.message;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? 'Erreur lors de l’envoi du code.');
        _setLoading(false);
        _isPhoneAuthInProgress = false;
        return false;
      }
    } catch (e) {
      _setError('Erreur: $e');
      _setLoading(false);
      _isPhoneAuthInProgress = false;
      return false;
    }
  }

  // Verify OTP code
  Future<bool> verifyPhoneNumber(String smsCode) async {
    _setLoading(true);
    _clearError();
    _smsCode = smsCode;
    if (_verificationId == null) {
      _setError('Aucune vérification en cours.');
      _setLoading(false);
      return false;
    }
    try {
      final response = await verifyPhoneNumberUsecase(_verificationId!, smsCode);
      if (response.success == true) {
        _currentUser = response.user;
        _setLoading(false);
        _isPhoneAuthInProgress = false;
        authRefreshNotifier.notifyAuthChanged();
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? 'Vérification échouée.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erreur: $e');
      _setLoading(false);
      return false;
    }
  }
  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isOnboardingCompleted => _isOnboardingCompleted;

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    final result = await loginUsecase(email, password);

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (authResponse) {
        _currentUser = authResponse.user;
        _setLoading(false);
        authRefreshNotifier.notifyAuthChanged();
        notifyListeners();
        return true;
      },
    );
  }

  // Register
  Future<bool> register(String email, String password, String displayName) async {
    _setLoading(true);
    _clearError();

    final result = await registerUsecase(email, password, displayName);

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (authResponse) {
        _currentUser = authResponse.user;
        _setLoading(false);
        authRefreshNotifier.notifyAuthChanged();
        notifyListeners();
        return true;
      },
    );
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    final result = await googleSignInUsecase(NoParams());

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (authResponse) {
        _currentUser = authResponse.user;
        _setLoading(false);
        authRefreshNotifier.notifyAuthChanged();
        notifyListeners();
        return true;
      },
    );
  }

  // Facebook Sign In
  Future<bool> signInWithFacebook() async {
    _setLoading(true);
    _clearError();

    final result = await facebookSignInUsecase(NoParams());

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (authResponse) {
        _currentUser = authResponse.user;
        _setLoading(false);
        authRefreshNotifier.notifyAuthChanged();
        notifyListeners();
        return true;
      },
    );
  }

  // Forgot Password
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();

    final result = await forgotPasswordUsecase(ForgotPasswordParams(email: email));

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (_) {
        _setLoading(false);
        return true;
      },
    );
  }

  // Logout
  Future<bool> logout() async {
    _setLoading(true);
    _clearError();

    final result = await logoutUsecase();

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (_) {
        _currentUser = null;
        _setLoading(false);
        authRefreshNotifier.notifyAuthChanged();
        notifyListeners();
        return true;
      },
    );
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    final result = await resetPasswordUsecase(email);

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (_) {
        _setLoading(false);
        return true;
      },
    );
  }

  // Get current user
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    _clearError();

    final result = await getCurrentUserUsecase();

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
      },
      (user) async {
        _currentUser = user;
        // Check onboarding status when user is loaded
        await checkOnboardingStatus();
        _setLoading(false);
        authRefreshNotifier.notifyAuthChanged();
        notifyListeners();
      },
    );
  }

  // Check onboarding status
  Future<void> checkOnboardingStatus() async {
    final result = await getOnboardingStatusUsecase(NoParams());

    result.fold(
      (failure) {
        // If there's an error checking onboarding status, assume it's not completed
        _isOnboardingCompleted = false;
      },
      (isCompleted) {
        _isOnboardingCompleted = isCompleted;
      },
    );
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Get appropriate route based on user role
  String getRoleBasedRoute() {
    if (_currentUser == null) return Routes.login;

    switch (_currentUser!.role) {
      case 'admin':
        return Routes.adminDashboard;
      case 'teacher':
      case 'instructor':
        return Routes.teacherDashboard;
      case 'learner':
      default:
        return Routes.dashboard;
    }
  }

  // Navigate to role-based dashboard
  void navigateToRoleBasedDashboard(BuildContext context) {
    final route = getRoleBasedRoute();
    GoRouter.of(context).go(route);
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return 'Erreur d\'authentification: ${failure.message}';
    } else if (failure is NetworkFailure) {
      return 'Erreur réseau: ${failure.message}';
    } else if (failure is ServerFailure) {
      return 'Erreur serveur: ${failure.message}';
    } else {
      return 'Une erreur s\'est produite: ${failure.message}';
    }
  }
}
