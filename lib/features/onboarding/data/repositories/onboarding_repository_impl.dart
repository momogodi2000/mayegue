import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';
import '../models/onboarding_model.dart';

/// Implementation of OnboardingRepository
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveOnboardingData(OnboardingEntity data) async {
    try {
      final model = OnboardingModel.fromEntity(data);
      return await localDataSource.saveOnboardingData(model);
    } catch (e) {
      return const Left(CacheFailure('Erreur lors de la sauvegarde des données d\'onboarding'));
    }
  }

  @override
  Future<Either<Failure, bool>> getOnboardingStatus() async {
    try {
      return await localDataSource.getOnboardingStatus();
    } catch (e) {
      return const Left(CacheFailure('Erreur lors de la récupération du statut d\'onboarding'));
    }
  }

  @override
  Future<Either<Failure, OnboardingEntity?>> getOnboardingData() async {
    try {
      final result = await localDataSource.getOnboardingData();
      return result.fold(
        (failure) => Left(failure),
        (model) => Right(model?.toEntity()),
      );
    } catch (e) {
      return const Left(CacheFailure('Erreur lors de la récupération des données d\'onboarding'));
    }
  }

  @override
  Future<Either<Failure, void>> clearOnboardingData() async {
    try {
      return await localDataSource.clearOnboardingData();
    } catch (e) {
      return const Left(CacheFailure('Erreur lors de la suppression des données d\'onboarding'));
    }
  }
}
