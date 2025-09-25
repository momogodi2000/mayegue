# Guide de Développement - Mayegue App

## Vue d'Ensemble

Ce guide fournit toutes les instructions nécessaires pour configurer l'environnement de développement, contribuer au projet et maintenir la qualité du code.

## 🛠️ Configuration de l'Environnement

### Prérequis Système

#### Windows
```powershell
# Installation Flutter via Chocolatey
choco install flutter

# Installation Android Studio
choco install androidstudio

# Variables d'environnement
$env:PATH += ";C:\src\flutter\bin"
```

#### macOS
```bash
# Installation via Homebrew
brew install --cask flutter

# Installation Android Studio
brew install --cask android-studio

# Variables d'environnement
export PATH="$PATH:/opt/flutter/bin"
```

#### Linux (Ubuntu/Debian)
```bash
# Installation Flutter
sudo snap install flutter --classic

# Installation Android Studio
sudo snap install android-studio --classic

# Variables d'environnement
export PATH="$PATH:/snap/flutter/current/bin"
```

### Vérification de l'Installation
```bash
# Vérification Flutter
flutter doctor

# Vérification version
flutter --version

# Mise à jour
flutter upgrade
```

### Configuration IDE

#### Visual Studio Code
Extensions recommandées :
- `Dart`
- `Flutter`
- `Flutter Widget Snippets`
- `Awesome Flutter Snippets`
- `Pubspec Assist`
- `Flutter Riverpod Snippets`

Configuration `.vscode/settings.json` :
```json
{
  "dart.flutterSdkPath": "/opt/flutter",
  "dart.lineLength": 100,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "dart.analysisExcludedFolders": [
    ".dart_tool",
    "build",
    "ios",
    "android"
  ]
}
```

#### Android Studio
- Installer le plugin Flutter
- Configurer le SDK Flutter
- Activer Dart Analysis

## 🚀 Installation du Projet

### Clonage et Configuration
```bash
# Clonage du repository
git clone https://github.com/momogodi2000/mayegue.git
cd mayegue-app

# Installation des dépendances
flutter pub get

# Génération des fichiers
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter pub run flutter_launcher_icons:main
```

### Configuration des Variables d'Environnement
```bash
# Copie du fichier exemple
cp .env.example .env

# Édition avec vos clés API
nano .env
```

Contenu du fichier `.env` :
```env
# Firebase
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=mayegue-app
FIREBASE_APP_ID=your_app_id

# IA
GEMINI_API_KEY=your_gemini_key

# Paiements
CAMPAY_API_KEY=your_campay_key
CAMPAY_SECRET=your_campay_secret

# Environnement
APP_ENVIRONMENT=development
```

### Configuration Firebase
```bash
# Installation Firebase CLI
npm install -g firebase-tools

# Connexion
firebase login

# Initialisation (si nécessaire)
firebase init

# Déploiement des règles
firebase deploy --only firestore:rules,storage:rules --project mayegue-app
```

### Import des Données de Seed
```bash
# Via Firebase Console
# OU via script personnalisé
dart run scripts/seed_languages.dart
dart run scripts/seed_dictionary.dart
```

## 🏗️ Structure du Projet

### Organisation des Dossiers
```
lib/
├── core/                    # Noyau applicatif
│   ├── config/             # Configuration
│   ├── errors/             # Gestion d'erreurs
│   ├── network/            # Services réseau
│   ├── router.dart         # Navigation
│   ├── services/           # Services métier
│   └── utils/              # Utilitaires
├── features/               # Modules fonctionnels
│   ├── feature_name/
│   │   ├── data/          # Couche données
│   │   ├── domain/        # Couche métier
│   │   └── presentation/  # Couche présentation
├── shared/                 # Composants partagés
├── l10n/                   # Internationalisation
└── main.dart              # Point d'entrée
```

### Conventions de Nommage

#### Fichiers et Classes
- **PascalCase** pour les classes : `UserRepository`, `AuthViewModel`
- **camelCase** pour les variables : `userName`, `isAuthenticated`
- **snake_case** pour les fichiers : `auth_repository.dart`
- **kebab-case** pour les assets : `login-background.png`

#### Variables et Constantes
```dart
// Constantes
const String apiBaseUrl = 'https://api.mayegue.com';
const Duration timeout = Duration(seconds: 30);

// Variables privées
String _userToken;
bool _isLoading = false;

// Variables publiques
String userName;
bool isAuthenticated = false;
```

## 🧪 Développement et Tests

### Workflow de Développement

#### 1. Création d'une Branche
```bash
# Création branche feature
git checkout -b feature/nouvelle-fonctionnalite

# OU branche bugfix
git checkout -b bugfix/correction-bug
```

#### 2. Développement
```dart
// Exemple : Ajout d'une nouvelle fonctionnalité
// 1. Créer les entités dans domain/
// 2. Implémenter le repository dans data/
// 3. Créer le ViewModel dans presentation/
// 4. Ajouter la vue et les widgets
// 5. Mettre à jour le router si nécessaire
```

#### 3. Tests
```bash
# Tests unitaires
flutter test

# Tests avec couverture
flutter test --coverage

# Tests d'un fichier spécifique
flutter test test/auth_viewmodel_test.dart

# Tests d'intégration
flutter test integration_test/
```

#### 4. Analyse de Code
```bash
# Vérification statique
flutter analyze

# Formatage
dart format lib/

# Correction automatique
dart fix --apply
```

### Écriture de Tests

#### Test Unitaire
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthViewModel', () {
    late AuthViewModel viewModel;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      viewModel = AuthViewModel(mockRepository);
    });

    test('should login successfully', () async {
      // Arrange
      when(mockRepository.login('test@test.com', 'password'))
          .thenAnswer((_) async => const User(id: '1', email: 'test@test.com'));

      // Act
      await viewModel.login('test@test.com', 'password');

      // Assert
      expect(viewModel.state.isAuthenticated, true);
      expect(viewModel.state.user?.email, 'test@test.com');
    });

    test('should handle login error', () async {
      // Arrange
      when(mockRepository.login(any, any))
          .thenThrow(Exception('Invalid credentials'));

      // Act
      await viewModel.login('wrong@email.com', 'wrongpass');

      // Assert
      expect(viewModel.state.isAuthenticated, false);
      expect(viewModel.state.error, isNotNull);
    });
  });
}
```

#### Test de Widget
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('LoginView', () {
    testWidgets('should display login form', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: LoginView(),
        ),
      );

      // Verify elements are present
      expect(find.text('Connexion'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show error on invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginView(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Verify error message
      expect(find.text('Format email invalide'), findsOneWidget);
    });
  });
}
```

### Bonnes Pratiques de Code

#### Architecture
- **Single Responsibility** : Une classe = une responsabilité
- **Dependency Inversion** : Dépendre des abstractions, pas des implémentations
- **SOLID Principles** : Respecter les 5 principes SOLID

#### Flutter Spécifique
```dart
// ✅ BON : Utiliser const pour les widgets statiques
const Text('Hello World');

// ❌ MAUVAIS : Ne pas utiliser const
Text('Hello World');

// ✅ BON : Utiliser Keys pour les tests
ElevatedButton(
  key: const Key('login_button'),
  onPressed: () {},
  child: const Text('Login'),
);

// ✅ BON : Gestion d'état réactive
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const CircularProgressIndicator();
        }
        return Text(viewModel.data);
      },
    );
  }
}
```

#### Gestion d'Erreurs
```dart
// ✅ BON : Gestion d'erreurs structurée
try {
  final result = await repository.getData();
  return Right(result);
} catch (e) {
  return Left(ServerFailure(e.toString()));
}

// ✅ BON : Utilisation de Either pour les erreurs
class AuthViewModel extends ChangeNotifier {
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _loginUseCase.execute(email, password);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
        );
      },
    );

    notifyListeners();
  }
}
```

## 🚀 Déploiement

### Build de Production

#### Android APK
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommandé)
flutter build appbundle --release

# Installation sur device
flutter install --release
```

#### iOS
```bash
# Build pour iOS
flutter build ios --release

# Ouverture dans Xcode
open ios/Runner.xcworkspace
```

#### Web
```bash
# Build web
flutter build web --release

# Déploiement Firebase Hosting
firebase deploy --only hosting --project mayegue-app
```

### Configuration par Environnement
```dart
// lib/core/config/environment_config.dart
class EnvironmentConfig {
  static late String environment;
  static late String apiBaseUrl;
  static late String firebaseProjectId;

  static void init() {
    const env = String.fromEnvironment('APP_ENVIRONMENT', defaultValue: 'development');

    switch (env) {
      case 'production':
        environment = 'production';
        apiBaseUrl = 'https://api.mayegue.com';
        firebaseProjectId = 'mayegue-prod';
        break;
      case 'staging':
        environment = 'staging';
        apiBaseUrl = 'https://staging-api.mayegue.com';
        firebaseProjectId = 'mayegue-staging';
        break;
      default: // development
        environment = 'development';
        apiBaseUrl = 'http://localhost:3000';
        firebaseProjectId = 'mayegue-dev';
    }
  }
}
```

### CI/CD avec GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.0.0'

      - name: Build Android
        run: |
          flutter pub get
          flutter build appbundle --release

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
          packageName: com.mayegue.app
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
```

## 🔧 Maintenance et Debugging

### Outils de Debugging
```dart
// Debug prints conditionnels
void debugLog(String message) {
  if (kDebugMode) {
    print('[DEBUG] $message');
  }
}

// Logging structuré
class Logger {
  static void info(String message, [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      print('[INFO] $message');
      if (data != null) print('[DATA] $data');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    print('[ERROR] $message');
    if (error != null) print('[ERROR_DETAILS] $error');
    if (stackTrace != null) print('[STACK_TRACE] $stackTrace');
  }
}
```

### Performance Monitoring
```dart
// Monitoring des performances
class PerformanceMonitor {
  static Stopwatch _stopwatch = Stopwatch();

  static void startTracking(String operation) {
    _stopwatch.reset();
    _stopwatch.start();
    debugLog('Started: $operation');
  }

  static void stopTracking(String operation) {
    _stopwatch.stop();
    final elapsed = _stopwatch.elapsedMilliseconds;
    debugLog('Completed: $operation in ${elapsed}ms');

    // Log to analytics if slow
    if (elapsed > 1000) {
      AnalyticsService.logEvent('slow_operation', {
        'operation': operation,
        'duration_ms': elapsed,
      });
    }
  }
}
```

### Gestion des Versions
```yaml
# pubspec.yaml
name: mayegue
description: Application d'apprentissage des langues camerounaises
version: 1.0.0+1  # versionName + versionCode

# Versionnement sémantique
# Majeure.Mineure.Patch+Build
# 1.0.0+1 = Version 1.0.0, Build 1
```

## 📚 Ressources Utiles

### Documentation Officielle
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)

### Outils et Libraries
- [Dart DevTools](https://flutter.dev/docs/development/tools/devtools)
- [Flutter Inspector](https://flutter.dev/docs/development/tools/devtools/inspector)
- [Bloc Library](https://bloclibrary.dev/)
- [Riverpod](https://riverpod.dev/)

### Communauté
- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://www.reddit.com/r/FlutterDev/)

Ce guide constitue la référence pour tous les développeurs travaillant sur Mayegue. Respectez ces conventions pour maintenir la qualité et la cohérence du code.