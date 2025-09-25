import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_content.dart';
import '../viewmodels/lessons_viewmodel.dart';

class LessonsView extends StatefulWidget {
  final String courseId;

  const LessonsView({super.key, required this.courseId});

  @override
  State<LessonsView> createState() => _LessonsViewState();
}

class _LessonsViewState extends State<LessonsView> {
  @override
  void initState() {
    super.initState();
    // Load lessons when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonsViewModel>().loadLessons(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LessonsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leçons'),
        actions: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${viewModel.completedLessonsCount}/${viewModel.lessons.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.loadLessons(widget.courseId),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _buildLessonsList(viewModel),
      bottomNavigationBar: viewModel.currentLesson != null
          ? _buildLessonNavigation(viewModel)
          : null,
    );
  }

  Widget _buildLessonsList(LessonsViewModel viewModel) {
    final lessons = viewModel.lessons;

    if (lessons.isEmpty) {
      return const Center(
        child: Text('Aucune leçon disponible'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isAccessible = viewModel.isLessonAccessible(lesson);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: isAccessible
                ? () {
                    viewModel.setCurrentLesson(lesson);
                    _showLessonContent(context, lesson);
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Lesson number/status
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lesson.isCompleted
                          ? Colors.green
                          : isAccessible
                              ? Colors.blue
                              : Colors.grey,
                    ),
                    child: Center(
                      child: lesson.isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : Text(
                              '${lesson.order}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Lesson info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isAccessible ? Colors.black : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isAccessible ? Colors.grey[600] : Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildLessonTypeChip(lesson.type),
                            const SizedBox(width: 8),
                            Text(
                              '${lesson.estimatedDuration} min',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Lock icon for inaccessible lessons
                  if (!isAccessible)
                    Icon(
                      Icons.lock,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonTypeChip(LessonType type) {
    IconData icon;
    String label;
    Color color;

    switch (type) {
      case LessonType.text:
        icon = Icons.text_fields;
        label = 'Texte';
        color = Colors.blue;
        break;
      case LessonType.audio:
        icon = Icons.audiotrack;
        label = 'Audio';
        color = Colors.green;
        break;
      case LessonType.video:
        icon = Icons.videocam;
        label = 'Vidéo';
        color = Colors.red;
        break;
      case LessonType.interactive:
        icon = Icons.touch_app;
        label = 'Interactif';
        color = Colors.orange;
        break;
      case LessonType.quiz:
        icon = Icons.quiz;
        label = 'Quiz';
        color = Colors.purple;
        break;
      case LessonType.conversation:
        icon = Icons.chat;
        label = 'Conversation';
        color = Colors.teal;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonNavigation(LessonsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: viewModel.hasPreviousLesson
                  ? () => viewModel.goToPreviousLesson()
                  : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Précédent'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: viewModel.hasNextLesson
                  ? () => viewModel.goToNextLesson()
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Suivant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLessonContent(BuildContext context, dynamic lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => LessonContentView(
          lesson: lesson,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class LessonContentView extends StatelessWidget {
  final dynamic lesson;
  final ScrollController scrollController;

  const LessonContentView({
    super.key,
    required this.lesson,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: lesson.contents.length,
              itemBuilder: (context, index) {
                final content = lesson.contents[index];
                return _buildContentItem(content);
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Mark lesson as completed
                context.read<LessonsViewModel>().completeCurrentLesson();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Marquer comme terminé'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(dynamic content) {
    switch (content.type) {
      case ContentType.text:
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content.content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        );

      case ContentType.audio:
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.audiotrack, color: Colors.blue[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  content.title,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Play audio
                },
                icon: Icon(Icons.play_arrow, color: Colors.blue[700]),
              ),
            ],
          ),
        );

      case ContentType.video:
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.videocam, color: Colors.red[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  content.title,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Play video
                },
                icon: Icon(Icons.play_arrow, color: Colors.red[700]),
              ),
            ],
          ),
        );

      default:
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(content.title),
        );
    }
  }
}
