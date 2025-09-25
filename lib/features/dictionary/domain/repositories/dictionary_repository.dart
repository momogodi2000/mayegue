import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/entities/pronunciation_entity.dart';
import '../../domain/entities/translation_entity.dart';

/// Abstract repository for dictionary operations
abstract class DictionaryRepository {
  /// Search for words by query
  Future<Either<Failure, List<WordEntity>>> searchWords(String query, {String? language});

  /// Get word by ID
  Future<Either<Failure, WordEntity>> getWord(String wordId);

  /// Get pronunciation for a word
  Future<Either<Failure, PronunciationEntity>> getPronunciation(String wordId, String language);

  /// Get translations for a word
  Future<Either<Failure, List<TranslationEntity>>> getTranslations(String wordId, String targetLanguage);

  /// Save word to favorites
  Future<Either<Failure, bool>> saveToFavorites(String wordId, String userId);

  /// Remove word from favorites
  Future<Either<Failure, bool>> removeFromFavorites(String wordId, String userId);

  /// Get user's favorite words
  Future<Either<Failure, List<WordEntity>>> getFavoriteWords(String userId);

  /// Get words by category
  Future<Either<Failure, List<WordEntity>>> getWordsByCategory(String category, {String? language});

  /// Get words by difficulty level
  Future<Either<Failure, List<WordEntity>>> getWordsByDifficulty(int difficulty, {String? language});
}
