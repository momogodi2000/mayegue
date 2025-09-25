import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Local SQLite database helper for offline data storage
class DatabaseHelper {
  static const String _databaseName = 'mayegue.db';
  static const int _databaseVersion = 1;

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        display_name TEXT,
        photo_url TEXT,
        role TEXT NOT NULL DEFAULT 'learner',
        languages TEXT, -- JSON array of language codes
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_sync TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Lessons table
    await db.execute('''
      CREATE TABLE lessons (
        id TEXT PRIMARY KEY,
        course_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        order_index INTEGER NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        estimated_duration INTEGER,
        thumbnail_url TEXT,
        contents TEXT, -- JSON array of lesson contents
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_sync TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Progress table
    await db.execute('''
      CREATE TABLE progress (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        lesson_id TEXT NOT NULL,
        course_id TEXT NOT NULL,
        progress_percentage REAL DEFAULT 0,
        completed_at TEXT,
        score REAL,
        time_spent INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_sync TEXT,
        is_synced INTEGER DEFAULT 0,
        UNIQUE(user_id, lesson_id)
      )
    ''');

    // Dictionary table
    await db.execute('''
      CREATE TABLE dictionary (
        id TEXT PRIMARY KEY,
        word TEXT NOT NULL,
        language_code TEXT NOT NULL,
        translation TEXT,
        phonetic TEXT,
        audio_url TEXT,
        examples TEXT, -- JSON array
        category TEXT,
        difficulty TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_sync TEXT,
        is_synced INTEGER DEFAULT 0,
        UNIQUE(word, language_code)
      )
    ''');

    // Chat messages table
    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        sender_id TEXT NOT NULL,
        message TEXT NOT NULL,
        message_type TEXT DEFAULT 'text',
        timestamp TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        last_sync TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Sync operations queue
    await db.execute('''
      CREATE TABLE sync_operations (
        id TEXT PRIMARY KEY,
        operation_type TEXT NOT NULL, -- INSERT, UPDATE, DELETE
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        data TEXT, -- JSON data
        timestamp TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        status TEXT DEFAULT 'pending' -- pending, success, failed
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
    if (oldVersion < newVersion) {
      // Add migration logic
    }
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }

  /// Clear all data (for testing or reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.execute('DELETE FROM users');
    await db.execute('DELETE FROM lessons');
    await db.execute('DELETE FROM progress');
    await db.execute('DELETE FROM dictionary');
    await db.execute('DELETE FROM chat_messages');
    await db.execute('DELETE FROM sync_operations');
  }
}
