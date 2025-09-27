import 'package:flutter/material.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../shared/themes/colors.dart';

/// Card widget for showcasing a language in the guest dashboard
class LanguageShowcaseCard extends StatelessWidget {
  final LanguageInfo language;
  final VoidCallback onTap;

  const LanguageShowcaseCard({
    super.key,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                _getLanguageColor(language.code).withOpacity(0.1),
                _getLanguageColor(language.code).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Language flag/emoji
              Text(
                language.flag,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),

              // Language name
              Text(
                language.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                textAlign: TextAlign.center,
              ),

              // Native name
              Text(
                language.nativeName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Region and speakers
              Text(
                '${language.region} • ${_formatSpeakers(language.speakers)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(language.difficulty),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getDifficultyText(language.difficulty),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLanguageColor(String code) {
    switch (code) {
      case 'ewondo':
        return Colors.green;
      case 'duala':
        return Colors.blue;
      case 'feefee':
        return Colors.purple;
      case 'fulfulde':
        return Colors.orange;
      case 'bassa':
        return Colors.red;
      case 'bamum':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  Color _getDifficultyColor(LanguageDifficulty difficulty) {
    switch (difficulty) {
      case LanguageDifficulty.beginner:
        return Colors.green;
      case LanguageDifficulty.intermediate:
        return Colors.orange;
      case LanguageDifficulty.advanced:
        return Colors.red;
      case LanguageDifficulty.expert:
        return Colors.purple;
    }
  }

  String _getDifficultyText(LanguageDifficulty difficulty) {
    switch (difficulty) {
      case LanguageDifficulty.beginner:
        return 'Débutant';
      case LanguageDifficulty.intermediate:
        return 'Intermédiaire';
      case LanguageDifficulty.advanced:
        return 'Avancé';
      case LanguageDifficulty.expert:
        return 'Expert';
    }
  }

  String _formatSpeakers(int speakers) {
    if (speakers >= 1000000) {
      return '${(speakers / 1000000).toStringAsFixed(1)}M';
    } else if (speakers >= 1000) {
      return '${(speakers / 1000).toStringAsFixed(0)}k';
    }
    return speakers.toString();
  }
}