import '../../../../core/database/cameroon_languages_database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_content.dart';
import '../models/lesson_model.dart';
import '../models/lesson_content_model.dart';
/// Abstract data source for lesson operations
abstract class LessonDataSource {
  Future<List<LessonModel>> getLessonsByCourse(String courseId);
  Future<LessonModel> getLessonById(String lessonId);
  Future<LessonModel?> getNextLesson(String courseId, int currentOrder);
  Future<LessonModel?> getPreviousLesson(String courseId, int currentOrder);
  Future<bool> updateLessonStatus(String lessonId, LessonStatus status);
  Future<bool> completeLesson(String lessonId);
  Future<bool> resetLesson(String lessonId);
  Future<LessonModel> createLesson(LessonModel lesson);
  Future<LessonModel> updateLesson(String lessonId, LessonModel lesson);
  Future<bool> deleteLesson(String lessonId);
}
/// Local data source implementation using SQLite
class LessonLocalDataSource implements LessonDataSource {
  Future<void> initialize() async {
    // SQLite initialization is handled by DatabaseHelper
    // No additional initialization needed for this data source
  }

  @override
  Future<List<LessonModel>> getLessonsByCourse(String courseId) async {
    try {
      // courseId maps to language_id in the database
      final lessonsData = await CameroonLanguagesDatabaseHelper.getLessonsByLanguage(courseId);
      return lessonsData.map((data) => _mapDbToLessonModel(data)).toList();
    } catch (e) {
      throw CacheFailure('Failed to get lessons: $e');
    }
  }
  @override
  Future<LessonModel> getLessonById(String lessonId) async {
    try {
      final lessonData = await CameroonLanguagesDatabaseHelper.getLessonById(int.parse(lessonId));
      if (lessonData == null) {
        throw CacheFailure('Lesson not found: $lessonId');
      }
      return _mapDbToLessonModel(lessonData);
    } catch (e) {
      throw CacheFailure('Failed to get lesson: $e');
    }
  }
  @override
  Future<LessonModel?> getNextLesson(String courseId, int currentOrder) async {
    try {
      final allLessons = await getLessonsByCourse(courseId);
      final nextLessons = allLessons.where((lesson) => lesson.order > currentOrder);
      if (nextLessons.isEmpty) return null;
      return nextLessons.reduce((a, b) => a.order < b.order ? a : b);
    } catch (e) {
      throw CacheFailure('Failed to get next lesson: $e');
    }
  }
  @override
  Future<LessonModel?> getPreviousLesson(String courseId, int currentOrder) async {
    try {
      final allLessons = await getLessonsByCourse(courseId);
      final prevLessons = allLessons.where((lesson) => lesson.order < currentOrder);
      if (prevLessons.isEmpty) return null;
      return prevLessons.reduce((a, b) => a.order > b.order ? a : b);
    } catch (e) {
      throw CacheFailure('Failed to get previous lesson: $e');
    }
  }
  @override
  Future<bool> updateLessonStatus(String lessonId, LessonStatus status) async {
    // User progress is stored in Firebase, not SQLite
    // This is a placeholder for compatibility - progress tracking happens at app level
    return true;
  }
  @override
  Future<bool> completeLesson(String lessonId) async {
    // User progress is stored in Firebase, not SQLite
    // This is a placeholder for compatibility - progress tracking happens at app level
    return true;
  }
  @override
  Future<bool> resetLesson(String lessonId) async {
    // User progress is stored in Firebase, not SQLite
    // This is a placeholder for compatibility - progress tracking happens at app level
    return true;
  }
  @override
  Future<LessonModel> createLesson(LessonModel lesson) async {
    // SQLite database is read-only for lessons - they come from the seed data
    // This is a placeholder for compatibility
    throw CacheFailure('Cannot create lessons in read-only database');
  }
  @override
  Future<LessonModel> updateLesson(String lessonId, LessonModel lesson) async {
    // SQLite database is read-only for lessons - they come from the seed data
    // This is a placeholder for compatibility
    throw CacheFailure('Cannot update lessons in read-only database');
  }
  @override
  Future<bool> deleteLesson(String lessonId) async {
    // SQLite database is read-only for lessons - they come from the seed data
    // This is a placeholder for compatibility
    throw CacheFailure('Cannot delete lessons in read-only database');
  }
  /// Map database row to LessonModel
  LessonModel _mapDbToLessonModel(Map<String, dynamic> data) {
    final lessonId = data['lesson_id']?.toString() ?? 'unknown';
    final languageId = data['language_id'] as String? ?? 'unknown';
    final title = data['title'] as String? ?? 'Untitled Lesson';
    final content = data['content'] as String? ?? '';
    final level = data['level'] as String? ?? 'beginner';
    final orderIndex = data['order_index'] as int? ?? 0;
    final audioUrl = data['audio_url'] as String?;
    final videoUrl = data['video_url'] as String?;
    final createdDate = data['created_date'] as String?;
    // Map level to LessonType
    LessonType lessonType;
    switch (level.toLowerCase()) {
      case 'beginner':
        lessonType = LessonType.text;
        break;
      case 'intermediate':
        lessonType = LessonType.interactive;
        break;
      case 'advanced':
        lessonType = LessonType.quiz;
        break;
      default:
        lessonType = LessonType.text;
    }
    // Create lesson contents from the content field
    final contents = <LessonContentModel>[];
    // Parse content into different content types
    if (content.isNotEmpty) {
      // Add text content
      contents.add(LessonContentModel(
        id: '${lessonId}_text',
        lessonId: lessonId,
        type: ContentType.text,
        title: 'Contenu de la leçon',
        content: content,
        order: 1,
        createdAt: createdDate != null ? DateTime.parse(createdDate) : DateTime.now(),
      ));
      // Add audio content if available
      if (audioUrl != null && audioUrl.isNotEmpty) {
        contents.add(LessonContentModel(
          id: '${lessonId}_audio',
          lessonId: lessonId,
          type: ContentType.audio,
          title: 'Audio de la leçon',
          content: audioUrl,
          order: 2,
          metadata: const {'duration': 300}, // Default 5 minutes
          createdAt: createdDate != null ? DateTime.parse(createdDate) : DateTime.now(),
        ));
      }
      // Add video content if available
      if (videoUrl != null && videoUrl.isNotEmpty) {
        contents.add(LessonContentModel(
          id: '${lessonId}_video',
          lessonId: lessonId,
          type: ContentType.video,
          title: 'Vidéo de la leçon',
          content: videoUrl,
          order: 3,
          createdAt: createdDate != null ? DateTime.parse(createdDate) : DateTime.now(),
        ));
      }
    }
    return LessonModel(
      id: lessonId,
      courseId: languageId, // courseId maps to language_id
      title: title,
      description: _generateDescription(content, level),
      order: orderIndex,
      type: lessonType,
      status: LessonStatus.available, // All lessons are available by default
      estimatedDuration: _calculateEstimatedDuration(content, audioUrl, videoUrl),
      thumbnailUrl: _generateThumbnailUrl(languageId, level),
      contents: contents,
      createdAt: createdDate != null ? DateTime.parse(createdDate) : DateTime.now(),
      updatedAt: createdDate != null ? DateTime.parse(createdDate) : DateTime.now(),
    );
  }
  /// Generate description from content and level
  String _generateDescription(String content, String level) {
    String levelText;
    switch (level.toLowerCase()) {
      case 'beginner':
        levelText = 'Débutant';
        break;
      case 'intermediate':
        levelText = 'Intermédiaire';
        break;
      case 'advanced':
        levelText = 'Avancé';
        break;
      default:
        levelText = 'Tous niveaux';
    }
    if (content.length > 100) {
      return '${content.substring(0, 100)}... (Niveau: $levelText)';
    }
    return '$content (Niveau: $levelText)';
  }
  /// Calculate estimated duration based on content
  int _calculateEstimatedDuration(String content, String? audioUrl, String? videoUrl) {
    int duration = 10; // Base duration in minutes
    // Add time for text content (roughly 200 words per minute reading time)
    final wordCount = content.split(' ').length;
    duration += (wordCount / 200).ceil();
    // Add time for audio content
    if (audioUrl != null && audioUrl.isNotEmpty) {
      duration += 5; // Assume 5 minutes for audio
    }
    // Add time for video content
    if (videoUrl != null && videoUrl.isNotEmpty) {
      duration += 10; // Assume 10 minutes for video
    }
    return duration;
  }
  /// Generate thumbnail URL based on language and level
  String _generateThumbnailUrl(String languageId, String level) {
    String levelSuffix;
    switch (level.toLowerCase()) {
      case 'beginner':
        levelSuffix = 'beginner';
        break;
      case 'intermediate':
        levelSuffix = 'intermediate';
        break;
      case 'advanced':
        levelSuffix = 'advanced';
        break;
      default:
        levelSuffix = 'general';
    }
    return 'assets/images/lessons/${languageId.toLowerCase()}_${levelSuffix}.jpg';
  }
}
