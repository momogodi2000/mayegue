import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/entities/pronunciation_entity.dart';
import '../../domain/entities/translation_entity.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_local_datasource.dart';
import '../datasources/dictionary_remote_datasource.dart';

/// Implementation of DictionaryRepository
class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDataSource remoteDataSource;
  final DictionaryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DictionaryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<WordEntity>>> searchWords(String query, {String? language}) async {
    try {
      // Try to get cached results first
      final cachedResults = await localDataSource.getCachedSearchResults(query);
      if (cachedResults != null && cachedResults.isNotEmpty) {
        return Right(cachedResults.map((model) => model.toEntity()).toList());
      }

      // If no cache or cache is empty, fetch from remote
      if (await networkInfo.isConnected) {
        final remoteResults = await remoteDataSource.searchWords(query, language: language);

        // Cache the results
        await localDataSource.cacheSearchResults(query, remoteResults);

        return Right(remoteResults.map((model) => model.toEntity()).toList());
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, WordEntity>> getWord(String wordId) async {
    try {
      // Try to get cached word first
      final cachedWord = await localDataSource.getCachedWord(wordId);
      if (cachedWord != null) {
        return Right(cachedWord.toEntity());
      }

      // If no cache, fetch from remote
      if (await networkInfo.isConnected) {
        final remoteWord = await remoteDataSource.getWord(wordId);

        // Cache the word
        await localDataSource.cacheWord(remoteWord);

        return Right(remoteWord.toEntity());
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PronunciationEntity>> getPronunciation(String wordId, String language) async {
    try {
      if (await networkInfo.isConnected) {
        final pronunciation = await remoteDataSource.getPronunciation(wordId, language);
        return Right(pronunciation.toEntity());
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TranslationEntity>>> getTranslations(String wordId, String targetLanguage) async {
    try {
      if (await networkInfo.isConnected) {
        final translations = await remoteDataSource.getTranslations(wordId, targetLanguage);
        return Right(translations.map((model) => model.toEntity()).toList());
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveToFavorites(String wordId, String userId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.saveToFavorites(wordId, userId);
        return const Right(true);
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromFavorites(String wordId, String userId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.removeFromFavorites(wordId, userId);
        return const Right(true);
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> getFavoriteWords(String userId) async {
    try {
      // Try to get cached favorites first
      final cachedFavorites = await localDataSource.getCachedFavoriteWords();
      if (cachedFavorites != null && cachedFavorites.isNotEmpty) {
        return Right(cachedFavorites.map((model) => model.toEntity()).toList());
      }

      // If no cache, fetch from remote
      if (await networkInfo.isConnected) {
        final remoteFavorites = await remoteDataSource.getFavoriteWords(userId);

        // Cache the results
        await localDataSource.cacheFavoriteWords(remoteFavorites);

        return Right(remoteFavorites.map((model) => model.toEntity()).toList());
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> getWordsByCategory(String category, {String? language}) async {
    try {
      if (await networkInfo.isConnected) {
        final words = await remoteDataSource.getWordsByCategory(category, language: language);
        return Right(words.map((model) => model.toEntity()).toList());
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> getWordsByDifficulty(int difficulty, {String? language}) async {
    try {
      if (await networkInfo.isConnected) {
        final words = await remoteDataSource.getWordsByDifficulty(difficulty, language: language);
        return Right(words.map((model) => model.toEntity()).toList());
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
