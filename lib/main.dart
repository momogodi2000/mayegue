import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/router.dart';
import 'core/config/environment_config.dart';
import 'core/database/database_initialization_service.dart';
import 'core/database/data_seeding_service.dart';
import 'shared/providers/app_providers.dart';
import 'shared/themes/app_theme.dart';
import 'shared/providers/theme_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  await EnvironmentConfig.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize databases and seed data
  try {
    // Initialize the pre-built Cameroon languages database
    await DatabaseInitializationService.database;
    
    // Seed the main app database with initial data
    await DataSeedingService.seedDatabase();
  } catch (e) {
    // Log error but don't crash the app
    debugPrint('Error initializing databases: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Mayegue',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.createRouter(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('fr'), // French
            ],
          );
        },
      ),
    );
  }
}
