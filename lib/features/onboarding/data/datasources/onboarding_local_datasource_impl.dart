import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/onboarding_model.dart';
import 'onboarding_local_datasource.dart';

/// Implementation of OnboardingLocalDataSource using Hive
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final StorageService storageService;

  static const String _onboardingKey = 'user_onboarding';
  static const String _statusKey = 'onboarding_completed';

  OnboardingLocalDataSourceImpl(this.storageService);

  @override
  Future<Either<Failure, void>> saveOnboardingData(OnboardingModel data) async {
    try {
      await storageService.saveSetting(_onboardingKey, data.toJson());
      await storageService.saveSetting(_statusKey, true);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la sauvegarde des données d\'onboarding: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> getOnboardingStatus() async {
    try {
      final status = await storageService.getSetting(_statusKey);
      return Right(status as bool? ?? false);
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération du statut d\'onboarding: $e'));
    }
  }

  @override
  Future<Either<Failure, OnboardingModel?>> getOnboardingData() async {
    try {
      final data = await storageService.getSetting(_onboardingKey);
      if (data == null) {
        return const Right(null);
      }

      if (data is Map<String, dynamic>) {
        final model = OnboardingModel.fromJson(data);
        return Right(model);
      } else {
        return const Left(CacheFailure('Format de données d\'onboarding invalide'));
      }
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération des données d\'onboarding: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearOnboardingData() async {
    try {
      // Since StorageService doesn't have delete methods, we'll save null values
      await storageService.saveSetting(_onboardingKey, null);
      await storageService.saveSetting(_statusKey, null);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la suppression des données d\'onboarding: $e'));
    }
  }
}
