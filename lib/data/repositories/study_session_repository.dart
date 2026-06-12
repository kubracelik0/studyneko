import '../dao/study_session_dao.dart';
import '../models/study_session.dart';

class StudySessionRepository {
  final StudySessionDao _dao = StudySessionDao();

  Future<int> addSession({
    required String subject,
    required int duration,
    required String sessionType,
    String? notes,
  }) async {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final session = StudySession(
      subject: subject,
      duration: duration,
      date: dateStr,
      sessionType: sessionType,
      createdAt: now.toIso8601String(),
      notes: notes,
    );
    return await _dao.insert(session);
  }

  Future<List<StudySession>> getAllSessions() async {
    return await _dao.getAll();
  }

  Future<List<StudySession>> getTodaySessions() async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return await _dao.getByDate(dateStr);
  }

  Future<List<StudySession>> getWeeklySessions() async {
    return await _dao.getLastSevenDays();
  }

  Future<int> deleteSession(int id) async {
    return await _dao.delete(id);
  }

  Future<int> getTodayTotalDuration() async {
    final sessions = await getTodaySessions();
    int total = 0;
    for (final s in sessions) {
      total += s.duration;
    }
    return total;
  }

  Future<int> getWeeklyTotalDuration() async {
    final sessions = await getWeeklySessions();
    int total = 0;
    for (final s in sessions) {
      total += s.duration;
    }
    return total;
  }

  Future<int> getTodayPomodoroCount() async {
    final sessions = await getTodaySessions();
    return sessions.where((s) => s.sessionType == 'pomodoro').length;
  }
}