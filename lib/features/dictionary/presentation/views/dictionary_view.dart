import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/word_entity.dart';
import '../viewmodels/dictionary_viewmodel.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus on search field when view opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DictionaryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionnaire'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Rechercher un mot...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.green),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
            color: Colors.red,
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
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
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
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat trouvé pour "${_searchController.text}"',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Vérifiez l\'orthographe ou essayez un autre mot',
            style: TextStyle(fontSize: 14, color: Colors.grey),
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
          Icon(
            Icons.book,
            size: 80,
            color: Colors.green.shade200,
          ),
          const SizedBox(height: 24),
          const Text(
            'Bienvenue dans le Dictionnaire',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recherchez des mots en français ou dans les langues locales',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Text(
            '💡 Conseil: Tapez au moins 2 caractères pour commencer la recherche',
            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      word.language.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
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
