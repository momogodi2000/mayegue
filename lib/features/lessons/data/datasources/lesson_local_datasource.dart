import 'package:hive/hive.dart';
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
}

/// Local data source implementation using Hive
class LessonLocalDataSource implements LessonDataSource {
  static const String _lessonsBoxName = 'lessons';
  static const String _lessonContentsBoxName = 'lesson_contents';

  late Box<LessonModel> _lessonsBox;
  late Box<List<LessonContentModel>> _lessonContentsBox;

  Future<void> initialize() async {
    _lessonsBox = await Hive.openBox<LessonModel>(_lessonsBoxName);
    _lessonContentsBox = await Hive.openBox<List<LessonContentModel>>(_lessonContentsBoxName);

    // Initialize with sample data if empty
    if (_lessonsBox.isEmpty) {
      await _initializeSampleData();
    }
  }

  Future<void> _initializeSampleData() async {
    final now = DateTime.now();

    // Sample lesson contents
    final ewondoBasicsContents1 = [
      LessonContentModel(
        id: 'ewondo-greetings-1',
        lessonId: 'ewondo-lesson-1',
        type: ContentType.text,
        title: 'Salutations de base',
        content: 'Bonjour se dit "Mbolo" en Ewondo.\nComment allez-vous ? se dit "Osezeye ?"\nJe vais bien se dit "Mezeye".',
        order: 1,
        createdAt: now,
      ),
      LessonContentModel(
        id: 'ewondo-greetings-2',
        lessonId: 'ewondo-lesson-1',
        type: ContentType.audio,
        title: 'Écoutez la prononciation',
        content: 'assets/audio/ewondo_greetings.mp3',
        order: 2,
        metadata: {'duration': 45},
        createdAt: now,
      ),
    ];

    final ewondoBasicsContents2 = [
      LessonContentModel(
        id: 'ewondo-numbers-1',
        lessonId: 'ewondo-lesson-2',
        type: ContentType.text,
        title: 'Les chiffres de 1 à 10',
        content: '1 = Óse\n2 = Ibá\n3 = Ilá\n4 = Iné\n5 = Itán\n6 = Isám\n7 = Indám\n8 = Imóm\n9 = Ibwóm\n10 = Awóm',
        order: 1,
        createdAt: now,
      ),
    ];

    // Sample lessons
    final sampleLessons = [
      LessonModel(
        id: 'ewondo-lesson-1',
        courseId: 'ewondo-basics-1',
        title: 'Salutations et présentations',
        description: 'Apprenez les salutations de base et comment vous présenter en Ewondo.',
        order: 1,
        type: LessonType.text,
        status: LessonStatus.available,
        estimatedDuration: 15,
        thumbnailUrl: 'assets/images/lessons/greetings.jpg',
        contents: ewondoBasicsContents1,
        createdAt: now,
        updatedAt: now,
      ),
      LessonModel(
        id: 'ewondo-lesson-2',
        courseId: 'ewondo-basics-1',
        title: 'Les chiffres',
        description: 'Maîtrisez les chiffres de 1 à 10 en Ewondo.',
        order: 2,
        type: LessonType.interactive,
        status: LessonStatus.locked,
        estimatedDuration: 20,
        thumbnailUrl: 'assets/images/lessons/numbers.jpg',
        contents: ewondoBasicsContents2,
        createdAt: now,
        updatedAt: now,
      ),
      LessonModel(
        id: 'bafang-lesson-1',
        courseId: 'bafang-basics-1',
        title: 'Introduction au Bafang',
        description: 'Découvrez les bases de la langue Bafang.',
        order: 1,
        type: LessonType.text,
        status: LessonStatus.available,
        estimatedDuration: 10,
        thumbnailUrl: 'assets/images/lessons/bafang_intro.jpg',
        contents: [],
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final lesson in sampleLessons) {
      await _lessonsBox.put(lesson.id, lesson);
      if (lesson.contents.isNotEmpty) {
        await _lessonContentsBox.put(lesson.id, lesson.contents as List<LessonContentModel>);
      }
    }
  }

  @override
  Future<List<LessonModel>> getLessonsByCourse(String courseId) async {
    try {
      return _lessonsBox.values
          .where((lesson) => lesson.courseId == courseId)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      throw CacheFailure('Failed to load lessons by course: $e');
    }
  }

  @override
  Future<LessonModel> getLessonById(String lessonId) async {
    try {
      final lesson = _lessonsBox.get(lessonId);
      if (lesson == null) {
        throw CacheFailure('Lesson not found: $lessonId');
      }

      // Load contents
      final contents = _lessonContentsBox.get(lessonId) ?? [];
      return LessonModel(
        id: lesson.id,
        courseId: lesson.courseId,
        title: lesson.title,
        description: lesson.description,
        order: lesson.order,
        type: lesson.type,
        status: lesson.status,
        estimatedDuration: lesson.estimatedDuration,
        thumbnailUrl: lesson.thumbnailUrl,
        contents: contents,
        createdAt: lesson.createdAt,
        updatedAt: lesson.updatedAt,
      );
    } catch (e) {
      throw CacheFailure('Failed to load lesson: $e');
    }
  }

  @override
  Future<LessonModel?> getNextLesson(String courseId, int currentOrder) async {
    try {
      final courseLessons = await getLessonsByCourse(courseId);
      final nextLesson = courseLessons
          .where((lesson) => lesson.order > currentOrder)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      return nextLesson.isNotEmpty ? nextLesson.first : null;
    } catch (e) {
      throw CacheFailure('Failed to get next lesson: $e');
    }
  }

  @override
  Future<LessonModel?> getPreviousLesson(String courseId, int currentOrder) async {
    try {
      final courseLessons = await getLessonsByCourse(courseId);
      final previousLesson = courseLessons
          .where((lesson) => lesson.order < currentOrder)
          .toList()
        ..sort((a, b) => b.order.compareTo(a.order));

      return previousLesson.isNotEmpty ? previousLesson.first : null;
    } catch (e) {
      throw CacheFailure('Failed to get previous lesson: $e');
    }
  }

  @override
  Future<bool> updateLessonStatus(String lessonId, LessonStatus status) async {
    try {
      final lesson = _lessonsBox.get(lessonId);
      if (lesson == null) {
        throw CacheFailure('Lesson not found: $lessonId');
      }

      final updatedLesson = LessonModel(
        id: lesson.id,
        courseId: lesson.courseId,
        title: lesson.title,
        description: lesson.description,
        order: lesson.order,
        type: lesson.type,
        status: status,
        estimatedDuration: lesson.estimatedDuration,
        thumbnailUrl: lesson.thumbnailUrl,
        contents: lesson.contents,
        createdAt: lesson.createdAt,
        updatedAt: DateTime.now(),
      );

      await _lessonsBox.put(lessonId, updatedLesson);
      return true;
    } catch (e) {
      throw CacheFailure('Failed to update lesson status: $e');
    }
  }

  @override
  Future<bool> completeLesson(String lessonId) async {
    return await updateLessonStatus(lessonId, LessonStatus.completed);
  }

  @override
  Future<bool> resetLesson(String lessonId) async {
    return await updateLessonStatus(lessonId, LessonStatus.available);
  }
}
