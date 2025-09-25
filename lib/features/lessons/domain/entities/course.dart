import 'package:equatable/equatable.dart';

/// Course entity representing a language learning course
class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String language;
  final String level; // beginner, intermediate, advanced
  final int totalLessons;
  final int completedLessons;
  final String imageUrl;
  final List<String> tags;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.level,
    required this.totalLessons,
    required this.completedLessons,
    required this.imageUrl,
    required this.tags,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate completion percentage
  double get completionPercentage {
    if (totalLessons == 0) return 0.0;
    return (completedLessons / totalLessons) * 100;
  }

  /// Check if course is completed
  bool get isCompleted => completedLessons >= totalLessons;

  /// Create a copy with updated fields
  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? language,
    String? level,
    int? totalLessons,
    int? completedLessons,
    String? imageUrl,
    List<String>? tags,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      language: language ?? this.language,
      level: level ?? this.level,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        language,
        level,
        totalLessons,
        completedLessons,
        imageUrl,
        tags,
        isPremium,
        createdAt,
        updatedAt,
      ];
}
