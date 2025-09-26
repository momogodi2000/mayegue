// Basic Flutter widget test for Mayegue app
//
// This test ensures the main app widget can be built without errors.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mayegue/main.dart';
import 'package:mayegue/shared/providers/app_providers.dart';
import 'package:mayegue/core/config/environment_config.dart';

void main() {
  setUpAll(() async {
    // Initialize environment config for tests
    await EnvironmentConfig.init();
  });

  testWidgets('App builds and shows initial screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: getProviders(),
        child: const MyApp(),
      ),
    );

    // Wait for initialization
    await tester.pumpAndSettle();

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // Check for common UI elements that should be present
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('App supports localization', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: getProviders(),
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify localization is set up
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.localizationsDelegates, isNotNull);
    expect(materialApp.supportedLocales, isNotEmpty);
  });
}
