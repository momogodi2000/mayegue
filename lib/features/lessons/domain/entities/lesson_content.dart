import 'package:equatable/equatable.dart';

/// LessonContent entity representing different types of content within a lesson
class LessonContent extends Equatable {
  final String id;
  final String lessonId;
  final ContentType type;
  final String title;
  final String content; // text content or URL/path for media
  final int order;
  final Map<String, dynamic>? metadata; // additional data like duration, size, etc.
  final DateTime createdAt;

  const LessonContent({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.title,
    required this.content,
    required this.order,
    this.metadata,
    required this.createdAt,
  });

  /// Create a copy with updated fields
  LessonContent copyWith({
    String? id,
    String? lessonId,
    ContentType? type,
    String? title,
    String? content,
    int? order,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return LessonContent(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        lessonId,
        type,
        title,
        content,
        order,
        metadata,
        createdAt,
      ];
}

/// Enum for content types
enum ContentType {
  text, // Plain text content
  phonetic, // Phonetic transcription
  audio, // Audio file
  video, // Video file
  image, // Image file
  interactive, // Interactive content (quiz, exercise, etc.)
  document, // PDF or document file
}
