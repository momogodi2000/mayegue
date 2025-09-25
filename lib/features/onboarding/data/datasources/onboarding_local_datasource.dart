import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../models/onboarding_model.dart';

/// Abstract datasource for onboarding local storage operations
abstract class OnboardingLocalDataSource {
  /// Save onboarding data to local storage
  Future<Either<Failure, void>> saveOnboardingData(OnboardingModel data);

  /// Get onboarding status from local storage
  Future<Either<Failure, bool>> getOnboardingStatus();

  /// Get saved onboarding data from local storage
  Future<Either<Failure, OnboardingModel?>> getOnboardingData();

  /// Clear onboarding data from local storage
  Future<Either<Failure, void>> clearOnboardingData();
}
