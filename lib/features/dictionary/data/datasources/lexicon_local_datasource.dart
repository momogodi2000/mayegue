import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/dictionary_entry_model.dart';
import '../../domain/entities/dictionary_entry_entity.dart';

/// Local data source for dictionary entries using SQLite
abstract class LexiconLocalDataSource {
  Future<List<DictionaryEntryModel>> getAllEntries();
  Future<List<DictionaryEntryModel>> getEntriesByLanguage(String languageCode);
  Future<DictionaryEntryModel?> getEntry(String id);
  Future<List<DictionaryEntryModel>> searchEntries({
    String? query,
    String? languageCode,
    DifficultyLevel? difficulty,
    ReviewStatus? status,
    List<String>? tags,
    int? limit,
    int? offset,
  });
  Future<void> insertEntry(DictionaryEntryModel entry);
  Future<void> insertEntries(List<DictionaryEntryModel> entries);
  Future<void> updateEntry(DictionaryEntryModel entry);
  Future<void> deleteEntry(String id);
  Future<void> markAsDeleted(String id, DateTime deletedAt);
  Future<List<DictionaryEntryModel>> getPendingSyncEntries();
  Future<List<DictionaryEntryModel>> getConflictEntries();
  Future<void> markAsSynced(String id);
  Future<void> markAsConflict(String id, Map<String, dynamic> conflictData);
  Future<void> resolveConflict(String id, DictionaryEntryModel resolvedEntry);
  Future<int> getEntriesCount({String? languageCode, ReviewStatus? status});
  Future<void> clearAll();
}

class LexiconLocalDataSourceImpl implements LexiconLocalDataSource {
  final Database database;

  LexiconLocalDataSourceImpl({required this.database});

  static const String _tableName = 'dictionary_entries';

  @override
  Future<List<DictionaryEntryModel>> getAllEntries() async {
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'is_deleted = ?',
      whereArgs: [0],
      orderBy: 'canonical_form ASC',
    );

    return maps.map((map) => DictionaryEntryModel.fromSQLite(map)).toList();
  }

  @override
  Future<List<DictionaryEntryModel>> getEntriesByLanguage(String languageCode) async {
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'language_code = ? AND is_deleted = ?',
      whereArgs: [languageCode, 0],
      orderBy: 'canonical_form ASC',
    );

    return maps.map((map) => DictionaryEntryModel.fromSQLite(map)).toList();
  }

  @override
  Future<DictionaryEntryModel?> getEntry(String id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'id = ? AND is_deleted = ?',
      whereArgs: [id, 0],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return DictionaryEntryModel.fromSQLite(maps.first);
    }
    return null;
  }

  @override
  Future<List<DictionaryEntryModel>> searchEntries({
    String? query,
    String? languageCode,
    DifficultyLevel? difficulty,
    ReviewStatus? status,
    List<String>? tags,
    int? limit,
    int? offset,
  }) async {
    String whereClause = 'is_deleted = ?';
    List<dynamic> whereArgs = [0];

    if (query != null && query.isNotEmpty) {
      whereClause += ' AND (canonical_form LIKE ? OR search_terms LIKE ?)';
      whereArgs.addAll(['%$query%', '%$query%']);
    }

    if (languageCode != null) {
      whereClause += ' AND language_code = ?';
      whereArgs.add(languageCode);
    }

    if (difficulty != null) {
      whereClause += ' AND difficulty_level = ?';
      whereArgs.add(difficulty.toString().split('.').last);
    }

    if (status != null) {
      whereClause += ' AND review_status = ?';
      whereArgs.add(status.toString().split('.').last);
    }

    if (tags != null && tags.isNotEmpty) {
      // Simple tag search - check if any tag is contained in the tags JSON
      for (String tag in tags) {
        whereClause += ' AND tags LIKE ?';
        whereArgs.add('%"$tag"%');
      }
    }

    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'canonical_form ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => DictionaryEntryModel.fromSQLite(map)).toList();
  }

  @override
  Future<void> insertEntry(DictionaryEntryModel entry) async {
    await database.insert(
      _tableName,
      entry.toSQLite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertEntries(List<DictionaryEntryModel> entries) async {
    final batch = database.batch();
    for (final entry in entries) {
      batch.insert(
        _tableName,
        entry.toSQLite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  @override
  Future<void> updateEntry(DictionaryEntryModel entry) async {
    await database.update(
      _tableName,
      entry.toSQLite(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  @override
  Future<void> deleteEntry(String id) async {
    await database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markAsDeleted(String id, DateTime deletedAt) async {
    await database.update(
      _tableName,
      {
        'is_deleted': 1,
        'deleted_at': deletedAt.millisecondsSinceEpoch,
        'needs_sync': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<DictionaryEntryModel>> getPendingSyncEntries() async {
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'needs_sync = ? AND has_conflict = ?',
      whereArgs: [1, 0],
      orderBy: 'last_updated ASC',
    );

    return maps.map((map) => DictionaryEntryModel.fromSQLite(map)).toList();
  }

  @override
  Future<List<DictionaryEntryModel>> getConflictEntries() async {
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'has_conflict = ?',
      whereArgs: [1],
      orderBy: 'last_updated DESC',
    );

    return maps.map((map) => DictionaryEntryModel.fromSQLite(map)).toList();
  }

  @override
  Future<void> markAsSynced(String id) async {
    await database.update(
      _tableName,
      {
        'needs_sync': 0,
        'last_synced': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markAsConflict(String id, Map<String, dynamic> conflictData) async {
    await database.update(
      _tableName,
      {
        'has_conflict': 1,
        'conflict_data': jsonEncode(conflictData),
        'needs_sync': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> resolveConflict(String id, DictionaryEntryModel resolvedEntry) async {
    await database.update(
      _tableName,
      {
        ...resolvedEntry.toSQLite(),
        'has_conflict': 0,
        'conflict_data': null,
        'needs_sync': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getEntriesCount({String? languageCode, ReviewStatus? status}) async {
    String whereClause = 'is_deleted = ?';
    List<dynamic> whereArgs = [0];

    if (languageCode != null) {
      whereClause += ' AND language_code = ?';
      whereArgs.add(languageCode);
    }

    if (status != null) {
      whereClause += ' AND review_status = ?';
      whereArgs.add(status.toString().split('.').last);
    }

    final result = await database.query(
      _tableName,
      columns: ['COUNT(*) as count'],
      where: whereClause,
      whereArgs: whereArgs,
    );

    return result.first['count'] as int;
  }

  @override
  Future<void> clearAll() async {
    await database.delete(_tableName);
  }
}

/// Extension to add SQLite serialization methods to DictionaryEntryModel
extension DictionaryEntryModelSQLite on DictionaryEntryModel {
  Map<String, dynamic> toSQLite() {
    return {
      'id': id,
      'language_code': languageCode,
      'canonical_form': canonicalForm,
      'orthography_variants': jsonEncode(orthographyVariants),
      'ipa': ipa,
      'audio_file_references': jsonEncode(audioFileReferences),
      'part_of_speech': partOfSpeech,
      'translations': jsonEncode(translations),
      'example_sentences': jsonEncode(exampleSentences.map((e) => e.toJson()).toList()),
      'tags': jsonEncode(tags),
      'difficulty_level': difficultyLevel.toString().split('.').last,
      'contributor_id': contributorId,
      'review_status': reviewStatus.toString().split('.').last,
      'verified_by': verifiedBy,
      'quality_score': qualityScore,
      'last_updated': lastUpdated.millisecondsSinceEpoch,
      'source_reference': sourceReference,
      'metadata': jsonEncode(metadata),
      'search_terms': generateSearchTerms().join(' '),
      'is_deleted': 0,
      'needs_sync': 1,
      'has_conflict': 0,
      'conflict_data': null,
      'last_synced': null,
      'deleted_at': null,
    };
  }

  static DictionaryEntryModel fromSQLite(Map<String, dynamic> map) {
    return DictionaryEntryModel(
      id: map['id'] as String,
      languageCode: map['language_code'] as String,
      canonicalForm: map['canonical_form'] as String,
      orthographyVariants: List<String>.from(jsonDecode(map['orthography_variants'] ?? '[]')),
      ipa: map['ipa'] as String?,
      audioFileReferences: List<String>.from(jsonDecode(map['audio_file_references'] ?? '[]')),
      partOfSpeech: map['part_of_speech'] as String,
      translations: Map<String, String>.from(jsonDecode(map['translations'] ?? '{}')),
      exampleSentences: (jsonDecode(map['example_sentences'] ?? '[]') as List)
          .map((e) => ExampleSentence.fromJson(e))
          .toList(),
      tags: List<String>.from(jsonDecode(map['tags'] ?? '[]')),
      difficultyLevel: DifficultyLevel.values.firstWhere(
        (e) => e.toString().split('.').last == map['difficulty_level'],
        orElse: () => DifficultyLevel.beginner,
      ),
      contributorId: map['contributor_id'] as String?,
      reviewStatus: ReviewStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['review_status'],
        orElse: () => ReviewStatus.draft,
      ),
      verifiedBy: map['verified_by'] as String?,
      qualityScore: (map['quality_score'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['last_updated'] as int),
      sourceReference: map['source_reference'] as String?,
      metadata: Map<String, dynamic>.from(jsonDecode(map['metadata'] ?? '{}')),
    );
  }
}