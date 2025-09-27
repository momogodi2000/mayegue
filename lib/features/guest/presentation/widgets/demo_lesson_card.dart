import 'package:flutter/material.dart';
import '../../../../features/lessons/domain/entities/lesson_entity.dart';
import '../../../../shared/themes/colors.dart';

/// Card widget for showcasing a demo lesson in the guest dashboard
class DemoLessonCard extends StatelessWidget {
  final LessonEntity lesson;
  final VoidCallback onTap;

  const DemoLessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Lesson icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getLessonColor(lesson.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getLessonIcon(lesson.category),
                  color: _getLessonColor(lesson.category),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Lesson details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      lesson.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Metadata
                    Row(
                      children: [
                        // Difficulty
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(lesson.difficulty),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lesson.difficulty,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Duration
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.duration} min',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),

                        const SizedBox(width: 12),

                        // Category
                        Text(
                          lesson.category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLessonColor(String category) {
    switch (category.toLowerCase()) {
      case 'basics':
        return Colors.green;
      case 'vocabulary':
        return Colors.blue;
      case 'grammar':
        return Colors.purple;
      case 'conversation':
        return Colors.orange;
      case 'culture':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  IconData _getLessonIcon(String category) {
    switch (category.toLowerCase()) {
      case 'basics':
        return Icons.school;
      case 'vocabulary':
        return Icons.book;
      case 'grammar':
        return Icons.text_fields;
      case 'conversation':
        return Icons.chat;
      case 'culture':
        return Icons.celebration;
      default:
        return Icons.play_lesson;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
      case 'débutant':
        return Colors.green;
      case 'intermediate':
      case 'intermédiaire':
        return Colors.orange;
      case 'advanced':
      case 'avancé':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}