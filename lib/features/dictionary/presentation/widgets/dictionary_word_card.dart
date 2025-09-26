import 'package:flutter/material.dart';
import '../../../../shared/themes/app_theme.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/word_entity.dart';

/// Card widget for displaying dictionary words in search results
class DictionaryWordCard extends StatelessWidget {
  final WordEntity word;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const DictionaryWordCard({
    super.key,
    required this.word,
    this.onTap,
    this.showFavoriteButton = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing / 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacing),
          child: Row(
            children: [
              // Word content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Word and language
                    Row(
                      children: [
                        Text(
                          word.word,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(width: AppDimensions.spacing / 2),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing / 2,
                            vertical: AppDimensions.spacing / 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius / 2),
                          ),
                          child: Text(
                            _getLanguageCode(word.language),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.spacing / 4),

                    // Translation
                    Text(
                      word.translation,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                          ),
                    ),

                    // Category and difficulty
                    if (word.category.isNotEmpty || word.difficulty > 0) ...[
                      SizedBox(height: AppDimensions.spacing / 4),
                      Row(
                        children: [
                          if (word.category.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacing / 2,
                                vertical: AppDimensions.spacing / 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).chipTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(AppDimensions.borderRadius / 2),
                              ),
                              child: Text(
                                _capitalizeFirst(word.category),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          if (word.difficulty > 0) ...[
                            SizedBox(width: AppDimensions.spacing / 2),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < word.difficulty ? Icons.star : Icons.star_border,
                                  size: 12,
                                  color: index < word.difficulty
                                      ? Colors.amber
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],

                    // Example (if available)
                    if (word.example != null && word.example!.isNotEmpty) ...[
                      SizedBox(height: AppDimensions.spacing / 4),
                      Text(
                        '"${word.example}"',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Favorite button
              if (showFavoriteButton) ...[
                SizedBox(width: AppDimensions.spacing),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Theme.of(context).disabledColor,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ],

              // Arrow indicator
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageCode(String language) {
    // Convert full language names to codes for display
    switch (language.toLowerCase()) {
      case 'french':
      case 'français':
        return 'FR';
      case 'english':
      case 'anglais':
        return 'EN';
      case 'ewondo':
        return 'EW';
      case 'duala':
        return 'DU';
      case 'bafang':
        return 'BF';
      case 'fulfulde':
        return 'FU';
      case 'bassa':
        return 'BA';
      case 'bamum':
        return 'BM';
      default:
        return language.substring(0, min(2, language.length)).toUpperCase();
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  int min(int a, int b) => a < b ? a : b;
}