import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../business/providers/session_provider.dart';
import '../../business/providers/todo_provider.dart';
import '../../core/theme/app_theme.dart';
import 'statistics_screen.dart';
import 'session_list_screen.dart';
import 'todo_screen.dart';
import 'pomodoro_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> _quotes = [
    '"Small steps lead to great achievements." 🌸',
    '"What you learn today is the foundation of tomorrow." ✨',
    '"Every study session brings you closer to your goal." 🎯',
    '"Perseverance and patience make everything possible." 💪',
    '"Stay focused, success is near!" 🌟',
    '"Studying is the best investment in your future." 🦋',
    '"It is a great day to do great things!" ⭐',
    '"Neko is with you, lets get started!" 🐱',
  ];

  String get _todayQuote {
    final index = DateTime.now().day % _quotes.length;
    return _quotes[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer2<SessionProvider, TodoProvider>(
        builder: (context, session, todo, child) {
          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async {
              await session.loadData();
              await todo.loadTodos();
            },
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context, session),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),
                      _buildCatCard(context, session),
                      const SizedBox(height: 16),
                      _buildQuoteCard(context),
                      const SizedBox(height: 16),
                      _buildDailyGoalCard(context, session),
                      const SizedBox(height: 16),
                      _buildStatsRow(context, session),
                      const SizedBox(height: 24),
                      _buildQuickActionsGrid(context),
                      const SizedBox(height: 24),
                      _buildRecentSessions(context, session),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(
      BuildContext context, SessionProvider session) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.background,
      elevation: 0,
      title: Text(
        'StudyNeko',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppTheme.primary,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                '${session.streak} day',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCatCard(
      BuildContext context, SessionProvider session) {
    final hour = DateTime.now().hour;
    String greeting;
    String subtext;
    if (hour < 12) {
      greeting = 'Good Morning! ☀️';
      subtext = 'A wonderful day is waiting for you~';
    } else if (hour < 18) {
      greeting = 'Have a great day! 🌤️';
      subtext = 'Ready to focus?';
    } else {
      greeting = 'Have a lovely evening! 🌙';
      subtext = 'You had a great day today too~ 🌸';
    }

    return Container(
      width: double.infinity,
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
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtext,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            'Study Streak  ${session.streak}',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📚',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            '${session.todaySessions.length} session',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('💬', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _todayQuote,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalCard(
      BuildContext context, SessionProvider session) {
    final progress = session.goalProgress;
    final done = session.todayTotalDuration;
    final goal = session.dailyGoal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Today\'s Goal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                '$done / $goal minutes',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppTheme.outline.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0
                    ? Colors.green.shade400
                    : AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            progress >= 1.0
                ? '🎉 You achieved your goal, great work!'
                : '${(progress * 100).toInt()}% Completed',
            style: GoogleFonts.quicksand(
              fontSize: 12,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      BuildContext context, SessionProvider session) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            emoji: '⏱️',
            label: 'TIME',
            value: '${session.todayTotalDuration} min',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            emoji: '🍅',
            label: 'POMODORO',
            value: '${session.todayPomodoroCount}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            emoji: '⭐',
            label: 'XP',
            value: '${session.streak * 25}',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, {
        required String emoji,
        required String label,
        required String value,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildActionCard(
              context,
              emoji: '🍅',
              label: 'Pomodoro',
              screen: const PomodoroScreen(),
            ),
            _buildActionCard(
              context,
              emoji: '✅',
              label: 'Tasks',
              screen: const TodoScreen(),
            ),
            _buildActionCard(
              context,
              emoji: '📊',
              label: 'Statistics',
              screen: const StatisticsScreen(),
            ),
            _buildActionCard(
              context,
              emoji: '📚',
              label: 'Sessions',
              screen: const SessionListScreen(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String emoji,
        required String label,
        required Widget screen,
      }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.outline, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessions(
      BuildContext context, SessionProvider session) {
    final sessions = session.todaySessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Sessions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border:
              Border.all(color: AppTheme.outline, width: 1.5),
            ),
            child: Center(
              child: Column(
                children: [
                  const Text('📖',
                      style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'No sessions yet\nLet\'s get started!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      color: AppTheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...sessions.take(3).map((s) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppTheme.outline, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      s.sessionType == 'pomodoro'
                          ? '🍅'
                          : '📖',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.subject,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      if (s.notes != null)
                        Text(
                          s.notes!,
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: AppTheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      Text(
                        s.date,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '${s.duration}min',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }
}