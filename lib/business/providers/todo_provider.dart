import 'package:flutter/foundation.dart';
import '../../data/models/todo.dart';
import '../../data/repositories/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepository _repository = TodoRepository();

  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  // Tamamlanan todo sayısı
  int get completedCount =>
      _todos.where((t) => t.isCompleted).length;

  // Toplam todo sayısı
  int get totalCount => _todos.length;

  // Tamamlanma yüzdesi
  double get completionRate {
    if (_todos.isEmpty) return 0;
    return completedCount / totalCount;
  }

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    _todos = await _repository.getTodayTodos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String title, {String? subject}) async {
    if (title.trim().isEmpty) return;
    await _repository.addTodo(title.trim(), subject: subject);
    await loadTodos();
  }

  Future<void> toggleTodo(int id, bool currentStatus) async {
    await _repository.toggleTodo(id, currentStatus);
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await _repository.deleteTodo(id);
    await loadTodos();
  }
}