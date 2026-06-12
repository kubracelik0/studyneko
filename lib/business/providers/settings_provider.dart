import 'package:flutter/foundation.dart';
import '../../data/repositories/setting_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingRepository _repository = SettingRepository();

  int _pomodoroDuration = 25;
  int _breakDuration = 5;
  int _dailyGoal = 120;
  bool _isDarkMode = false;

  int get pomodoroDuration => _pomodoroDuration;
  int get breakDuration => _breakDuration;
  int get dailyGoal => _dailyGoal;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadSettings() async {
    _pomodoroDuration = await _repository.getPomodoroDuration();
    _breakDuration = await _repository.getBreakDuration();
    _dailyGoal = await _repository.getDailyGoal();
    final theme = await _repository.getTheme();
    _isDarkMode = theme == 'dark';
    notifyListeners();
  }

  Future<void> updatePomodoroDuration(int minutes) async {
    _pomodoroDuration = minutes;
    await _repository.updatePomodoroDuration(minutes);
    notifyListeners();
  }

  Future<void> updateBreakDuration(int minutes) async {
    _breakDuration = minutes;
    await _repository.updateBreakDuration(minutes);
    notifyListeners();
  }

  Future<void> updateDailyGoal(int minutes) async {
    _dailyGoal = minutes;
    await _repository.updateDailyGoal(minutes);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _repository.updateTheme(_isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }
}