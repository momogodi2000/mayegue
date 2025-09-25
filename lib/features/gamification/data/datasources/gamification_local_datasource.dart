import 'package:hive/hive.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/gamification.dart';
import '../models/user_progress_model.dart';
import '../models/achievement_model.dart';
import 'gamification_datasource.dart';

/// Local data source implementation using Hive
class GamificationLocalDataSource implements GamificationDataSource {
  static const String _userProgressBoxName = 'user_progress';
  static const String _achievementsBoxName = 'achievements';

  late Box<UserProgressModel> _userProgressBox;
  late Box<AchievementModel> _achievementsBox;

  Future<void> initialize() async {
    _userProgressBox = await Hive.openBox<UserProgressModel>(_userProgressBoxName);
    _achievementsBox = await Hive.openBox<AchievementModel>(_achievementsBoxName);

    // Initialize with sample data if empty
    if (_achievementsBox.isEmpty) {
      await _initializeAchievements();
    }
  }

  Future<void> _initializeAchievements() async {
    final achievements = _getDefaultAchievements();
    for (final achievement in achievements) {
      await _achievementsBox.put(achievement.id, achievement);
    }
  }

  List<AchievementModel> _getDefaultAchievements() {
    return [
      // Learning achievements
      const AchievementModel(
        id: 'first_lesson',
        title: 'Premier pas',
        description: 'Complétez votre première leçon',
        iconName: 'school',
        type: AchievementType.lessonCompletion,
        pointsReward: 10,
        criteria: {'lessons_completed': 1},
        isUnlocked: false,
        unlockedAt: null,
      ),
      const AchievementModel(
        id: 'lesson_master',
        title: 'Maître des leçons',
        description: 'Complétez 10 leçons',
        iconName: 'local_library',
        type: AchievementType.lessonCompletion,
        pointsReward: 50,
        criteria: {'lessons_completed': 10},
        isUnlocked: false,
        unlockedAt: null,
      ),
      const AchievementModel(
        id: 'course_champion',
        title: 'Champion de cours',
        description: 'Terminez votre premier cours complet',
        iconName: 'emoji_events',
        type: AchievementType.courseCompletion,
        pointsReward: 100,
        criteria: {'courses_completed': 1},
        isUnlocked: false,
        unlockedAt: null,
      ),

      // Streak achievements
      const AchievementModel(
        id: 'streak_beginner',
        title: 'Débutant assidu',
        description: 'Maintenez une série de 3 jours',
        iconName: 'local_fire_department',
        type: AchievementType.streak,
        pointsReward: 15,
        criteria: {'streak_days': 3},
        isUnlocked: false,
        unlockedAt: null,
      ),
      const AchievementModel(
        id: 'streak_warrior',
        title: 'Guerrier de la série',
        description: 'Maintenez une série de 7 jours',
        iconName: 'whatshot',
        type: AchievementType.streak,
        pointsReward: 30,
        criteria: {'streak_days': 7},
        isUnlocked: false,
        unlockedAt: null,
      ),
      const AchievementModel(
        id: 'streak_legend',
        title: 'Légende de la série',
        description: 'Maintenez une série de 30 jours',
        iconName: 'local_fire_department',
        type: AchievementType.streak,
        pointsReward: 100,
        criteria: {'streak_days': 30},
        isUnlocked: false,
        unlockedAt: null,
      ),

      // Points milestones
      const AchievementModel(
        id: 'points_100',
        title: 'Centurion',
        description: 'Accumulez 100 points',
        iconName: 'stars',
        type: AchievementType.pointsMilestone,
        pointsReward: 25,
        criteria: {'total_points': 100},
        isUnlocked: false,
        unlockedAt: null,
      ),
      const AchievementModel(
        id: 'points_500',
        title: 'Maître des points',
        description: 'Accumulez 500 points',
        iconName: 'workspace_premium',
        type: AchievementType.pointsMilestone,
        pointsReward: 50,
        criteria: {'total_points': 500},
        isUnlocked: false,
        unlockedAt: null,
      ),
    ];
  }

  @override
  Future<UserProgress> getUserProgress(String userId) async {
    try {
      final progressModel = _userProgressBox.get(userId);
      if (progressModel == null) {
        // Create default progress for new user
        final defaultProgress = UserProgressModel(
          userId: userId,
          totalPoints: 0,
          currentLevel: 1,
          experiencePoints: 0,
          pointsToNextLevel: 100,
          earnedBadges: const [],
          achievements: const [],
          lessonsCompleted: 0,
          coursesCompleted: 0,
          streakDays: 0,
          lastActivityDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _userProgressBox.put(userId, defaultProgress);
        return defaultProgress.toEntity();
      }
      return progressModel.toEntity();
    } catch (e) {
      throw CacheFailure('Failed to get user progress: $e');
    }
  }

  @override
  Future<UserProgress> updateUserProgress(String userId, UserProgress progress) async {
    try {
      final progressModel = UserProgressModel.fromEntity(progress);
      await _userProgressBox.put(userId, progressModel);
      return progress;
    } catch (e) {
      throw CacheFailure('Failed to update user progress: $e');
    }
  }

  @override
  Future<UserProgress> addPoints(String userId, int points, PointActivity activity) async {
    try {
      final currentProgress = await getUserProgress(userId);

      final newTotalPoints = currentProgress.totalPoints + points;
      final newExperiencePoints = currentProgress.experiencePoints + points;

      // Calculate new level
      int newLevel = currentProgress.currentLevel;
      int pointsToNextLevel = currentProgress.pointsToNextLevel;

      while (newExperiencePoints >= pointsToNextLevel) {
        newLevel++;
        pointsToNextLevel = _calculatePointsForLevel(newLevel + 1);
      }

      final updatedProgress = currentProgress.copyWith(
        totalPoints: newTotalPoints,
        currentLevel: newLevel,
        experiencePoints: newExperiencePoints,
        pointsToNextLevel: pointsToNextLevel,
        lastActivityDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return await updateUserProgress(userId, updatedProgress);
    } catch (e) {
      throw CacheFailure('Failed to add points: $e');
    }
  }

  int _calculatePointsForLevel(int level) {
    // Exponential growth: level 1 = 100, level 2 = 200, level 3 = 350, etc.
    return (level * 100) + ((level - 1) * level * 25);
  }

  @override
  Future<Achievement> awardAchievement(String userId, String achievementId) async {
    try {
      final achievementModel = _achievementsBox.get(achievementId);
      if (achievementModel == null) {
        throw CacheFailure('Achievement not found: $achievementId');
      }

      final unlockedAchievement = AchievementModel(
        id: achievementModel.id,
        title: achievementModel.title,
        description: achievementModel.description,
        iconName: achievementModel.iconName,
        type: achievementModel.type,
        pointsReward: achievementModel.pointsReward,
        criteria: achievementModel.criteria,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );

      await _achievementsBox.put(achievementId, unlockedAchievement);

      // Update user progress
      final userProgress = await getUserProgress(userId);
      final updatedAchievements = List<Achievement>.from(userProgress.achievements)
        ..add(unlockedAchievement);

      final updatedProgress = userProgress.copyWith(
        achievements: updatedAchievements,
        totalPoints: userProgress.totalPoints + unlockedAchievement.pointsReward,
        updatedAt: DateTime.now(),
      );

      await updateUserProgress(userId, updatedProgress);

      return unlockedAchievement;
    } catch (e) {
      throw CacheFailure('Failed to award achievement: $e');
    }
  }

  @override
  Future<List<Achievement>> getAvailableAchievements() async {
    try {
      final achievements = _achievementsBox.values.map((model) => model.toEntity()).toList();
      return achievements;
    } catch (e) {
      throw CacheFailure('Failed to get available achievements: $e');
    }
  }

  @override
  Future<List<Achievement>> getUserAchievements(String userId) async {
    try {
      final userProgress = await getUserProgress(userId);
      return userProgress.achievements;
    } catch (e) {
      throw CacheFailure('Failed to get user achievements: $e');
    }
  }

  @override
  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 50, String? language}) async {
    try {
      final allProgress = _userProgressBox.values.map((model) => model.toEntity()).toList();

      // Sort by total points descending
      allProgress.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      final leaderboard = <LeaderboardEntry>[];
      for (int i = 0; i < allProgress.length && i < limit; i++) {
        final progress = allProgress[i];
        leaderboard.add(LeaderboardEntry(
          userId: progress.userId,
          userName: 'Utilisateur ${progress.userId.substring(0, 8)}', // Placeholder
          userAvatar: '', // Placeholder
          totalPoints: progress.totalPoints,
          currentLevel: progress.currentLevel,
          rank: i + 1,
        ));
      }

      return leaderboard;
    } catch (e) {
      throw CacheFailure('Failed to get leaderboard: $e');
    }
  }

  @override
  Future<int> getUserRank(String userId) async {
    try {
      final leaderboard = await getLeaderboard(limit: 1000);
      final userEntry = leaderboard.where((entry) => entry.userId == userId).firstOrNull;
      return userEntry?.rank ?? 0;
    } catch (e) {
      throw CacheFailure('Failed to get user rank: $e');
    }
  }

  @override
  Future<List<Achievement>> checkAndUnlockAchievements(String userId) async {
    try {
      final userProgress = await getUserProgress(userId);
      final availableAchievements = await getAvailableAchievements();
      final unlockedAchievements = <Achievement>[];

      for (final achievement in availableAchievements) {
        if (achievement.isUnlocked) continue;

        bool shouldUnlock = false;

        switch (achievement.type) {
          case AchievementType.lessonCompletion:
            final required = achievement.criteria['lessons_completed'] as int? ?? 0;
            shouldUnlock = userProgress.lessonsCompleted >= required;
            break;

          case AchievementType.courseCompletion:
            final required = achievement.criteria['courses_completed'] as int? ?? 0;
            shouldUnlock = userProgress.coursesCompleted >= required;
            break;

          case AchievementType.streak:
            final required = achievement.criteria['streak_days'] as int? ?? 0;
            shouldUnlock = userProgress.streakDays >= required;
            break;

          case AchievementType.pointsMilestone:
            final required = achievement.criteria['total_points'] as int? ?? 0;
            shouldUnlock = userProgress.totalPoints >= required;
            break;

          default:
            shouldUnlock = false;
        }

        if (shouldUnlock) {
          final unlocked = await awardAchievement(userId, achievement.id);
          unlockedAchievements.add(unlocked);
        }
      }

      return unlockedAchievements;
    } catch (e) {
      throw CacheFailure('Failed to check and unlock achievements: $e');
    }
  }

  @override
  Future<UserProgress> updateDailyStreak(String userId) async {
    try {
      final userProgress = await getUserProgress(userId);
      final now = DateTime.now();
      final lastActivity = userProgress.lastActivityDate;
      final difference = now.difference(lastActivity).inDays;

      int newStreak = userProgress.streakDays;

      if (difference == 1) {
        // Consecutive day
        newStreak++;
      } else if (difference > 1) {
        // Streak broken
        newStreak = 1;
      }
      // If difference == 0, same day, keep current streak

      final updatedProgress = userProgress.copyWith(
        streakDays: newStreak,
        lastActivityDate: now,
        updatedAt: now,
      );

      return await updateUserProgress(userId, updatedProgress);
    } catch (e) {
      throw CacheFailure('Failed to update daily streak: $e');
    }
  }
}
