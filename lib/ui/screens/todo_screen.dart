import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../business/providers/todo_provider.dart';
import '../../business/providers/session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'StudyNeko',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded,
                color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer2<TodoProvider, SessionProvider>(
        builder: (context, todo, session, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(context, todo),
                const SizedBox(height: 20),
                _buildAddTodoBar(context, todo),
                const SizedBox(height: 24),
                _buildTodoList(context, todo),
                const SizedBox(height: 24),
                _buildBottomStats(context, session),
              ],
            ),
          );
        },
      ),
    );
  }

  // Top gradient header
  Widget _buildHeader(BuildContext context, TodoProvider todo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8A0BF), Color(0xFF7D5070)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s\nGoals',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'re doing great, Neko Scholar! 🐾',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              // Completion percentage
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(todo.completionRate * 100).toInt()}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Completed',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: todo.completionRate,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Todo add bar
  Widget _buildAddTodoBar(
      BuildContext context, TodoProvider todo) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: GoogleFonts.quicksand(
              color: AppTheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Add new task...',
              hintStyle: GoogleFonts.quicksand(
                color: AppTheme.onSurfaceVariant,
              ),
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                BorderSide(color: AppTheme.outline, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                BorderSide(color: AppTheme.outline, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                    color: AppTheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
            ),
            onSubmitted: (value) async {
              await todo.addTodo(value);
              _controller.clear();
            },
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            await todo.addTodo(_controller.text);
            _controller.clear();
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary,
            ),
            child: const Icon(Icons.add_rounded,
                color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  // Todo list
  Widget _buildTodoList(BuildContext context, TodoProvider todo) {
    final pending =
    todo.todos.where((t) => !t.isCompleted).toList();
    final completed =
    todo.todos.where((t) => t.isCompleted).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // To do
        if (pending.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_box_outline_blank_rounded,
                      color: AppTheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'To Do',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  '${pending.length} Tasks',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...pending.map((todo) =>
              _buildTodoItem(context,
                  todo, Provider.of<TodoProvider>(context,
                      listen: false))),
          const SizedBox(height: 20),
        ],

        // Completed
        if (completed.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Completed',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...completed.map((todo) =>
              _buildTodoItem(context, todo,
                  Provider.of<TodoProvider>(context,
                      listen: false))),
        ],

        // Empty state
        if (todo.todos.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text('📋',
                      style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can add a new task from above 🌸',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Single todo card
  Widget _buildTodoItem(
      BuildContext context,
      Todo todo,
      TodoProvider provider,
      ) {
    return Dismissible(
      key: Key('todo_${todo.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.red),
      ),
      onDismissed: (_) => provider.deleteTodo(todo.id!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: todo.isCompleted
              ? AppTheme.surfaceContainer
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: todo.isCompleted
                ? AppTheme.outline.withOpacity(0.5)
                : AppTheme.outline,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  provider.toggleTodo(todo.id!, todo.isCompleted),
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: todo.isCompleted
                      ? Colors.green
                      : Colors.transparent,
                  border: Border.all(
                    color: todo.isCompleted
                        ? Colors.green
                        : AppTheme.outline,
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? const Icon(Icons.check_rounded,
                    size: 14, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: todo.isCompleted
                          ? AppTheme.onSurfaceVariant
                          : AppTheme.onSurface,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (todo.isCompleted) ...[
                    const SizedBox(height: 4),
                    Text(
                      '✓ +15 XP Earned',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom stats
  Widget _buildBottomStats(
      BuildContext context, SessionProvider session) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2,
      children: [
        _buildStatCard(context, '⭐', '${session.streak * 25}',
            'Total XP'),
        _buildStatCard(
            context, '🔥', '${session.streak} Days', 'Streak'),
        _buildStatCard(
            context,
            '🏆',
            '${session.todayPomodoroCount * 2}',
            'Badges'),
        _buildStatCard(
            context,
            '❤️',
            '${Provider.of<TodoProvider>(context).completedCount}/5',
            'Tasks'),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String emoji,
      String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 11,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}