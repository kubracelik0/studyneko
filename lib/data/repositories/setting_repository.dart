import '../dao/setting_dao.dart';
import '../models/setting.dart';

class SettingRepository {
  final SettingDao _dao = SettingDao();

  Future<int> getPomodoroDuration() async {
    final setting = await _dao.getByKey('pomodoro_duration');
    return int.parse(setting?.value ?? '25');
  }

  Future<int> getBreakDuration() async {
    final setting = await _dao.getByKey('break_duration');
    return int.parse(setting?.value ?? '5');
  }

  Future<String> getTheme() async {
    final setting = await _dao.getByKey('theme');
    return setting?.value ?? 'light';
  }

  Future<int> getDailyGoal() async {
    final setting = await _dao.getByKey('daily_goal');
    return int.parse(setting?.value ?? '120');
  }

  Future<int> getStreak() async {
    final setting = await _dao.getByKey('streak');
    return int.parse(setting?.value ?? '0');
  }

  Future<String> getLastStudyDate() async {
    final setting = await _dao.getByKey('last_study_date');
    return setting?.value ?? '';
  }

  Future<void> updatePomodoroDuration(int minutes) async {
    await _dao.update(Setting(key: 'pomodoro_duration', value: '$minutes'));
  }

  Future<void> updateBreakDuration(int minutes) async {
    await _dao.update(Setting(key: 'break_duration', value: '$minutes'));
  }

  Future<void> updateTheme(String theme) async {
    await _dao.update(Setting(key: 'theme', value: theme));
  }

  Future<void> updateDailyGoal(int minutes) async {
    await _dao.update(Setting(key: 'daily_goal', value: '$minutes'));
  }

  Future<void> updateStreak(int streak) async {
    await _dao.update(Setting(key: 'streak', value: '$streak'));
  }

  Future<void> updateLastStudyDate(String date) async {
    await _dao.update(Setting(key: 'last_study_date', value: date));
  }

  Future<int> getTotalXP() async {
    final setting = await _dao.getByKey('total_xp');
    return int.parse(setting?.value ?? '0');
  }

  Future<int> getCatLevel() async {
    final setting = await _dao.getByKey('cat_level');
    return int.parse(setting?.value ?? '1');
  }

  Future<String> getCatName() async {
    final setting = await _dao.getByKey('cat_name');
    return setting?.value ?? 'Neko Scholar';
  }

  Future<void> updateTotalXP(int xp) async {
    await _dao.update(Setting(key: 'total_xp', value: '$xp'));
  }

  Future<void> updateCatLevel(int level) async {
    await _dao.update(Setting(key: 'cat_level', value: '$level'));
  }

  Future<void> updateCatName(String name) async {
    await _dao.update(Setting(key: 'cat_name', value: name));
  }
}