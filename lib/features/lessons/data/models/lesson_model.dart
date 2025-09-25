import '../../domain/entities/lesson.dart';
import 'lesson_content_model.dart';

/// Lesson model for data serialization
class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    required super.order,
    required super.type,
    required super.status,
    required super.estimatedDuration,
    required super.thumbnailUrl,
    required super.contents,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create LessonModel from JSON
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      type: LessonType.values[json['type'] as int],
      status: LessonStatus.values[json['status'] as int],
      estimatedDuration: json['estimatedDuration'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String,
      contents: (json['contents'] as List)
          .map((content) => LessonContentModel.fromJson(content as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert LessonModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'order': order,
      'type': type.index,
      'status': status.index,
      'estimatedDuration': estimatedDuration,
      'thumbnailUrl': thumbnailUrl,
      'contents': contents.map((content) => (content as LessonContentModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create LessonModel from Lesson entity
  factory LessonModel.fromEntity(Lesson lesson) {
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
      contents: lesson.contents,
      createdAt: lesson.createdAt,
      updatedAt: lesson.updatedAt,
    );
  }

  /// Convert to Lesson entity
  Lesson toEntity() {
    return Lesson(
      id: id,
      courseId: courseId,
      title: title,
      description: description,
      order: order,
      type: type,
      status: status,
      estimatedDuration: estimatedDuration,
      thumbnailUrl: thumbnailUrl,
      contents: contents,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
