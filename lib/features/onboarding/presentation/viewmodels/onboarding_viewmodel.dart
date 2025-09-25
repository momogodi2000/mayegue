import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../../domain/usecases/get_onboarding_status_usecase.dart';

/// Onboarding view model
class OnboardingViewModel extends ChangeNotifier {
  final CompleteOnboardingUsecase completeOnboardingUsecase;
  final GetOnboardingStatusUsecase getOnboardingStatusUsecase;

  OnboardingViewModel({
    required this.completeOnboardingUsecase,
    required this.getOnboardingStatusUsecase,
  });

  // State
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCompleted = false;
  int _currentStep = 0;
  String _selectedLanguage = 'ewondo'; // Default to Ewondo
  String _userName = '';
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _microphonePermissionGranted = false;
  bool _cameraPermissionGranted = false;
  bool _storagePermissionGranted = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCompleted => _isCompleted;
  int get currentStep => _currentStep;
  String get selectedLanguage => _selectedLanguage;
  String get userName => _userName;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get microphonePermissionGranted => _microphonePermissionGranted;
  bool get cameraPermissionGranted => _cameraPermissionGranted;
  bool get storagePermissionGranted => _storagePermissionGranted;

  // Total steps in onboarding
  static const int totalSteps = 5;

  // Step titles
  List<String> get stepTitles => [
    'Bienvenue',
    'Choisissez votre langue',
    'Préférences',
    'Permissions',
    'Prêt à commencer !'
  ];

  // Step descriptions
  List<String> get stepDescriptions => [
    'Découvrez Mayegue, votre compagnon d\'apprentissage des langues camerounaises.',
    'Sélectionnez la langue que vous souhaitez apprendre.',
    'Personnalisez votre expérience d\'apprentissage.',
    'Autorisez l\'accès aux fonctionnalités nécessaires.',
    'Votre aventure linguistique commence maintenant !'
  ];

  // Initialize onboarding
  Future<void> initialize() async {
    _setLoading(true);
    _clearError();

    final result = await getOnboardingStatusUsecase(const NoParams());

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
      },
      (isCompleted) {
        _isCompleted = isCompleted;
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  // Navigate to next step
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  // Navigate to previous step
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Set selected language
  void setSelectedLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  // Set user name
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  // Toggle notifications
  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }

  // Toggle sound
  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
    notifyListeners();
  }

  // Complete onboarding
  Future<bool> completeOnboarding() async {
    _setLoading(true);
    _clearError();

    final onboardingData = OnboardingEntity(
      selectedLanguage: _selectedLanguage,
      userName: _userName,
      notificationsEnabled: _notificationsEnabled,
      soundEnabled: _soundEnabled,
      completedAt: DateTime.now(),
    );

    final result = await completeOnboardingUsecase(onboardingData);

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (_) {
        _isCompleted = true;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Skip onboarding
  Future<bool> skipOnboarding() async {
    _setLoading(true);
    _clearError();

    final onboardingData = OnboardingEntity(
      selectedLanguage: 'ewondo', // Default
      userName: '',
      notificationsEnabled: true,
      soundEnabled: true,
      completedAt: DateTime.now(),
    );

    final result = await completeOnboardingUsecase(onboardingData);

    return result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false);
        return false;
      },
      (_) {
        _isCompleted = true;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
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

  String _mapFailureToMessage(Failure failure) {
    if (failure is CacheFailure) {
      return 'Erreur de sauvegarde: ${failure.message}';
    } else {
      return 'Une erreur s\'est produite: ${failure.message}';
    }
  }

  // Permission methods
  Future<void> requestMicrophonePermission() async {
    // TODO: Implement permission request using PermissionService
    _microphonePermissionGranted = true; // Mock for now
    notifyListeners();
  }

  Future<void> requestCameraPermission() async {
    // TODO: Implement permission request
    _cameraPermissionGranted = true; // Mock for now
    notifyListeners();
  }

  Future<void> requestStoragePermission() async {
    // TODO: Implement permission request
    _storagePermissionGranted = true; // Mock for now
    notifyListeners();
  }
}
