import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue sur Mayegue!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // User progress overview
            const Card(
              elevation: 2,
              child: const ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.orange),
                title: const Text('Progression'),
                subtitle: const Text('Votre niveau actuel : Débutant'),
                trailing: const Text('45%'),
              ),
            ),
            const SizedBox(height: 16),
            // Quick access menu
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const _DashboardShortcut(
                  icon: Icons.menu_book,
                  label: 'Leçons',
                  route: '/lessons',
                ),
                const _DashboardShortcut(
                  icon: Icons.translate,
                  label: 'Dictionnaire',
                  route: '/dictionary',
                ),
                const _DashboardShortcut(
                  icon: Icons.videogame_asset,
                  label: 'Jeux',
                  route: '/games',
                ),
                const _DashboardShortcut(
                  icon: Icons.forum,
                  label: 'Communauté',
                  route: '/community',
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Achievements
            const Text('Succès récents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              children: [
                Chip(label: const Text('Premier quiz réussi'), avatar: const Icon(Icons.check_circle, color: Colors.green)),
                Chip(label: const Text('10 mots appris'), avatar: const Icon(Icons.star, color: Colors.yellow)),
                Chip(label: const Text('Profil complété'), avatar: const Icon(Icons.person, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 24),
            // Recent activity
            const Text('Activité récente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.menu_book, color: Colors.green),
                    title: Text('Leçon Ewondo 1 terminée'),
                    subtitle: Text('Aujourd’hui à 10:15'),
                  ),
                  ListTile(
                    leading: Icon(Icons.videogame_asset, color: Colors.purple),
                    title: Text('Jeu de vocabulaire joué'),
                    subtitle: Text('Hier à 18:30'),
                  ),
                  ListTile(
                    leading: Icon(Icons.translate, color: Colors.orange),
                    title: Text('Mot ajouté aux favoris'),
                    subtitle: Text('Hier à 14:05'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: _DashboardDrawer(),
    );
  }
}

class _DashboardShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _DashboardShortcut({required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, color: Colors.green, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.person, size: 32)),
                SizedBox(height: 8),
                Text('Utilisateur', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('Débutant', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Leçons'),
            onTap: () => Navigator.of(context).pushNamed('/lessons'),
          ),
          ListTile(
            leading: Icon(Icons.translate),
            title: Text('Dictionnaire'),
            onTap: () => Navigator.of(context).pushNamed('/dictionary'),
          ),
          ListTile(
            leading: Icon(Icons.videogame_asset),
            title: Text('Jeux'),
            onTap: () => Navigator.of(context).pushNamed('/games'),
          ),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text('Communauté'),
            onTap: () => Navigator.of(context).pushNamed('/community'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètres'),
            onTap: () => Navigator.of(context).pushNamed('/settings'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              // TODO: Call AuthViewModel.logout and redirect to login
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
