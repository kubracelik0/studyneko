import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/todo.dart';

class TodoDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Todo ekle
  Future<int> insert(Todo todo) async {
    final Database db = await _dbHelper.database;
    return await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Bugünün todo'larını getir
  Future<List<Todo>> getByDate(String date) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'id ASC',
    );
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  // Tüm todo'ları getir
  Future<List<Todo>> getAll() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      orderBy: 'date DESC, id ASC',
    );
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  // Tamamlanma durumunu güncelle
  Future<int> updateCompleted(int id, bool isCompleted) async {
    final Database db = await _dbHelper.database;
    return await db.update(
      'todos',
      {'is_completed': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Todo sil
  Future<int> delete(int id) async {
    final Database db = await _dbHelper.database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Bugün tamamlanan todo sayısı
  Future<int> getCompletedCountByDate(String date) async {
    final Database db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM todos WHERE date = ? AND is_completed = 1',
      [date],
    );
    return result.first['count'] as int? ?? 0;
  }
}