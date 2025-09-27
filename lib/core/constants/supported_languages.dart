/// Supported traditional Cameroonian languages
class SupportedLanguages {
  static const Map<String, LanguageInfo> languages = {
    'ewondo': LanguageInfo(
      code: 'ewondo',
      name: 'Ewondo',
      nativeName: 'Ewondo',
      flag: '🇨🇲',
      region: 'Centre',
      speakers: 1200000,
      difficulty: LanguageDifficulty.intermediate,
      description: 'Langue bantoue parlée principalement dans la région du Centre du Cameroun',
      culturalInfo: 'Langue traditionnelle des peuples Beti-Fang du centre du Cameroun',
    ),
    'duala': LanguageInfo(
      code: 'duala',
      name: 'Duala',
      nativeName: 'Duálá',
      flag: '🇨🇲',
      region: 'Littoral',
      speakers: 800000,
      difficulty: LanguageDifficulty.intermediate,
      description: 'Langue bantoue parlée principalement dans la région du Littoral',
      culturalInfo: 'Langue des peuples Sawa de la côte camerounaise, importante pour le commerce',
    ),
    'bafang': LanguageInfo(
      code: 'bafang',
      name: 'Bafang',
      nativeName: 'Bafang',
      flag: '🇨🇲',
      region: 'Ouest',
      speakers: 400000,
      difficulty: LanguageDifficulty.beginner,
      description: 'Langue parlée dans la région de l\'Ouest du Cameroun',
      culturalInfo: 'Langue des hauts plateaux de l\'Ouest, riche en traditions orales',
    ),
    'fulfulde': LanguageInfo(
      code: 'fulfulde',
      name: 'Fulfulde',
      nativeName: 'Fulfulde',
      flag: '🇨🇲',
      region: 'Nord, Adamaoua',
      speakers: 2500000,
      difficulty: LanguageDifficulty.advanced,
      description: 'Langue peule parlée dans les régions du Nord et de l\'Adamaoua',
      culturalInfo: 'Langue des peuples Peuls, nomades et éleveurs traditionnels',
    ),
    'bassa': LanguageInfo(
      code: 'bassa',
      name: 'Bassa',
      nativeName: 'Basaá',
      flag: '🇨🇲',
      region: 'Centre, Littoral',
      speakers: 300000,
      difficulty: LanguageDifficulty.intermediate,
      description: 'Langue bantoue parlée dans les régions du Centre et du Littoral',
      culturalInfo: 'Langue des peuples Bassa, connue pour ses traditions musicales',
    ),
    'bamum': LanguageInfo(
      code: 'bamum',
      name: 'Bamum',
      nativeName: 'Shümom',
      flag: '🇨🇲',
      region: 'Ouest',
      speakers: 215000,
      difficulty: LanguageDifficulty.advanced,
      description: 'Langue parlée dans la région de l\'Ouest, royaume de Bamoun',
      culturalInfo: 'Langue du royaume historique de Bamoun, avec sa propre écriture traditionnelle',
    ),
  };

  /// Get all language codes
  static List<String> get languageCodes => languages.keys.toList();

  /// Get all language names
  static List<String> get languageNames => languages.values.map((l) => l.name).toList();

  /// Get language info by code
  static LanguageInfo? getLanguageInfo(String code) => languages[code.toLowerCase()];

  /// Get display name for a language code
  static String getDisplayName(String code) {
    final info = getLanguageInfo(code);
    return info?.name ?? code.toUpperCase();
  }

  /// Get native name for a language code
  static String getNativeName(String code) {
    final info = getLanguageInfo(code);
    return info?.nativeName ?? code.toUpperCase();
  }

  /// Get flag emoji for a language code
  static String getFlag(String code) {
    final info = getLanguageInfo(code);
    return info?.flag ?? '🇨🇲';
  }

  /// Get region for a language code
  static String getRegion(String code) {
    final info = getLanguageInfo(code);
    return info?.region ?? 'Cameroun';
  }

  /// Get difficulty level for a language code
  static LanguageDifficulty getDifficulty(String code) {
    final info = getLanguageInfo(code);
    return info?.difficulty ?? LanguageDifficulty.intermediate;
  }

  /// Check if a language code is supported
  static bool isSupported(String code) => languages.containsKey(code.toLowerCase());

  /// Get languages by difficulty
  static List<LanguageInfo> getLanguagesByDifficulty(LanguageDifficulty difficulty) {
    return languages.values.where((lang) => lang.difficulty == difficulty).toList();
  }

  /// Get languages by region
  static List<LanguageInfo> getLanguagesByRegion(String region) {
    return languages.values
        .where((lang) => lang.region.toLowerCase().contains(region.toLowerCase()))
        .toList();
  }

  /// Get default language code
  static String get defaultLanguage => 'ewondo';

  /// Get popular languages (by speaker count)
  static List<LanguageInfo> getPopularLanguages() {
    final sorted = languages.values.toList()
      ..sort((a, b) => b.speakers.compareTo(a.speakers));
    return sorted;
  }
}

/// Language information model
class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String region;
  final int speakers;
  final LanguageDifficulty difficulty;
  final String description;
  final String culturalInfo;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.region,
    required this.speakers,
    required this.difficulty,
    required this.description,
    required this.culturalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
      'region': region,
      'speakers': speakers,
      'difficulty': difficulty.index,
      'description': description,
      'culturalInfo': culturalInfo,
    };
  }

  factory LanguageInfo.fromJson(Map<String, dynamic> json) {
    return LanguageInfo(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
      flag: json['flag'] as String,
      region: json['region'] as String,
      speakers: json['speakers'] as int,
      difficulty: LanguageDifficulty.values[json['difficulty'] as int],
      description: json['description'] as String,
      culturalInfo: json['culturalInfo'] as String,
    );
  }
}

/// Language learning difficulty levels
enum LanguageDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

/// Extension for difficulty display
extension LanguageDifficultyExtension on LanguageDifficulty {
  String get displayName {
    switch (this) {
      case LanguageDifficulty.beginner:
        return 'Débutant';
      case LanguageDifficulty.intermediate:
        return 'Intermédiaire';
      case LanguageDifficulty.advanced:
        return 'Avancé';
      case LanguageDifficulty.expert:
        return 'Expert';
    }
  }

  String get description {
    switch (this) {
      case LanguageDifficulty.beginner:
        return 'Parfait pour commencer';
      case LanguageDifficulty.intermediate:
        return 'Quelques bases recommandées';
      case LanguageDifficulty.advanced:
        return 'Expérience linguistique requise';
      case LanguageDifficulty.expert:
        return 'Pour les apprenants expérimentés';
    }
  }

  int get levelNumber => index + 1;
}