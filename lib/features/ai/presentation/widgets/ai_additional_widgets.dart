import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ai_viewmodels.dart';

/// Pronunciation Assessment Widget
class PronunciationAssessmentWidget extends StatefulWidget {
  const PronunciationAssessmentWidget({super.key});

  @override
  State<PronunciationAssessmentWidget> createState() => _PronunciationAssessmentWidgetState();
}

class _PronunciationAssessmentWidgetState extends State<PronunciationAssessmentWidget> {
  final TextEditingController _wordController = TextEditingController();
  String _language = 'ewondo';
  bool _isRecording = false;

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PronunciationViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language selector
              DropdownButtonFormField<String>(
                value: _language,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ewondo', child: Text('Ewondo')),
                  DropdownMenuItem(value: 'bafang', child: Text('Bafang')),
                ],
                onChanged: (value) => setState(() => _language = value!),
              ),

              const SizedBox(height: 16),

              // Word input
              TextField(
                controller: _wordController,
                decoration: const InputDecoration(
                  labelText: 'Word to practice',
                  hintText: 'Enter a word to assess pronunciation',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Record button
              Center(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: viewModel.isLoading ? null : _toggleRecording,
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        size: 48,
                      ),
                      color: _isRecording ? Colors.red : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRecording ? 'Recording... Tap to stop' : 'Tap to start recording',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Assessment result
              if (viewModel.currentAssessment != null)
                _AssessmentResult(assessment: viewModel.currentAssessment!),

              // Loading indicator
              if (viewModel.isLoading)
                const Center(child: CircularProgressIndicator()),

              // Error message
              if (viewModel.error != null)
                Text(
                  viewModel.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        );
      },
    );
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);

    if (!_isRecording && _wordController.text.trim().isNotEmpty) {
      // TODO: Implement actual audio recording and get audio URL
      const mockAudioUrl = 'mock_audio_url';

      // TODO: Get user ID from auth
      const userId = 'test-user-id';

      context.read<PronunciationViewModel>().assess(
        userId: userId,
        word: _wordController.text.trim(),
        language: _language,
        audioUrl: mockAudioUrl,
      );
    }
  }
}

/// Assessment result display
class _AssessmentResult extends StatelessWidget {
  final dynamic assessment;

  const _AssessmentResult({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final score = assessment.score;
    final color = score > 0.8 ? Colors.green : score > 0.6 ? Colors.orange : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Assessment Result',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${(score * 100).round()}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Feedback: ${assessment.feedback}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (assessment.issues.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Areas for Improvement:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...assessment.issues.map<Widget>((issue) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getIssueIcon(issue.type),
                      size: 20,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${issue.description} - ${issue.suggestion}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIssueIcon(String type) {
    switch (type) {
      case 'tone':
        return Icons.music_note;
      case 'consonant':
        return Icons.volume_up;
      case 'vowel':
        return Icons.record_voice_over;
      case 'stress':
        return Icons.trending_up;
      default:
        return Icons.warning;
    }
  }
}

/// Content Generation Widget
class ContentGenerationWidget extends StatefulWidget {
  const ContentGenerationWidget({super.key});

  @override
  State<ContentGenerationWidget> createState() => _ContentGenerationWidgetState();
}

class _ContentGenerationWidgetState extends State<ContentGenerationWidget> {
  final TextEditingController _topicController = TextEditingController();
  String _type = 'lesson';
  String _language = 'ewondo';
  String _difficulty = 'beginner';

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentGenerationViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Content type selector
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Content Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'lesson', child: Text('Lesson')),
                  DropdownMenuItem(value: 'exercise', child: Text('Exercise')),
                  DropdownMenuItem(value: 'story', child: Text('Story')),
                  DropdownMenuItem(value: 'dialogue', child: Text('Dialogue')),
                ],
                onChanged: (value) => setState(() => _type = value!),
              ),

              const SizedBox(height: 16),

              // Language selector
              DropdownButtonFormField<String>(
                value: _language,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ewondo', child: Text('Ewondo')),
                  DropdownMenuItem(value: 'bafang', child: Text('Bafang')),
                ],
                onChanged: (value) => setState(() => _language = value!),
              ),

              const SizedBox(height: 16),

              // Difficulty selector
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty Level',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                  DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                  DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                ],
                onChanged: (value) => setState(() => _difficulty = value!),
              ),

              const SizedBox(height: 16),

              // Topic input
              TextField(
                controller: _topicController,
                decoration: const InputDecoration(
                  labelText: 'Topic',
                  hintText: 'Enter a topic for content generation',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Generate button
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : _generateContent,
                child: viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Generate Content'),
              ),

              const SizedBox(height: 24),

              // Generated content
              if (viewModel.currentContent != null)
                _GeneratedContentDisplay(content: viewModel.currentContent!),

              // Error message
              if (viewModel.error != null)
                Text(
                  viewModel.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        );
      },
    );
  }

  void _generateContent() {
    if (_topicController.text.trim().isEmpty) return;

    // TODO: Get user ID from auth
    const userId = 'test-user-id';

    context.read<ContentGenerationViewModel>().generate(
      userId: userId,
      type: _type,
      topic: _topicController.text.trim(),
      language: _language,
      difficulty: _difficulty,
    );
  }
}

/// Generated content display
class _GeneratedContentDisplay extends StatelessWidget {
  final dynamic content;

  const _GeneratedContentDisplay({required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${content.type.capitalize()} - ${content.topic}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Chip(
                  label: Text(content.difficulty),
                  backgroundColor: _getDifficultyColor(content.difficulty),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content.generatedContent,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (content.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: content.tags.map<Widget>((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// AI Recommendations Widget
class AiRecommendationsWidget extends StatefulWidget {
  const AiRecommendationsWidget({super.key});

  @override
  State<AiRecommendationsWidget> createState() => _AiRecommendationsWidgetState();
}

class _AiRecommendationsWidgetState extends State<AiRecommendationsWidget> {
  @override
  void initState() {
    super.initState();
    // Load recommendations when widget initializes
    // TODO: Get user ID from auth
    const userId = 'test-user-id';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiRecommendationsViewModel>().loadRecommendations(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AiRecommendationsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(
            child: Text(
              viewModel.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        if (viewModel.recommendations.isEmpty) {
          return const Center(
            child: Text('No recommendations available yet. Start learning to get personalized suggestions!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.recommendations.length,
          itemBuilder: (context, index) {
            final recommendation = viewModel.recommendations[index];
            return _RecommendationCard(recommendation: recommendation);
          },
        );
      },
    );
  }
}

/// Recommendation card
class _RecommendationCard extends StatelessWidget {
  final dynamic recommendation;

  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    recommendation.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(recommendation.priority),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Priority ${recommendation.priority}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recommendation.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Why: ${recommendation.reason}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to the recommended activity
                },
                child: const Text('Start Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 2:
        return Colors.blue;
      case 1:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
