import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/usecases/get_word_usecase.dart';
import '../../domain/usecases/save_favorite_word_usecase.dart';
import '../../domain/usecases/search_words_usecase.dart';

/// ViewModel for dictionary operations
class DictionaryViewModel extends ChangeNotifier {
  final SearchWordsUsecase searchWordsUsecase;
  final GetWordUsecase getWordUsecase;
  final SaveFavoriteWordUsecase saveFavoriteWordUsecase;

  DictionaryViewModel({
    required this.searchWordsUsecase,
    required this.getWordUsecase,
    required this.saveFavoriteWordUsecase,
  });

  // State
  bool _isLoading = false;
  String? _errorMessage;
  List<WordEntity> _searchResults = [];
  WordEntity? _selectedWord;
  List<WordEntity> _favoriteWords = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<WordEntity> get searchResults => _searchResults;
  WordEntity? get selectedWord => _selectedWord;
  List<WordEntity> get favoriteWords => _favoriteWords;

  /// Search for words
  Future<void> searchWords(String query, {String? language}) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await searchWordsUsecase(
      SearchWordsParams(query: query, language: language),
    );

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _searchResults = [];
      },
      (words) {
        _searchResults = words;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Get word details
  Future<void> getWordDetails(String wordId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getWordUsecase(GetWordParams(wordId: wordId));

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _selectedWord = null;
      },
      (word) {
        _selectedWord = word;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Save word to favorites
  Future<bool> saveToFavorites(String wordId, String userId) async {
    final result = await saveFavoriteWordUsecase(
      SaveFavoriteWordParams(wordId: wordId, userId: userId),
    );

    return result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (success) {
        // Update local favorite list if the word is in search results
        final wordIndex = _searchResults.indexWhere((word) => word.id == wordId);
        if (wordIndex != -1) {
          // Note: In a real app, you'd want to update the word's favorite status
          // This would require modifying the WordEntity or having a separate favorite status
        }
        return true;
      },
    );
  }

  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    _selectedWord = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Vérifiez votre connexion internet';
      case ServerFailure:
        return 'Erreur du serveur. Réessayez plus tard';
      case NotFoundFailure:
        return 'Mot non trouvé';
      case CacheFailure:
        return 'Erreur de cache';
      default:
        return 'Une erreur est survenue';
    }
  }
}
