import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../business/providers/session_provider.dart';
import '../../business/providers/todo_provider.dart';
import '../../core/theme/app_theme.dart';


class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  List<Map<String, dynamic>> _getBadges(
      int totalXP,
      int streak,
      int pomodoroCount,
      int sessionCount,
      int todoCount,
      List sessions,
      ) {
    return [
      {
        'emoji': '🌱',
        'title': 'First Step',
        'desc': 'Complete the first study session',
        'unlocked': sessionCount >= 1,
        'progress': sessionCount >= 1 ? 1.0 : 0.0,
        'progressText': '$sessionCount/1 session',
        'color': Colors.green,
      },
      {
        'emoji': '🍅',
        'title': 'Pomodoro Master',
        'desc': 'Complete 10 Pomodoros',
        'unlocked': pomodoroCount >= 10,
        'progress': (pomodoroCount / 10).clamp(0.0, 1.0),
        'progressText': '$pomodoroCount/10 pomodoro',
        'color': Colors.red,
      },
      {
        'emoji': '🔥',
        'title': 'Determined',
        'desc': 'Do a 7-day study series',
        'unlocked': streak >= 7,
        'progress': (streak / 7).clamp(0.0, 1.0),
        'progressText': '$streak/7 days',
        'color': Colors.orange,
      },
      {
        'emoji': '🐝',
        'title': 'The Hardworking Bee',
        'desc': 'Earn 500 XP',
        'unlocked': totalXP >= 500,
        'progress': (totalXP / 500).clamp(0.0, 1.0),
        'progressText': '$totalXP/500 XP',
        'color': Colors.amber,
      },
      {
        'emoji': '✅',
        'title': 'Mission Support',
        'desc': 'Complete 10 tasks',
        'unlocked': todoCount >= 10,
        'progress': (todoCount / 10).clamp(0.0, 1.0),
        'progressText': '$todoCount/10 tasks',
        'color': Colors.teal,
      },
      {
        'emoji': '🏃',
        'title': 'Marathon Runner',
        'desc': 'Study 3 hours a day',
        'unlocked': _hasStudied3Hours(sessions),
        'progress': _hasStudied3Hours(sessions) ? 1.0 : 0.0,
        'progressText':
        _hasStudied3Hours(sessions) ? 'Done!' : 'It hasnt been done yet',
        'color': Colors.blue,
      },
      {
        'emoji': '🌙',
        'title': 'Night Bird',
        'desc': 'Study after 10:00 p.m.',
        'unlocked': _hasStudiedLate(sessions),
        'progress': _hasStudiedLate(sessions) ? 1.0 : 0.0,
        'progressText':
        _hasStudiedLate(sessions) ? 'Done!' : 'It hasnt been done yet',
        'color': Colors.indigo,
      },
      {
        'emoji': '☀️',
        'title': 'Early Bird',
        'desc': 'Study before 7:00 a.m.',
        'unlocked': _hasStudiedEarly(sessions),
        'progress': _hasStudiedEarly(sessions) ? 1.0 : 0.0,
        'progressText':
        _hasStudiedEarly(sessions) ? 'Done!' : 'It hasnt been done yet',
        'color': Colors.yellow.shade700,
      },
      {
        'emoji': '🎓',
        'title': 'Academician',
        'desc': 'Earn 1000 XP',
        'unlocked': totalXP >= 1000,
        'progress': (totalXP / 1000).clamp(0.0, 1.0),
        'progressText': '$totalXP/1000 XP',
        'color': AppTheme.secondary,
      },
      {
        'emoji': '👑',
        'title': 'Legend',
        'desc': 'Earn 2000 XP',
        'unlocked': totalXP >= 2000,
        'progress': (totalXP / 2000).clamp(0.0, 1.0),
        'progressText': '$totalXP/2000 XP',
        'color': Colors.amber.shade700,
      },
    ];
  }

  bool _hasStudied3Hours(List sessions) {
    final Map<String, int> dailyDurations = {};
    for (final s in sessions) {
      dailyDurations[s.date] =
          (dailyDurations[s.date] ?? 0) + (s.duration as int);
    }
    return dailyDurations.values.any((d) => d >= 180);
  }

  bool _hasStudiedLate(List sessions) {
    for (final s in sessions) {
      try {
        final hour = int.parse(s.createdAt.substring(11, 13));
        if (hour >= 22) return true;
      } catch (_) {}
    }
    return false;
  }

  bool _hasStudiedEarly(List sessions) {
    for (final s in sessions) {
      try {
        final hour = int.parse(s.createdAt.substring(11, 13));
        if (hour < 7) return true;
      } catch (_) {}
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer2<SessionProvider, TodoProvider>(
        builder: (context, session, todo, child) {
          final badges = _getBadges(
            session.totalXP,
            session.streak,
            session.todayPomodoroCount +
                session.allSessions
                    .where((s) => s.sessionType == 'pomodoro')
                    .length,
            session.allSessions.length,
            todo.completedCount,
            session.allSessions,
          );

          final unlockedCount =
              badges.where((b) => b['unlocked'] == true).length;

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, unlockedCount,
                  badges.length, session.totalXP),
              SliverPadding(
                padding:
                const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    _buildHeaderCard(
                        context, unlockedCount, badges.length, session),
                    const SizedBox(height: 20),
                    _buildXPCard(context, session),
                    const SizedBox(height: 20),
                    _buildBadgesGrid(context, badges),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, int unlocked,
      int total, int xp) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.background,
      elevation: 0,
      title: Text(
        'Badges 🏆',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppTheme.primary,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: Colors.amber.shade300, width: 1.5),
          ),
          child: Row(
            children: [
              const Text('⭐',
                  style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '$xp XP',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context, int unlocked,
      int total, SessionProvider session) {
    return Container(
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
          width: 120,
          height: 120,
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
        'Achievement Badges 🏆',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'You earn badges as you work!',
        style: GoogleFonts.quicksand(
          fontSize: 13,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      const SizedBox(height: 16),
      // İlerleme çubuğu
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
              Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$unlocked/$total Badge',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '%${(unlocked / total * 100).toInt()}',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    color: Colors.white
                        .withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius:
              BorderRadius.circular(50),
              child: LinearProgressIndicator(
                  value: unlocked / total,
                  minHeight: 10,
                  backgroundColor: Colors.white
                      .withOpacity(0.3),
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    ),
    const SizedBox(width: 16),
    Text(
    unlocked > 0 ? '🏆' : '🔒',
    style: const TextStyle(fontSize: 40),
    ),
    ],
    ),
    ],
    ),
    ],
    ),
    );
  }

  Widget _buildXPCard(
      BuildContext context, SessionProvider session) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildXPStat(
              '⭐',
              '${session.totalXP}',
              'Total XP',
              Colors.amber,
            ),
          ),
          Container(
              width: 1,
              height: 40,
              color: AppTheme.outline.withOpacity(0.5)),
          Expanded(
            child: _buildXPStat(
              '🔥',
              '${session.streak}',
              'Day Series',
              Colors.orange,
            ),
          ),
          Container(
              width: 1,
              height: 40,
              color: AppTheme.outline.withOpacity(0.5)),
          Expanded(
            child: _buildXPStat(
              '📚',
              '${session.allSessions.length}',
              'Session',
              AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPStat(
      String emoji, String value, String label, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
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
    );
  }

  Widget _buildBadgesGrid(
      BuildContext context, List<Map<String, dynamic>> badges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Badges',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return _buildBadgeCard(context, badges[index]);
          },
        ),
      ],
    );
  }

  Widget _buildBadgeCard(
      BuildContext context, Map<String, dynamic> badge) {
    final isUnlocked = badge['unlocked'] as bool;
    final color = badge['color'] as Color;

    return GestureDetector(
      onTap: () => _showBadgeDetail(context, badge),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnlocked
              ? color.withOpacity(0.08)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? color.withOpacity(0.4)
                : AppTheme.outline.withOpacity(0.5),
            width: isUnlocked ? 2 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rozet emoji
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked
                        ? color.withOpacity(0.15)
                        : AppTheme.outline.withOpacity(0.1),
                    border: Border.all(
                      color: isUnlocked
                          ? color.withOpacity(0.3)
                          : AppTheme.outline.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isUnlocked
                        ? Text(badge['emoji'] as String,
                        style:
                        const TextStyle(fontSize: 30))
                        : Icon(Icons.lock_rounded,
                        color: AppTheme.onSurfaceVariant
                            .withOpacity(0.3),
                        size: 28),
                  ),
                ),
                if (isUnlocked)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 12, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              badge['title'] as String,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isUnlocked
                    ? color
                    : AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: LinearProgressIndicator(
                value: badge['progress'] as double,
                minHeight: 6,
                backgroundColor:
                AppTheme.outline.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isUnlocked ? color : AppTheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              badge['progressText'] as String,
              style: GoogleFonts.quicksand(
                fontSize: 10,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(
      BuildContext context, Map<String, dynamic> badge) {
    final isUnlocked = badge['unlocked'] as bool;
    final color = badge['color'] as Color;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? color.withOpacity(0.15)
                      : AppTheme.outline.withOpacity(0.1),
                  border: Border.all(
                      color: isUnlocked
                          ? color
                          : AppTheme.outline,
                      width: 2),
                ),
                child: Center(child: isUnlocked ? Text(badge['emoji'] as String, style:
                const TextStyle(fontSize: 44)) : Icon(Icons.lock_rounded, color: AppTheme.onSurfaceVariant, size: 40),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge['title'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isUnlocked
                      ? color
                      : AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge['desc'] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? color.withOpacity(0.1)
                      : AppTheme.outline.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      badge['progressText'] as String,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isUnlocked
                            ? color
                            : AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LinearProgressIndicator(
                        value: badge['progress'] as double,
                        minHeight: 8,
                        backgroundColor:
                        AppTheme.outline.withOpacity(0.2),
                        valueColor:
                        AlwaysStoppedAnimation<Color>(
                          isUnlocked
                              ? color
                              : AppTheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Close',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}