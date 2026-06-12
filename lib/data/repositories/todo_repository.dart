import '../dao/todo_dao.dart';
import '../models/todo.dart';

class TodoRepository {
  final TodoDao _dao = TodoDao();

  String get _todayStr {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<List<Todo>> getTodayTodos() async {
    return await _dao.getByDate(_todayStr);
  }

  Future<void> addTodo(String title, {String? subject}) async {
    final todo = Todo(
      title: title,
      date: _todayStr,
      subject: subject,
    );
    await _dao.insert(todo);
  }

  Future<void> toggleTodo(int id, bool currentStatus) async {
    await _dao.updateCompleted(id, !currentStatus);
  }

  Future<void> deleteTodo(int id) async {
    await _dao.delete(id);
  }

  Future<int> getTodayCompletedCount() async {
    return await _dao.getCompletedCountByDate(_todayStr);
  }
}