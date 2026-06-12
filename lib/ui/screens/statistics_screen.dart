import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../business/providers/session_provider.dart';
import '../../core/theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

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
                const Text('⭐', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '1450 XP',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded,
                color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<SessionProvider>(
        builder: (context, session, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildXPCard(context, session),
                const SizedBox(height: 12),
                _buildWeeklyTotalCard(context, session),
                const SizedBox(height: 12),
                _buildStreakCard(context, session),
                const SizedBox(height: 12),
                _buildWeeklyChartCard(context, session),
                const SizedBox(height: 12),
                _buildSubjectBreakdownCard(context, session),
                const SizedBox(height: 12),
                _buildHeatmapCard(context, session),
              ],
            ),
          );
        },
      ),
    );
  }

  // XP Card
  Widget _buildXPCard(
      BuildContext context, SessionProvider session) {
    final xp = session.streak * 25;
    final nextLevel = 200;
    final progress = (xp % nextLevel) / nextLevel;

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
              Text(
                'XP Earned',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: AppTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text('🏆', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$xp',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${nextLevel - (xp % nextLevel)} XP to next level',
            style: GoogleFonts.quicksand(
              fontSize: 13,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppTheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  // Weekly total card
  Widget _buildWeeklyTotalCard(
      BuildContext context, SessionProvider session) {
    final weeklyMinutes = session.weeklyTotalDuration;
    final hours = weeklyMinutes ~/ 60;
    final minutes = weeklyMinutes % 60;
    final display = hours > 0 ? '${hours}h' : '${minutes}min';

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
              Text(
                'Weekly Total',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: AppTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text('⏱️', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            display,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+2h (compared to last week)',
            style: GoogleFonts.quicksand(
              fontSize: 13,
              color: Colors.green.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Best streak card
  Widget _buildStreakCard(
      BuildContext context, SessionProvider session) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryContainer.withOpacity(0.8),
            AppTheme.secondaryContainer.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BEST STREAK 🔥',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const Text('🎯', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${session.streak} Days',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: Text(
              'RECORD BROKEN!',
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Weekly bar chart
  Widget _buildWeeklyChartCard(
      BuildContext context, SessionProvider session) {
    final weekDays = _getLast7Days();
    final sessions = session.weeklySessions;

    final Map<String, int> dailyDurations = {};
    for (final day in weekDays) {
      dailyDurations[day] = 0;
    }
    for (final s in sessions) {
      if (dailyDurations.containsKey(s.date)) {
        final current = dailyDurations[s.date] ?? 0;
        dailyDurations[s.date] = current + s.duration;
      }
    }

    final maxDuration = dailyDurations.values.isEmpty
        ? 1
        : dailyDurations.values
        .reduce((a, b) => a > b ? a : b);

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
          Text(
            'Weekly Study',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((day) {
                final duration = dailyDurations[day] ?? 0;
                final barHeight = maxDuration == 0
                    ? 0.0
                    : (duration / maxDuration) * 90.0;
                final isToday = day == _getTodayStr();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (duration > 0)
                      Text(
                        '${duration}min',
                        style: GoogleFonts.quicksand(
                          fontSize: 9,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: barHeight == 0 ? 6 : barHeight,
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppTheme.primary
                            : barHeight == 0
                            ? AppTheme.outline
                            .withOpacity(0.3)
                            : AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getDayLabel(day),
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isToday
                            ? AppTheme.primary
                            : AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Subject breakdown
  Widget _buildSubjectBreakdownCard(
      BuildContext context, SessionProvider session) {
    final sessions = session.weeklySessions;

    final Map<String, int> subjectDurations = {};
    for (final s in sessions) {
      subjectDurations[s.subject] =
          (subjectDurations[s.subject] ?? 0) + s.duration;
    }

    final total = subjectDurations.values.isEmpty
        ? 1
        : subjectDurations.values.reduce((a, b) => a + b);

    final sorted = subjectDurations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      AppTheme.primary,
      AppTheme.secondary,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.blue.shade400,
    ];

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
          Text(
            'Subject Breakdown',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          if (sorted.isEmpty)
            Center(
              child: Text(
                'No sessions this week yet',
                style: GoogleFonts.quicksand(
                    color: AppTheme.onSurfaceVariant),
              ),
            )
          else
            ...sorted.asMap().entries.map((entry) {
              final index = entry.key;
              final subject = entry.value.key;
              final duration = entry.value.value;
              final percentage = (duration / total * 100).toInt();
              final color = colors[index % colors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subject,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LinearProgressIndicator(
                        value: duration / total,
                        minHeight: 8,
                        backgroundColor:
                        color.withOpacity(0.15),
                        valueColor:
                        AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: AppTheme.outline, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'View Detailed Report',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Study intensity heatmap
  Widget _buildHeatmapCard(
      BuildContext context, SessionProvider session) {
    final weeks = _getLast4Weeks();
    final sessions = session.weeklySessions;

    final Map<String, int> dailyDurations = {};
    for (final s in sessions) {
      dailyDurations[s.date] =
          (dailyDurations[s.date] ?? 0) + s.duration;
    }

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
              Text(
                'Study Intensity',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              Row(
                children: [
                  Text('LOW',
                      style: GoogleFonts.quicksand(
                          fontSize: 10,
                          color: AppTheme.onSurfaceVariant)),
                  const SizedBox(width: 4),
                  ...List.generate(
                    4,
                        (i) => Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary
                            .withOpacity(0.2 + i * 0.25),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Text('HIGH',
                      style: GoogleFonts.quicksand(
                          fontSize: 10,
                          color: AppTheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weeks.asMap().entries.map((weekEntry) {
              return Column(
                children: [
                  ...weekEntry.value.map((date) {
                    final duration = dailyDurations[date] ?? 0;
                    Color cellColor;
                    if (duration == 0) {
                      cellColor =
                          AppTheme.outline.withOpacity(0.2);
                    } else if (duration < 30) {
                      cellColor =
                          AppTheme.primary.withOpacity(0.3);
                    } else if (duration < 60) {
                      cellColor =
                          AppTheme.primary.withOpacity(0.5);
                    } else if (duration < 120) {
                      cellColor =
                          AppTheme.primary.withOpacity(0.7);
                    } else {
                      cellColor = AppTheme.primary;
                    }

                    return Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  Text(
                    'Week ${weekEntry.key + 1}',
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<String> _getLast7Days() {
    final days = <String>[];
    for (int i = 6; i >= 0; i--) {
      final day = DateTime.now().subtract(Duration(days: i));
      days.add(_formatDate(day));
    }
    return days;
  }

  List<List<String>> _getLast4Weeks() {
    final weeks = <List<String>>[];
    for (int w = 3; w >= 0; w--) {
      final week = <String>[];
      for (int d = 6; d >= 0; d--) {
        final day = DateTime.now()
            .subtract(Duration(days: w * 7 + d));
        week.add(_formatDate(day));
      }
      weeks.add(week);
    }
    return weeks;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getTodayStr() => _formatDate(DateTime.now());

  String _getDayLabel(String dateStr) {
    final parts = dateStr.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}