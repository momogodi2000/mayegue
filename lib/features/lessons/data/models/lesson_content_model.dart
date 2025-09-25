import '../../domain/entities/lesson_content.dart';

/// LessonContent model for data serialization
class LessonContentModel extends LessonContent {
  const LessonContentModel({
    required super.id,
    required super.lessonId,
    required super.type,
    required super.title,
    required super.content,
    required super.order,
    super.metadata,
    required super.createdAt,
  });

  /// Create LessonContentModel from JSON
  factory LessonContentModel.fromJson(Map<String, dynamic> json) {
    return LessonContentModel(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      type: ContentType.values[json['type'] as int],
      title: json['title'] as String,
      content: json['content'] as String,
      order: json['order'] as int,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert LessonContentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'type': type.index,
      'title': title,
      'content': content,
      'order': order,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create LessonContentModel from LessonContent entity
  factory LessonContentModel.fromEntity(LessonContent content) {
    return LessonContentModel(
      id: content.id,
      lessonId: content.lessonId,
      type: content.type,
      title: content.title,
      content: content.content,
      order: content.order,
      metadata: content.metadata,
      createdAt: content.createdAt,
    );
  }

  /// Convert to LessonContent entity
  LessonContent toEntity() {
    return LessonContent(
      id: id,
      lessonId: lessonId,
      type: type,
      title: title,
      content: content,
      order: order,
      metadata: metadata,
      createdAt: createdAt,
    );
  }
}
