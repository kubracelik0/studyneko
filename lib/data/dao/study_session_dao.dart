import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/study_session.dart';

class StudySessionDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(StudySession session) async {
    final Database db = await _dbHelper.database;
    return await db.insert(
      'study_sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<StudySession>> getAll() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'study_sessions',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => StudySession.fromMap(map)).toList();
  }

  Future<List<StudySession>> getByDate(String date) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'study_sessions',
      where: 'date = ?',
      whereArgs: [date],
    );
    return maps.map((map) => StudySession.fromMap(map)).toList();
  }

  Future<List<StudySession>> getLastSevenDays() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM study_sessions
      WHERE date >= date('now', '-7 days')
      ORDER BY date DESC
    ''');
    return maps.map((map) => StudySession.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    final Database db = await _dbHelper.database;
    return await db.delete(
      'study_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTotalDuration() async {
    final Database db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(duration) as total FROM study_sessions',
    );
    return result.first['total'] as int? ?? 0;
  }
}