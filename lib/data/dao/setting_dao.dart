import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/setting.dart';

class SettingDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Belirli bir ayarı getir
  Future<Setting?> getByKey(String key) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isEmpty) return null;
    return Setting.fromMap(maps.first);
  }

  // Ayarı güncelle
  Future<int> update(Setting setting) async {
    final Database db = await _dbHelper.database;
    return await db.update(
      'settings',
      setting.toMap(),
      where: 'key = ?',
      whereArgs: [setting.key],
    );
  }

  // Tüm ayarları getir
  Future<List<Setting>> getAll() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    return maps.map((map) => Setting.fromMap(map)).toList();
  }
}