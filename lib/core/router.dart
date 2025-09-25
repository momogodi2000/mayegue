import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../features/authentication/presentation/viewmodels/auth_viewmodel.dart';
import '../features/authentication/presentation/views/login_view.dart';
import '../features/authentication/presentation/views/register_view.dart';
import '../features/authentication/presentation/views/forgot_password_view.dart';
import '../features/authentication/presentation/views/phone_auth_view.dart';
import '../features/onboarding/presentation/views/splash_view.dart';
import '../features/onboarding/presentation/views/onboarding_view.dart';
import '../features/dashboard/presentation/views/dashboard_view.dart';
import '../features/home/presentation/views/home_view.dart';
import '../features/profile/presentation/views/profile_view.dart';
import '../features/lessons/presentation/views/courses_view.dart';
import '../features/dictionary/presentation/views/dictionary_view.dart';
import 'constants/routes.dart';

/// Global auth refresh notifier
final authRefreshNotifier = _AuthRefreshListenable();

/// App router configuration with Go Router
class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: Routes.splash,
      routes: [
        // Authentication routes
        GoRoute(
          path: Routes.login,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: Routes.register,
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: Routes.phoneAuth,
          builder: (context, state) => const PhoneAuthView(),
        ),
        GoRoute(
          path: Routes.forgotPassword,
          builder: (context, state) => const ForgotPasswordView(),
        ),

        // Main app routes (will be protected by auth guard)
          GoRoute(
            path: Routes.dashboard,
            builder: (context, state) => const DashboardView(),
          ),
          GoRoute(
            path: Routes.adminDashboard,
            builder: (context, state) => const _AdminDashboardPlaceholder(),
          ),
          GoRoute(
            path: Routes.teacherDashboard,
            builder: (context, state) => const _TeacherDashboardPlaceholder(),
          ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomePage(nomUtilisateur: 'User'),
        ),
        GoRoute(
          path: Routes.lessons,
          builder: (context, state) => const CoursesView(),
        ),
        GoRoute(
          path: Routes.dictionary,
          builder: (context, state) => const DictionaryView(),
        ),
        GoRoute(
          path: Routes.games,
          builder: (context, state) => const _GamesPlaceholder(),
        ),
        GoRoute(
          path: Routes.community,
          builder: (context, state) => const _CommunityPlaceholder(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfilPage(nomUtilisateur: 'User'),
        ),
        GoRoute(
          path: Routes.settings,
          builder: (context, state) => const _SettingsPlaceholder(),
        ),

        // Splash
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashView(),
        ),
        GoRoute(
          path: Routes.onboarding,
          builder: (context, state) => const OnboardingView(),
        ),
      ],
      redirect: (context, state) {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        final isAuthenticated = authViewModel.isAuthenticated;
        final isOnboardingCompleted = authViewModel.isOnboardingCompleted;
        final currentUser = authViewModel.currentUser;
        final isAuthRoute = state.matchedLocation == Routes.login ||
                           state.matchedLocation == Routes.register ||
                           state.matchedLocation == Routes.forgotPassword;
        final isSplashRoute = state.matchedLocation == Routes.splash;
        final isOnboardingRoute = state.matchedLocation == Routes.onboarding;

        // If not authenticated and trying to access protected route, redirect to login
        if (!isAuthenticated && !isAuthRoute && !isSplashRoute) {
          return Routes.login;
        }

        // If authenticated and on auth routes, check onboarding status and role
        if (isAuthenticated && isAuthRoute) {
          if (!isOnboardingCompleted) {
            return Routes.onboarding;
          }
          // Redirect to role-based dashboard
          return _getRoleBasedDashboard(currentUser?.role ?? 'learner');
        }

        // If authenticated and on splash, check onboarding status and role
        if (isAuthenticated && isSplashRoute) {
          if (!isOnboardingCompleted) {
            return Routes.onboarding;
          }
          // Redirect to role-based dashboard
          return _getRoleBasedDashboard(currentUser?.role ?? 'learner');
        }

        // If authenticated and on onboarding but onboarding is completed, redirect to role-based dashboard
        if (isAuthenticated && isOnboardingRoute && isOnboardingCompleted) {
          return _getRoleBasedDashboard(currentUser?.role ?? 'learner');
        }

        return null;
      },
      refreshListenable: authRefreshNotifier,
    );
  }

  /// Get role-based dashboard route
  static String _getRoleBasedDashboard(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Routes.adminDashboard;
      case 'teacher':
      case 'instructor':
        return Routes.teacherDashboard;
      case 'learner':
      case 'student':
      default:
        return Routes.dashboard;
    }
  }
}

/// Refresh listener for auth state changes
class _AuthRefreshListenable extends ChangeNotifier {
  void notifyAuthChanged() {
    notifyListeners();
  }
}

/// Placeholder widgets for routes not yet implemented
class _GamesPlaceholder extends StatelessWidget {
  const _GamesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: const Center(child: Text('Games - Coming Soon')),
    );
  }
}

class _CommunityPlaceholder extends StatelessWidget {
  const _CommunityPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: const Center(child: Text('Community - Coming Soon')),
    );
  }
}

class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings - Coming Soon')),
    );
  }
}

class _AdminDashboardPlaceholder extends StatelessWidget {
  const _AdminDashboardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: const Center(child: Text('Admin Dashboard - Coming Soon')),
    );
  }
}

class _TeacherDashboardPlaceholder extends StatelessWidget {
  const _TeacherDashboardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      body: const Center(child: Text('Teacher Dashboard - Coming Soon')),
    );
  }
}
