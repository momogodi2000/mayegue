import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../../../authentication/presentation/viewmodels/auth_viewmodel.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, DashboardViewModel>(
      builder: (context, authViewModel, dashboardViewModel, child) {
        final dashboardData = dashboardViewModel.getDashboardData();

        return Scaffold(
          appBar: AppBar(
            title: Text(dashboardData['title']),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => Navigator.of(context).pushNamed('/notifications'),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dashboardData['welcomeMessage'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dashboardData['subtitle'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats cards
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dashboardData['stats'].length,
                    itemBuilder: (context, index) {
                      final stat = dashboardData['stats'][index];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(stat['icon'], color: stat['color'], size: 24),
                            const SizedBox(height: 8),
                            Text(
                              stat['value'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              stat['label'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Quick actions
                const Text(
                  'Actions rapides',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dashboardData['quickActions'].length,
                    itemBuilder: (context, index) {
                      final action = dashboardData['quickActions'][index];
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pushNamed(action['route']),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                child: Icon(action['icon'], color: Colors.green, size: 28),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                action['label'],
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Recent activity
                const Text(
                  'Activité récente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: dashboardData['recentActivity'].length,
                    itemBuilder: (context, index) {
                      final activity = dashboardData['recentActivity'][index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: activity['color'].withOpacity(0.1),
                          child: Icon(activity['icon'], color: activity['color']),
                        ),
                        title: Text(activity['title']),
                        subtitle: Text(activity['subtitle']),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          drawer: _DashboardDrawer(),
        );
      },
    );
  }
}


class _DashboardDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            accountName: Text(user?.displayName ?? 'Utilisateur'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoUrl != null
                  ? NetworkImage(user!.photoUrl!)
                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Tableau de bord'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Leçons'),
            onTap: () => Navigator.of(context).pushNamed('/courses'),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text('Dictionnaire'),
            onTap: () => Navigator.of(context).pushNamed('/dictionary'),
          ),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Text('Jeux'),
            onTap: () => Navigator.of(context).pushNamed('/games'),
          ),
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text('Communauté'),
            onTap: () => Navigator.of(context).pushNamed('/community'),
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Évaluations'),
            onTap: () => Navigator.of(context).pushNamed('/assessments'),
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text('IA Assistant'),
            onTap: () => Navigator.of(context).pushNamed('/ai-assistant'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () => Navigator.of(context).pushNamed('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () => Navigator.of(context).pushNamed('/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              authViewModel.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
