import 'package:hive/hive.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/game_entity.dart';
import '../models/game_model.dart';

/// Abstract data source for games operations
abstract class GamesDataSource {
  Future<List<GameModel>> getGamesByLanguage(String language);
  Future<List<GameModel>> getGamesByType(GameType type, String language);
  Future<List<GameModel>> getGamesByDifficulty(GameDifficulty difficulty, String language);
  Future<GameModel?> getGameById(String gameId);
  Future<List<GameModel>> getRecommendedGames(String userId, String language);
  Future<List<GameModel>> getPremiumGames(String language);
  Future<List<GameModel>> getFreeGames(String language);
  Future<GameProgressModel?> getGameProgress(String userId, String gameId);
  Future<void> updateGameProgress(GameProgressModel progress);
  Future<List<GameProgressModel>> getUserGameProgress(String userId);
  Future<Map<String, dynamic>> getGameStatistics(String userId);
  Future<List<GameModel>> searchGames(String query, {String? language});
  Future<List<GameModel>> getDailyChallenges(String userId, String language);
  Future<bool> isGameUnlocked(String userId, String gameId);
  Future<void> completeGameSession({
    required String userId,
    required String gameId,
    required int score,
    required int timeSpent,
    required bool isCompleted,
    Map<String, dynamic>? sessionData,
  });
  Future<List<Map<String, dynamic>>> getGameLeaderboard(
    String gameId, {
    int limit = 10,
    String period = 'all_time',
  });
  Future<int> getUserGameRank(String userId, String gameId);
}

/// Local data source implementation using Hive
class GamesLocalDataSource implements GamesDataSource {
  static const String _gamesBoxName = 'games';
  static const String _gameProgressBoxName = 'game_progress';
  static const String _gameSessionsBoxName = 'game_sessions';

  late Box<GameModel> _gamesBox;
  late Box<GameProgressModel> _gameProgressBox;
  late Box<Map<String, dynamic>> _gameSessionsBox;

  Future<void> initialize() async {
    _gamesBox = await Hive.openBox<GameModel>(_gamesBoxName);
    _gameProgressBox = await Hive.openBox<GameProgressModel>(_gameProgressBoxName);
    _gameSessionsBox = await Hive.openBox<Map<String, dynamic>>(_gameSessionsBoxName);

    // Initialize with sample data if empty
    if (_gamesBox.isEmpty) {
      await _initializeSampleData();
    }
  }

  Future<void> _initializeSampleData() async {
    final now = DateTime.now();

    // Sample memory game
    final memoryCards = [
      const MemoryCard(
        id: 'card_1',
        word: 'Mbolo',
        translation: 'Bonjour',
        audioUrl: 'assets/audio/mbolo.mp3',
      ),
      const MemoryCard(
        id: 'card_2',
        word: 'Akiba',
        translation: 'Merci',
        audioUrl: 'assets/audio/akiba.mp3',
      ),
      const MemoryCard(
        id: 'card_3',
        word: 'Osezeye',
        translation: 'Comment allez-vous',
        audioUrl: 'assets/audio/osezeye.mp3',
      ),
      const MemoryCard(
        id: 'card_4',
        word: 'Mezeye',
        translation: 'Je vais bien',
        audioUrl: 'assets/audio/mezeye.mp3',
      ),
    ];

    final memoryGame = MemoryGameModel(
      id: 'memory_ewondo_basic',
      title: 'Mémoire - Salutations Ewondo',
      description: 'Associez les mots Ewondo avec leur traduction française',
      language: 'ewondo',
      difficulty: GameDifficulty.beginner,
      estimatedDuration: 5,
      thumbnailUrl: 'assets/images/games/memory_game.jpg',
      maxScore: 100,
      gameData: {},
      isPremium: false,
      createdAt: now,
      cards: memoryCards,
      gridSize: 4,
    );

    // Sample word matching game
    final wordPairs = [
      const WordPair(
        id: 'pair_1',
        sourceWord: 'Famille',
        targetWord: 'Ndoán',
        hint: 'Parents, enfants, frères et sœurs',
        audioUrl: 'assets/audio/ndoan.mp3',
      ),
      const WordPair(
        id: 'pair_2',
        sourceWord: 'Maison',
        targetWord: 'Ndá',
        hint: 'Lieu où on habite',
        audioUrl: 'assets/audio/nda.mp3',
      ),
      const WordPair(
        id: 'pair_3',
        sourceWord: 'Eau',
        targetWord: 'Mélim',
        hint: 'Liquide transparent et incolore',
        audioUrl: 'assets/audio/melim.mp3',
      ),
    ];

    final wordMatchingGame = WordMatchingGameModel(
      id: 'matching_ewondo_family',
      title: 'Association - Famille et Maison',
      description: 'Associez les mots français avec leur équivalent Ewondo',
      language: 'ewondo',
      difficulty: GameDifficulty.intermediate,
      estimatedDuration: 10,
      thumbnailUrl: 'assets/images/games/word_matching.jpg',
      maxScore: 150,
      gameData: {},
      isPremium: false,
      createdAt: now,
      wordPairs: wordPairs,
      timeLimit: 120,
    );

    // Sample quiz game
    final quizQuestions = [
      const QuizQuestion(
        id: 'q1',
        question: 'Comment dit-on "Bonjour" en Ewondo ?',
        options: ['Mbolo', 'Akiba', 'Osezeye', 'Mezeye'],
        correctAnswer: 'Mbolo',
        explanation: 'Mbolo est la salutation standard en Ewondo pour dire bonjour.',
        audioUrl: 'assets/audio/mbolo_question.mp3',
      ),
      const QuizQuestion(
        id: 'q2',
        question: 'Que signifie "Akiba" ?',
        options: ['Au revoir', 'Merci', 'Excusez-moi', 'Oui'],
        correctAnswer: 'Merci',
        explanation: 'Akiba est utilisé pour exprimer la gratitude en Ewondo.',
      ),
      const QuizQuestion(
        id: 'q3',
        question: 'Comment demande-t-on "Comment allez-vous ?" en Ewondo ?',
        options: ['Mbolo', 'Osezeye', 'Mezeye', 'Akiba'],
        correctAnswer: 'Osezeye',
        explanation: 'Osezeye est la façon polie de demander comment va quelqu\'un.',
        audioUrl: 'assets/audio/osezeye_question.mp3',
      ),
    ];

    final quizGame = QuizGameModel(
      id: 'quiz_ewondo_basics',
      title: 'Quiz - Bases de l\'Ewondo',
      description: 'Testez vos connaissances des expressions de base en Ewondo',
      language: 'ewondo',
      difficulty: GameDifficulty.beginner,
      estimatedDuration: 8,
      thumbnailUrl: 'assets/images/games/quiz_game.jpg',
      maxScore: 200,
      gameData: {},
      isPremium: false,
      createdAt: now,
      questions: quizQuestions,
      timePerQuestion: 15,
    );

    // Sample word puzzle game
    final wordPuzzles = [
      const WordPuzzle(
        id: 'puzzle_1',
        word: 'MBOLO',
        clue: 'Salutation du matin en Ewondo',
        scrambledLetters: ['M', 'B', 'O', 'L', 'O', 'X', 'Y', 'Z'],
        hint: 'Commence par M',
      ),
      const WordPuzzle(
        id: 'puzzle_2',
        word: 'AKIBA',
        clue: 'Expression de gratitude',
        scrambledLetters: ['A', 'K', 'I', 'B', 'A', 'T', 'R', 'S'],
        hint: 'Commence par A',
      ),
    ];

    final wordPuzzleGame = WordPuzzleGameModel(
      id: 'puzzle_ewondo_words',
      title: 'Puzzle - Mots Ewondo',
      description: 'Reconstituez les mots Ewondo à partir des lettres mélangées',
      language: 'ewondo',
      difficulty: GameDifficulty.intermediate,
      estimatedDuration: 12,
      thumbnailUrl: 'assets/images/games/word_puzzle.jpg',
      maxScore: 180,
      gameData: {},
      isPremium: true,
      createdAt: now,
      puzzles: wordPuzzles,
      hintsAllowed: 3,
    );

    // Sample Bafang games
    final bafangMemoryCards = [
      const MemoryCard(
        id: 'bafang_card_1',
        word: 'Njuè',
        translation: 'Bonjour',
        audioUrl: 'assets/audio/bafang_njue.mp3',
      ),
      const MemoryCard(
        id: 'bafang_card_2',
        word: 'Àsé',
        translation: 'Merci',
        audioUrl: 'assets/audio/bafang_ase.mp3',
      ),
    ];

    final bafangMemoryGame = MemoryGameModel(
      id: 'memory_bafang_basic',
      title: 'Mémoire - Salutations Bafang',
      description: 'Associez les mots Bafang avec leur traduction française',
      language: 'bafang',
      difficulty: GameDifficulty.beginner,
      estimatedDuration: 5,
      thumbnailUrl: 'assets/images/games/bafang_memory.jpg',
      maxScore: 100,
      gameData: {},
      isPremium: false,
      createdAt: now,
      cards: bafangMemoryCards,
      gridSize: 4,
    );

    final sampleGames = [
      memoryGame,
      wordMatchingGame,
      quizGame,
      wordPuzzleGame,
      bafangMemoryGame,
    ];

    for (final game in sampleGames) {
      await _gamesBox.put(game.id, game);
    }
  }

  @override
  Future<List<GameModel>> getGamesByLanguage(String language) async {
    try {
      return _gamesBox.values
          .where((game) => game.language.toLowerCase() == language.toLowerCase())
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to load games by language: $e');
    }
  }

  @override
  Future<List<GameModel>> getGamesByType(GameType type, String language) async {
    try {
      return _gamesBox.values
          .where((game) =>
              game.type == type &&
              game.language.toLowerCase() == language.toLowerCase())
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to load games by type: $e');
    }
  }

  @override
  Future<List<GameModel>> getGamesByDifficulty(GameDifficulty difficulty, String language) async {
    try {
      return _gamesBox.values
          .where((game) =>
              game.difficulty == difficulty &&
              game.language.toLowerCase() == language.toLowerCase())
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to load games by difficulty: $e');
    }
  }

  @override
  Future<GameModel?> getGameById(String gameId) async {
    try {
      return _gamesBox.get(gameId);
    } catch (e) {
      throw CacheFailure('Failed to load game: $e');
    }
  }

  @override
  Future<List<GameModel>> getRecommendedGames(String userId, String language) async {
    try {
      // Get user progress to determine recommendations
      final userProgress = await getUserGameProgress(userId);
      final completedGameIds = userProgress
          .where((p) => p.isCompleted)
          .map((p) => p.gameId)
          .toSet();

      var availableGames = await getGamesByLanguage(language);

      // Filter out completed games
      availableGames = availableGames
          .where((game) => !completedGameIds.contains(game.id))
          .toList();

      // Sort by difficulty and type for better recommendations
      availableGames.sort((a, b) {
        // Prioritize beginner games for new users
        if (userProgress.isEmpty) {
          if (a.difficulty == GameDifficulty.beginner && b.difficulty != GameDifficulty.beginner) {
            return -1;
          } else if (b.difficulty == GameDifficulty.beginner && a.difficulty != GameDifficulty.beginner) {
            return 1;
          }
        }
        return a.difficulty.index.compareTo(b.difficulty.index);
      });

      return availableGames.take(6).toList();
    } catch (e) {
      throw CacheFailure('Failed to get recommended games: $e');
    }
  }

  @override
  Future<List<GameModel>> getPremiumGames(String language) async {
    try {
      return _gamesBox.values
          .where((game) =>
              game.isPremium &&
              game.language.toLowerCase() == language.toLowerCase())
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to load premium games: $e');
    }
  }

  @override
  Future<List<GameModel>> getFreeGames(String language) async {
    try {
      return _gamesBox.values
          .where((game) =>
              !game.isPremium &&
              game.language.toLowerCase() == language.toLowerCase())
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to load free games: $e');
    }
  }

  @override
  Future<GameProgressModel?> getGameProgress(String userId, String gameId) async {
    try {
      final key = '${userId}_$gameId';
      return _gameProgressBox.get(key);
    } catch (e) {
      throw CacheFailure('Failed to get game progress: $e');
    }
  }

  @override
  Future<void> updateGameProgress(GameProgressModel progress) async {
    try {
      final key = '${progress.userId}_${progress.gameId}';
      await _gameProgressBox.put(key, progress);
    } catch (e) {
      throw CacheFailure('Failed to update game progress: $e');
    }
  }

  @override
  Future<List<GameProgressModel>> getUserGameProgress(String userId) async {
    try {
      return _gameProgressBox.values
          .where((progress) => progress.userId == userId)
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to get user game progress: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getGameStatistics(String userId) async {
    try {
      final userProgress = await getUserGameProgress(userId);

      final totalGames = userProgress.length;
      final completedGames = userProgress.where((p) => p.isCompleted).length;
      final totalScore = userProgress.fold<int>(0, (sum, p) => sum + p.bestScore);
      final averageScore = totalGames > 0 ? totalScore / totalGames : 0.0;

      // Calculate streaks and other stats
      final lastPlayedDates = userProgress
          .map((p) => p.lastPlayedAt)
          .toList()
        ..sort((a, b) => b.compareTo(a));

      int currentStreak = 0;
      if (lastPlayedDates.isNotEmpty) {
        final today = DateTime.now();
        final lastPlayed = lastPlayedDates.first;

        if (DateTime(today.year, today.month, today.day) ==
            DateTime(lastPlayed.year, lastPlayed.month, lastPlayed.day)) {
          currentStreak = 1;
          // Calculate consecutive days
          for (int i = 1; i < lastPlayedDates.length; i++) {
            final current = lastPlayedDates[i];
            final previous = lastPlayedDates[i - 1];

            if (previous.difference(current).inDays == 1) {
              currentStreak++;
            } else {
              break;
            }
          }
        }
      }

      return {
        'totalGames': totalGames,
        'completedGames': completedGames,
        'totalScore': totalScore,
        'averageScore': averageScore.round(),
        'currentStreak': currentStreak,
        'completionRate': totalGames > 0 ? (completedGames / totalGames * 100).round() : 0,
      };
    } catch (e) {
      throw CacheFailure('Failed to get game statistics: $e');
    }
  }

  @override
  Future<List<GameModel>> searchGames(String query, {String? language}) async {
    try {
      final lowercaseQuery = query.toLowerCase();

      return _gamesBox.values
          .where((game) {
            final matchesQuery = game.title.toLowerCase().contains(lowercaseQuery) ||
                game.description.toLowerCase().contains(lowercaseQuery);
            final matchesLanguage = language == null ||
                game.language.toLowerCase() == language.toLowerCase();

            return matchesQuery && matchesLanguage;
          })
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to search games: $e');
    }
  }

  @override
  Future<List<GameModel>> getDailyChallenges(String userId, String language) async {
    try {
      // Get user progress to determine appropriate challenges
      final userProgress = await getUserGameProgress(userId);
      final userLevel = userProgress.length > 5 ? GameDifficulty.intermediate : GameDifficulty.beginner;

      final allGames = await getGamesByLanguage(language);

      // Filter games by difficulty and select daily challenges
      final challengeGames = allGames
          .where((game) => game.difficulty == userLevel)
          .take(3)
          .toList();

      return challengeGames;
    } catch (e) {
      throw CacheFailure('Failed to get daily challenges: $e');
    }
  }

  @override
  Future<bool> isGameUnlocked(String userId, String gameId) async {
    try {
      final game = await getGameById(gameId);
      if (game == null) return false;

      // Free games are always unlocked
      if (!game.isPremium) return true;

      // Check if user has premium access (simplified logic)
      // In real implementation, this would check user subscription status
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> completeGameSession({
    required String userId,
    required String gameId,
    required int score,
    required int timeSpent,
    required bool isCompleted,
    Map<String, dynamic>? sessionData,
  }) async {
    try {
      // Update or create game progress
      final existingProgress = await getGameProgress(userId, gameId);
      final now = DateTime.now();

      final updatedProgress = GameProgressModel(
        id: existingProgress?.id ?? '${userId}_${gameId}_${now.millisecondsSinceEpoch}',
        userId: userId,
        gameId: gameId,
        currentScore: score,
        bestScore: existingProgress != null
            ? (score > existingProgress.bestScore ? score : existingProgress.bestScore)
            : score,
        attemptsCount: (existingProgress?.attemptsCount ?? 0) + 1,
        isCompleted: isCompleted || (existingProgress?.isCompleted ?? false),
        lastPlayedAt: now,
        progressData: {
          ...existingProgress?.progressData ?? {},
          'lastSessionScore': score,
          'lastSessionTime': timeSpent,
          'lastSessionCompleted': isCompleted,
          ...sessionData ?? {},
        },
      );

      await updateGameProgress(updatedProgress);

      // Store session details
      final sessionKey = '${userId}_${gameId}_${now.millisecondsSinceEpoch}';
      await _gameSessionsBox.put(sessionKey, {
        'userId': userId,
        'gameId': gameId,
        'score': score,
        'timeSpent': timeSpent,
        'isCompleted': isCompleted,
        'playedAt': now.toIso8601String(),
        'sessionData': sessionData ?? {},
      });
    } catch (e) {
      throw CacheFailure('Failed to complete game session: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGameLeaderboard(
    String gameId, {
    int limit = 10,
    String period = 'all_time',
  }) async {
    try {
      final allProgress = _gameProgressBox.values
          .where((progress) => progress.gameId == gameId)
          .toList();

      // Sort by best score descending
      allProgress.sort((a, b) => b.bestScore.compareTo(a.bestScore));

      // Apply period filter if needed
      List<GameProgressModel> filteredProgress = allProgress;
      if (period != 'all_time') {
        final now = DateTime.now();
        DateTime cutoffDate;

        switch (period) {
          case 'daily':
            cutoffDate = DateTime(now.year, now.month, now.day);
            break;
          case 'weekly':
            cutoffDate = now.subtract(Duration(days: now.weekday - 1));
            break;
          case 'monthly':
            cutoffDate = DateTime(now.year, now.month, 1);
            break;
          default:
            cutoffDate = DateTime(1970); // Very old date for all_time
        }

        filteredProgress = allProgress
            .where((progress) => progress.lastPlayedAt.isAfter(cutoffDate))
            .toList();
      }

      return filteredProgress
          .take(limit)
          .map((progress) => {
                'userId': progress.userId,
                'bestScore': progress.bestScore,
                'attemptsCount': progress.attemptsCount,
                'lastPlayedAt': progress.lastPlayedAt.toIso8601String(),
                'isCompleted': progress.isCompleted,
              })
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to get game leaderboard: $e');
    }
  }

  @override
  Future<int> getUserGameRank(String userId, String gameId) async {
    try {
      final leaderboard = await getGameLeaderboard(gameId, limit: 1000);

      for (int i = 0; i < leaderboard.length; i++) {
        if (leaderboard[i]['userId'] == userId) {
          return i + 1; // Rank is 1-based
        }
      }

      return 0; // User not found or hasn't played
    } catch (e) {
      throw CacheFailure('Failed to get user game rank: $e');
    }
  }
}