import 'dart:async';
import 'package:flutter/foundation.dart';

enum PomodoroState { idle, running, paused, finished }

class PomodoroProvider extends ChangeNotifier {
  int _workDuration = 25; // dakika
  int _breakDuration = 5; // dakika
  int _remainingSeconds = 25 * 60;
  bool _isBreak = false;
  PomodoroState _state = PomodoroState.idle;
  Timer? _timer;

  // Getter'lar
  int get remainingSeconds => _remainingSeconds;
  bool get isBreak => _isBreak;
  PomodoroState get state => _state;
  int get workDuration => _workDuration;
  int get breakDuration => _breakDuration;

  // Dakika ve saniye gösterimi için
  String get timeDisplay {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Süreleri güncelle (SettingsProvider'dan çağrılır)
  void updateDurations(int workMin, int breakMin) {
    _workDuration = workMin;
    _breakDuration = breakMin;
    reset();
  }

  // Zamanlayıcıyı başlat
  void start() {
    if (_state == PomodoroState.idle || _state == PomodoroState.paused) {
      _state = PomodoroState.running;
      _timer = Timer.periodic(const Duration(seconds: 1), _tick);
      notifyListeners();
    }
  }

  // Zamanlayıcıyı duraklat
  void pause() {
    if (_state == PomodoroState.running) {
      _timer?.cancel();
      _state = PomodoroState.paused;
      notifyListeners();
    }
  }

  // Zamanlayıcıyı sıfırla
  void reset() {
    _timer?.cancel();
    _isBreak = false;
    _state = PomodoroState.idle;
    _remainingSeconds = _workDuration * 60;
    notifyListeners();
  }

  // Her saniye çağrılır
  void _tick(Timer timer) {
    if (_remainingSeconds > 0) {
      _remainingSeconds--;
      notifyListeners();
    } else {
      _timer?.cancel();
      _state = PomodoroState.finished;
      notifyListeners();
    }
  }

  // Molaya geç
  void startBreak() {
    _isBreak = true;
    _remainingSeconds = _breakDuration * 60;
    _state = PomodoroState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}