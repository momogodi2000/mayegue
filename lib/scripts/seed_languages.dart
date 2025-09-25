import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import '../core/utils/language_seeder.dart';

/// Command-line script to seed languages data
/// Run with: dart run lib/scripts/seed_languages.dart
void main() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Create seeder instance
    final seeder = LanguageSeeder(FirebaseFirestore.instance);

    print('🌍 Starting language seeding process...');

    // Optional: Clear existing data (uncomment if needed)
    // print('🧹 Clearing existing languages...');
    // await seeder.clearLanguages();

    // Seed new data
    print('📝 Seeding traditional Cameroonian languages...');
    await seeder.seedLanguages();

    print('✅ Language seeding completed successfully!');
    print('');
    print('Seeded languages:');
    print('  • Ewondo (Beti-Pahuin) - Centre region');
    print('  • Duala (Coastal Bantu) - Littoral region');
    print('  • Bafang/Fe\'efe\'e (Grassfields) - Ouest region');
    print('  • Fufulde (Niger-Congo) - Nord region');
    print('  • Bassa (A40 Bantu) - Centre-Littoral region');
    print('  • Bamum (Grassfields) - Ouest region');

  } catch (e) {
    print('❌ Error during seeding: $e');
    exit(1);
  }
}
