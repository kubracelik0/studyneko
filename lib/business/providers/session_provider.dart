import 'package:flutter/foundation.dart';
import '../../data/models/study_session.dart';
import '../../data/repositories/study_session_repository.dart';
import '../../data/repositories/setting_repository.dart';

class SessionProvider extends ChangeNotifier {
  final StudySessionRepository _repository = StudySessionRepository();
  final SettingRepository _settingRepository = SettingRepository();

  List<StudySession> _allSessions = [];
  List<StudySession> _todaySessions = [];
  List<StudySession> _weeklySessions = [];
  int _todayTotalDuration = 0;
  int _weeklyTotalDuration = 0;
  int _todayPomodoroCount = 0;
  int _streak = 0;
  int _dailyGoal = 120;
  int _totalXP = 0;
  int _catLevel = 1;
  String _catName = 'Neko Scholar';
  bool _isLoading = false;

  List<StudySession> get allSessions => _allSessions;
  List<StudySession> get todaySessions => _todaySessions;
  List<StudySession> get weeklySessions => _weeklySessions;
  int get todayTotalDuration => _todayTotalDuration;
  int get weeklyTotalDuration => _weeklyTotalDuration;
  int get todayPomodoroCount => _todayPomodoroCount;
  int get streak => _streak;
  int get dailyGoal => _dailyGoal;
  int get totalXP => _totalXP;
  int get catLevel => _catLevel;
  String get catName => _catName;
  bool get isLoading => _isLoading;

  double get goalProgress {
    if (_dailyGoal == 0) return 0;
    final progress = _todayTotalDuration / _dailyGoal;
    return progress > 1.0 ? 1.0 : progress;
  }

  // Sonraki seviyeye kaç XP kaldı
  int get xpToNextLevel {
    const levels = [0, 100, 300, 600, 1000, 99999];
    if (_catLevel >= 5) return 0;
    return levels[_catLevel] - _totalXP;
  }

  // Mevcut seviye progress (0.0 - 1.0)
  double get catLevelProgress {
    const levels = [0, 100, 300, 600, 1000, 99999];
    if (_catLevel >= 5) return 1.0;
    final levelStart = levels[_catLevel - 1];
    final levelEnd = levels[_catLevel];
    final progress =
        (_totalXP - levelStart) / (levelEnd - levelStart);
    return progress.clamp(0.0, 1.0);
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _allSessions = await _repository.getAllSessions();
    _todaySessions = await _repository.getTodaySessions();
    _weeklySessions = await _repository.getWeeklySessions();
    _todayTotalDuration = await _repository.getTodayTotalDuration();
    _weeklyTotalDuration =
    await _repository.getWeeklyTotalDuration();
    _todayPomodoroCount =
    await _repository.getTodayPomodoroCount();
    _streak = await _settingRepository.getStreak();
    _dailyGoal = await _settingRepository.getDailyGoal();
    _totalXP = await _settingRepository.getTotalXP();
    _catLevel = await _settingRepository.getCatLevel();
    _catName = await _settingRepository.getCatName();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSession({
    required String subject,
    required int duration,
    required String sessionType,
    String? notes,
  }) async {
    await _repository.addSession(
      subject: subject,
      duration: duration,
      sessionType: sessionType,
      notes: notes,
    );

    // XP hesapla
    int earnedXP = 0;
    if (sessionType == 'pomodoro') {
      earnedXP = 25;
    } else {
      earnedXP = (duration / 30 * 10).toInt();
    }

    // Toplam XP güncelle
    final currentXP = await _settingRepository.getTotalXP();
    final newXP = currentXP + earnedXP;
    await _settingRepository.updateTotalXP(newXP);

    // Kedi seviyesini güncelle
    final newLevel = _calculateCatLevel(newXP);
    await _settingRepository.updateCatLevel(newLevel);

    await _updateStreak();
    await loadData();
  }

  Future<void> deleteSession(int id) async {
    await _repository.deleteSession(id);
    await loadData();
  }

  int _calculateCatLevel(int xp) {
    if (xp < 100) return 1;
    if (xp < 300) return 2;
    if (xp < 600) return 3;
    if (xp < 1000) return 4;
    return 5;
  }

  Future<void> _updateStreak() async {
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final lastDate = await _settingRepository.getLastStudyDate();

    if (lastDate == todayStr) return;

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    int currentStreak = await _settingRepository.getStreak();

    if (lastDate == yesterdayStr) {
      currentStreak++;
    } else {
      currentStreak = 1;
    }

    await _settingRepository.updateStreak(currentStreak);
    await _settingRepository.updateLastStudyDate(todayStr);
    _streak = currentStreak;
  }
}