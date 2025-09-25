import '../../domain/entities/course.dart';

/// Course model for data serialization
class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.language,
    required super.level,
    required super.totalLessons,
    required super.completedLessons,
    required super.imageUrl,
    required super.tags,
    required super.isPremium,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create CourseModel from JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      language: json['language'] as String,
      level: json['level'] as String,
      totalLessons: json['totalLessons'] as int,
      completedLessons: json['completedLessons'] as int,
      imageUrl: json['imageUrl'] as String,
      tags: List<String>.from(json['tags'] as List),
      isPremium: json['isPremium'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert CourseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'language': language,
      'level': level,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'imageUrl': imageUrl,
      'tags': tags,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create CourseModel from Course entity
  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      language: course.language,
      level: course.level,
      totalLessons: course.totalLessons,
      completedLessons: course.completedLessons,
      imageUrl: course.imageUrl,
      tags: course.tags,
      isPremium: course.isPremium,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
    );
  }

  /// Convert to Course entity
  Course toEntity() {
    return Course(
      id: id,
      title: title,
      description: description,
      language: language,
      level: level,
      totalLessons: totalLessons,
      completedLessons: completedLessons,
      imageUrl: imageUrl,
      tags: tags,
      isPremium: isPremium,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
