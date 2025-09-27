import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../core/constants/routes.dart';
import '../../../../shared/themes/colors.dart';

/// Dashboard view for guest users (non-authenticated)
class GuestDashboardView extends StatefulWidget {
  const GuestDashboardView({super.key});

  @override
  State<GuestDashboardView> createState() => _GuestDashboardViewState();
}

class _GuestDashboardViewState extends State<GuestDashboardView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _demoLessons = [
    {
      'id': 'demo_1',
      'title': 'Salutations en Ewondo',
      'description': 'Apprenez les salutations de base',
      'language': 'ewondo',
      'duration': 5,
      'isDemo': true,
      'difficulty': 'Débutant',
    },
    {
      'id': 'demo_2',
      'title': 'Nombres en Duala',
      'description': 'Comptez de 1 à 10 en Duala',
      'language': 'duala',
      'duration': 7,
      'isDemo': true,
      'difficulty': 'Débutant',
    },
    {
      'id': 'demo_3',
      'title': 'Famille en Bassa',
      'description': 'Vocabulaire de la famille',
      'language': 'bassa',
      'duration': 8,
      'isDemo': true,
      'difficulty': 'Débutant',
    },
  ];

  final List<Map<String, dynamic>> _demoGames = [
    {
      'id': 'memory_demo',
      'title': 'Memory des Mots',
      'description': 'Mémorisez les mots en langue locale',
      'icon': Icons.memory,
      'color': Colors.blue,
      'isDemo': true,
    },
    {
      'id': 'quiz_demo',
      'title': 'Quiz Express',
      'description': 'Questions rapides sur les langues',
      'icon': Icons.quiz,
      'color': Colors.green,
      'isDemo': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Découverte des Langues'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          TextButton.icon(
            onPressed: () => context.go(Routes.login),
            icon: const Icon(Icons.login, color: Colors.white),
            label: const Text(
              'Connexion',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Accueil', icon: Icon(Icons.home, size: 20)),
            Tab(text: 'Langues', icon: Icon(Icons.language, size: 20)),
            Tab(text: 'Démo', icon: Icon(Icons.play_circle, size: 20)),
            Tab(text: 'À Propos', icon: Icon(Icons.info, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildLanguagesTab(),
          _buildDemoTab(),
          _buildAboutTab(),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenue dans Mayegue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Découvrez les langues traditionnelles du Cameroun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go(Routes.register),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text('Commencer Gratuitement'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => _tabController.animateTo(2),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Essayer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // What you'll learn section
          Text(
            'Ce que vous allez apprendre',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildFeatureCard(
                'Vocabulaire',
                'Mots essentiels du quotidien',
                Icons.book,
                Colors.blue,
              ),
              _buildFeatureCard(
                'Prononciation',
                'Audio avec locuteurs natifs',
                Icons.record_voice_over,
                Colors.green,
              ),
              _buildFeatureCard(
                'Culture',
                'Traditions et contexte culturel',
                Icons.groups,
                Colors.orange,
              ),
              _buildFeatureCard(
                'Conversation',
                'Phrases utiles et dialogues',
                Icons.chat,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Languages preview
          Text(
            'Langues disponibles',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: SupportedLanguages.languages.length,
              itemBuilder: (context, index) {
                final entry = SupportedLanguages.languages.entries.elementAt(index);
                final languageInfo = entry.value;
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageInfo.flag,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            languageInfo.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            languageInfo.region,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Statistics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Rejoignez notre communauté',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('15,000+', 'Apprenants'),
                      _buildStatColumn('6', 'Langues'),
                      _buildStatColumn('500+', 'Leçons'),
                      _buildStatColumn('98%', 'Satisfaction'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: SupportedLanguages.languages.length,
      itemBuilder: (context, index) {
        final entry = SupportedLanguages.languages.entries.elementAt(index);
        final languageCode = entry.key;
        final languageInfo = entry.value;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      languageInfo.flag,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageInfo.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            languageInfo.nativeName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                languageInfo.region,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.people, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${(languageInfo.speakers / 1000000).toStringAsFixed(1)}M',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showLanguagePreview(context, languageCode, languageInfo),
                      child: const Text('Découvrir'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  languageInfo.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  languageInfo.culturalInfo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text(languageInfo.difficulty.displayName),
                  backgroundColor: _getDifficultyColor(languageInfo.difficulty),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Demo info
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Essayez nos leçons et jeux gratuitement sans inscription',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Demo lessons
          Text(
            'Leçons d\'introduction',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          ..._demoLessons.map((lesson) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  title: Text(lesson['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lesson['description']),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${lesson['duration']} min'),
                          const SizedBox(width: 16),
                          Text(
                            SupportedLanguages.getLanguageInfo(lesson['language'])?.flag ?? '🇨🇲',
                          ),
                          const SizedBox(width: 4),
                          Text(
                            SupportedLanguages.getDisplayName(lesson['language']),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _startDemoLesson(lesson['id']),
                    child: const Text('Essayer'),
                  ),
                  isThreeLine: true,
                ),
              )),

          const SizedBox(height: 24),

          // Demo games
          Text(
            'Jeux éducatifs',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _demoGames.length,
            itemBuilder: (context, index) {
              final game = _demoGames[index];
              return Card(
                child: InkWell(
                  onTap: () => _startDemoGame(game['id']),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          game['icon'] as IconData,
                          size: 40,
                          color: game['color'] as Color,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          game['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Call to action
          Card(
            color: AppColors.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.rocket_launch, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  const Text(
                    'Prêt à aller plus loin ?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Créez un compte gratuit pour accéder à tous les contenus',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go(Routes.register),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('S\'inscrire Gratuitement'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mission
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red[600], size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Notre Mission',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mayegue est dédiée à la préservation et à la transmission des langues traditionnelles camerounaises. Notre mission est de rendre ces langues ancestrales accessibles aux nouvelles générations grâce à la technologie moderne.',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Features
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pourquoi choisir Mayegue ?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureListItem(
                    Icons.school,
                    'Méthode pédagogique moderne',
                    'Apprentissage adaptatif basé sur votre rythme',
                  ),
                  _buildFeatureListItem(
                    Icons.people,
                    'Contenu authentique',
                    'Créé en collaboration avec des locuteurs natifs',
                  ),
                  _buildFeatureListItem(
                    Icons.psychology,
                    'Intelligence artificielle',
                    'Assistant IA personnalisé pour votre apprentissage',
                  ),
                  _buildFeatureListItem(
                    Icons.groups,
                    'Communauté active',
                    'Échangez avec d\'autres apprenants et enseignants',
                  ),
                  _buildFeatureListItem(
                    Icons.phone,
                    'Accessible partout',
                    'Apprenez hors ligne sur votre téléphone',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Contact
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nous contacter',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: const Text('contact@mayegue.cm'),
                    onTap: () {
                      // TODO: Open email client
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Site web'),
                    subtitle: const Text('www.mayegue.cm'),
                    onTap: () {
                      // TODO: Open website
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.facebook),
                    title: const Text('Facebook'),
                    subtitle: const Text('@MayegueApp'),
                    onTap: () {
                      // TODO: Open Facebook
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureListItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(LanguageDifficulty difficulty) {
    switch (difficulty) {
      case LanguageDifficulty.beginner:
        return Colors.green[100]!;
      case LanguageDifficulty.intermediate:
        return Colors.orange[100]!;
      case LanguageDifficulty.advanced:
        return Colors.red[100]!;
      case LanguageDifficulty.expert:
        return Colors.purple[100]!;
    }
  }

  void _showLanguagePreview(BuildContext context, String languageCode, LanguageInfo info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(info.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(info.name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom natif: ${info.nativeName}'),
            const SizedBox(height: 8),
            Text('Région: ${info.region}'),
            const SizedBox(height: 8),
            Text('Locuteurs: ${(info.speakers / 1000000).toStringAsFixed(1)}M'),
            const SizedBox(height: 8),
            Text('Difficulté: ${info.difficulty.displayName}'),
            const SizedBox(height: 16),
            Text(info.description),
            const SizedBox(height: 12),
            Text(
              info.culturalInfo,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(Routes.register);
            },
            child: const Text('Apprendre'),
          ),
        ],
      ),
    );
  }

  void _startDemoLesson(String lessonId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Démarrage de la leçon démo $lessonId'),
        action: SnackBarAction(
          label: 'S\'inscrire',
          onPressed: () => context.go(Routes.register),
        ),
      ),
    );
  }

  void _startDemoGame(String gameId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Démarrage du jeu démo $gameId'),
        action: SnackBarAction(
          label: 'S\'inscrire',
          onPressed: () => context.go(Routes.register),
        ),
      ),
    );
  }
}