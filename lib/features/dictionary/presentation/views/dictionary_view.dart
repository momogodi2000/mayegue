import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/app_dimensions.dart';
import '../viewmodels/dictionary_viewmodel.dart';
import '../widgets/dictionary_word_card.dart';
import 'word_details_view.dart';

/// Main dictionary search view
class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final viewModel = context.read<DictionaryViewModel>();
    viewModel.setSearchQuery(_searchController.text);
    if (_searchController.text.isNotEmpty) {
      viewModel.loadSuggestions(_searchController.text);
    }
  }

  void _performSearch() {
    final viewModel = context.read<DictionaryViewModel>();
    if (_searchController.text.isNotEmpty) {
      viewModel.performSearch(_searchController.text);
      _searchFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionnaire'),
        elevation: 0,
      ),
      body: Consumer<DictionaryViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Search header
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimensions.borderRadius),
                    bottomRight: Radius.circular(AppDimensions.borderRadius),
                  ),
                ),
                child: Column(
                  children: [
                    // Language selectors
                    Row(
                      children: [
                        Expanded(
                          child: _buildLanguageDropdown(
                            label: 'De',
                            value: viewModel.selectedSourceLanguage,
                            onChanged: viewModel.setSourceLanguage,
                          ),
                        ),
                        SizedBox(width: AppDimensions.spacing),
                        Icon(Icons.arrow_forward, color: AppTheme.primaryColor),
                        SizedBox(width: AppDimensions.spacing),
                        Expanded(
                          child: _buildLanguageDropdown(
                            label: 'Vers',
                            value: viewModel.selectedTargetLanguage,
                            onChanged: viewModel.setTargetLanguage,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing),

                    // Search field
                    TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un mot...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  viewModel.clearSearch();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),

                    // Autocomplete suggestions
                    if (viewModel.suggestions.isNotEmpty && viewModel.isLoadingSuggestions)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        margin: EdgeInsets.only(top: AppDimensions.spacing / 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = viewModel.suggestions[index];
                            return ListTile(
                              title: Text(suggestion),
                              onTap: () {
                                _searchController.text = suggestion;
                                _performSearch();
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // Content area
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.error != null
                        ? _buildErrorView(viewModel)
                        : viewModel.searchResults.isEmpty && _searchController.text.isNotEmpty
                            ? _buildEmptyView()
                            : _buildResultsView(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageDropdown({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Consumer<DictionaryViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
            ),
            SizedBox(height: AppDimensions.spacing / 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing / 2),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius / 2),
              ),
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                underline: const SizedBox(),
                items: DictionaryViewModel.supportedLanguages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang['code'],
                    child: Text(
                      lang['name'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorView(DictionaryViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: AppDimensions.spacing),
          Text(
            'Erreur',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppDimensions.spacing / 2),
          Text(
            viewModel.error ?? 'Une erreur est survenue',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spacing),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                viewModel.performSearch(_searchController.text);
              }
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          SizedBox(height: AppDimensions.spacing),
          Text(
            'Aucun résultat',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppDimensions.spacing / 2),
          Text(
            'Essayez avec un autre mot ou vérifiez l\'orthographe',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(DictionaryViewModel viewModel) {
    if (viewModel.searchResults.isEmpty && _searchController.text.isEmpty) {
      return _buildWelcomeView();
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.spacing),
      itemCount: viewModel.searchResults.length,
      itemBuilder: (context, index) {
        final word = viewModel.searchResults[index];
        return DictionaryWordCard(
          word: word,
          onTap: () {
            // Navigate to word details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordDetailsView(wordId: word.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWelcomeView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.translate,
            size: 64,
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: AppDimensions.spacing),
          Text(
            'Bienvenue dans le dictionnaire',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spacing / 2),
          Text(
            'Recherchez des mots en français ou en anglais\net découvrez leurs traductions dans les langues camerounaises',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Rechercher un mot...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.primary),
                        onPressed: () {
                          _searchController.clear();
                          viewModel.clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: (query) {
                if (query.length >= 2) {
                  viewModel.searchWords(query);
                } else if (query.isEmpty) {
                  viewModel.clearSearch();
                }
              },
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  viewModel.searchWords(query);
                }
              },
            ),
          ),

          // Content
          Expanded(
            child: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : viewModel.errorMessage != null
                    ? _buildErrorView(viewModel)
                    : viewModel.searchResults.isEmpty && _searchController.text.isNotEmpty
                        ? _buildEmptyView()
                        : _buildResultsView(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(DictionaryViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.errorMessage!,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              viewModel.clearError();
              if (_searchController.text.isNotEmpty) {
                viewModel.searchWords(_searchController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.onSecondary,
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.onSurface.withValues(alpha: 102),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat trouvé pour "${_searchController.text}"',
            style: TextStyle(fontSize: 16, color: AppColors.onSurface.withValues(alpha: 178)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Vérifiez l\'orthographe ou essayez un autre mot',
            style: TextStyle(fontSize: 14, color: AppColors.onSurface.withValues(alpha: 127)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(DictionaryViewModel viewModel) {
    if (viewModel.searchResults.isEmpty && _searchController.text.isEmpty) {
      return _buildWelcomeView();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.searchResults.length,
      itemBuilder: (context, index) {
        final word = viewModel.searchResults[index];
        return _buildWordCard(word, viewModel);
      },
    );
  }

  Widget _buildWelcomeView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.book,
            size: 80,
            color: AppColors.primaryLight,
          ),
          const SizedBox(height: 24),
          const Text(
            'Bienvenue dans le Dictionnaire',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Recherchez des mots en français ou dans les langues locales',
            style: TextStyle(fontSize: 16, color: AppColors.onSurface.withValues(alpha: 178)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            '💡 Conseil: Tapez au moins 2 caractères pour commencer la recherche',
            style: TextStyle(fontSize: 14, color: AppColors.onSurface.withValues(alpha: 127)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(WordEntity word, DictionaryViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to word detail view
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WordDetailView(wordId: word.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Word and language
              Row(
                children: [
                  Expanded(
                    child: Text(
                      word.word,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      word.language.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Translation
              Text(
                word.translation,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              // Phonetic if available
              if (word.phonetic != null) ...[
                const SizedBox(height: 4),
                Text(
                  word.phonetic!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              // Category and difficulty
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildChip(word.category),
                  const SizedBox(width: 8),
                  _buildDifficultyIndicator(word.difficulty),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(int difficulty) {
    final color = difficulty <= 2 ? Colors.green : difficulty <= 4 ? Colors.orange : Colors.red;
    final text = difficulty <= 2 ? 'Facile' : difficulty <= 4 ? 'Moyen' : 'Difficile';

    return Row(
      children: [
        Icon(Icons.circle, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Placeholder for word detail view - to be implemented
class WordDetailView extends StatelessWidget {
  final String wordId;

  const WordDetailView({super.key, required this.wordId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du mot'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Word Detail View - Coming Soon'),
      ),
    );
  }
}
