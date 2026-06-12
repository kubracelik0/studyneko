import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'study_tracker_v2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Çalışma oturumları
    await db.execute('''
      CREATE TABLE study_sessions (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        subject      TEXT    NOT NULL,
        duration     INTEGER NOT NULL,
        date         TEXT    NOT NULL,
        session_type TEXT    NOT NULL,
        created_at   TEXT    NOT NULL,
        notes        TEXT
      )
    ''');

    // Ayarlar
    await db.execute('''
      CREATE TABLE settings (
        id    INTEGER PRIMARY KEY AUTOINCREMENT,
        key   TEXT NOT NULL UNIQUE,
        value TEXT NOT NULL
        INSERT INTO settings (key, value) VALUES
    ('pomodoro_duration', '25'),
    ('break_duration', '5'),
    ('theme', 'light'),
    ('daily_goal', '120'),
    ('streak', '0'),
    ('last_study_date', ''),
    ('total_xp', '0'),
    ('cat_level', '1'),
    ('cat_name', 'Neko Scholar')
      )
    ''');

    // To-Do listesi
    await db.execute('''
      CREATE TABLE todos (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        title        TEXT    NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        date         TEXT    NOT NULL,
        subject      TEXT
      )
    ''');

    // Varsayılan ayarlar
    await db.execute('''
      INSERT INTO settings (key, value) VALUES
        ('pomodoro_duration', '25'),
        ('break_duration', '5'),
        ('theme', 'light'),
        ('daily_goal', '120'),
        ('streak', '0'),
        ('last_study_date', '')
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}