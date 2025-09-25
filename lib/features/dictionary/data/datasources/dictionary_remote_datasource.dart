import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../models/word_model.dart';
import '../models/pronunciation_model.dart';
import '../models/translation_model.dart';

/// Remote data source for dictionary operations using Firebase
abstract class DictionaryRemoteDataSource {
  /// Search for words by query
  Future<List<WordModel>> searchWords(String query, {String? language});

  /// Get word by ID
  Future<WordModel> getWord(String wordId);

  /// Get pronunciation for a word
  Future<PronunciationModel> getPronunciation(String wordId, String language);

  /// Get translations for a word
  Future<List<TranslationModel>> getTranslations(String wordId, String targetLanguage);

  /// Save word to favorites
  Future<void> saveToFavorites(String wordId, String userId);

  /// Remove word from favorites
  Future<void> removeFromFavorites(String wordId, String userId);

  /// Get user's favorite words
  Future<List<WordModel>> getFavoriteWords(String userId);

  /// Get words by category
  Future<List<WordModel>> getWordsByCategory(String category, {String? language});

  /// Get words by difficulty level
  Future<List<WordModel>> getWordsByDifficulty(int difficulty, {String? language});
}

/// Firebase implementation of DictionaryRemoteDataSource
class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;

  DictionaryRemoteDataSourceImpl({
    required this.firestore,
    required this.networkInfo,
  });

  @override
  Future<List<WordModel>> searchWords(String query, {String? language}) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      Query queryRef = firestore.collection('dictionary');

      if (language != null) {
        queryRef = queryRef.where('language', isEqualTo: language);
      }

      // Search by word starting with query (case insensitive would need additional setup)
      queryRef = queryRef
          .where('word', isGreaterThanOrEqualTo: query)
          .where('word', isLessThan: '${query}\uf8ff')
          .limit(20);

      final snapshot = await queryRef.get();
      return snapshot.docs
          .map((doc) => WordModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to search words: ${e.toString()}');
    }
  }

  @override
  Future<WordModel> getWord(String wordId) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      final doc = await firestore.collection('dictionary').doc(wordId).get();
      if (!doc.exists) {
        throw const NotFoundFailure('Word not found');
      }
      return WordModel.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw ServerFailure('Failed to get word: ${e.toString()}');
    }
  }

  @override
  Future<PronunciationModel> getPronunciation(String wordId, String language) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      final query = await firestore
          .collection('pronunciations')
          .where('wordId', isEqualTo: wordId)
          .where('language', isEqualTo: language)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const NotFoundFailure('Pronunciation not found');
      }

      final doc = query.docs.first;
      return PronunciationModel.fromFirestore(doc.data(), doc.id);
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw ServerFailure('Failed to get pronunciation: ${e.toString()}');
    }
  }

  @override
  Future<List<TranslationModel>> getTranslations(String wordId, String targetLanguage) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      final query = await firestore
          .collection('translations')
          .where('wordId', isEqualTo: wordId)
          .where('targetLanguage', isEqualTo: targetLanguage)
          .get();

      return query.docs
          .map((doc) => TranslationModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to get translations: ${e.toString()}');
    }
  }

  @override
  Future<void> saveToFavorites(String wordId, String userId) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      await firestore.collection('favorites').doc('${userId}_$wordId').set({
        'userId': userId,
        'wordId': wordId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerFailure('Failed to save to favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromFavorites(String wordId, String userId) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      await firestore.collection('favorites').doc('${userId}_$wordId').delete();
    } catch (e) {
      throw ServerFailure('Failed to remove from favorites: ${e.toString()}');
    }
  }

  @override
  Future<List<WordModel>> getFavoriteWords(String userId) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      final favoritesQuery = await firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();

      final wordIds = favoritesQuery.docs.map((doc) => doc.data()['wordId'] as String).toList();

      if (wordIds.isEmpty) return [];

      final wordsQuery = await firestore
          .collection('dictionary')
          .where(FieldPath.documentId, whereIn: wordIds)
          .get();

      return wordsQuery.docs
          .map((doc) => WordModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to get favorite words: ${e.toString()}');
    }
  }

  @override
  Future<List<WordModel>> getWordsByCategory(String category, {String? language}) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      Query queryRef = firestore.collection('dictionary').where('category', isEqualTo: category);

      if (language != null) {
        queryRef = queryRef.where('language', isEqualTo: language);
      }

      final snapshot = await queryRef.limit(50).get();
      return snapshot.docs
          .map((doc) => WordModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to get words by category: ${e.toString()}');
    }
  }

  @override
  Future<List<WordModel>> getWordsByDifficulty(int difficulty, {String? language}) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    try {
      Query queryRef = firestore.collection('dictionary').where('difficulty', isEqualTo: difficulty);

      if (language != null) {
        queryRef = queryRef.where('language', isEqualTo: language);
      }

      final snapshot = await queryRef.limit(50).get();
      return snapshot.docs
          .map((doc) => WordModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to get words by difficulty: ${e.toString()}');
    }
  }
}
