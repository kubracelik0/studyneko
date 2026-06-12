import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../business/providers/session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/study_session.dart';

class SessionListScreen extends StatelessWidget {
  const SessionListScreen({super.key});

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
          'Session List',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded,
                color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded,
                color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSessionDialog(context),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Manually',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<SessionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildSummaryCard(context, provider),
                const SizedBox(height: 16),
                _buildTotalXPCard(context, provider),
                const SizedBox(height: 24),
                _buildSessionsList(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  // Summary card
  Widget _buildSummaryCard(
      BuildContext context, SessionProvider provider) {
    final done = provider.todayTotalDuration;
    final goal = provider.dailyGoal;
    final remaining = goal - done;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You\'re doing great!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  remaining > 0
                      ? 'You focused for $done minutes today. Only $remaining minutes left to reach your goal!'
                      : 'You studied $done minutes today. You exceeded your goal! 🎉',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Total XP card
  Widget _buildTotalXPCard(
      BuildContext context, SessionProvider provider) {
    final xp = provider.streak * 25 + provider.allSessions.length * 10;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.green.shade200, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('⭐', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$xp',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.green.shade700,
                ),
              ),
              Text(
                'Total Points',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sessions list
  Widget _buildSessionsList(
      BuildContext context, SessionProvider provider) {
    final sessions = provider.allSessions;

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Text('📖', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text(
                'No sessions yet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
        ...sessions.map((session) => _buildSessionCard(
            context, session, provider)),
      ],
    );
  }

  // Single session card
  Widget _buildSessionCard(
      BuildContext context,
      StudySession session,
      SessionProvider provider,
      ) {
    final isPomodoro = session.sessionType == 'pomodoro';
    final subjectColors = [
      Colors.blue.shade100,
      Colors.orange.shade100,
      Colors.green.shade100,
      Colors.purple.shade100,
      Colors.pink.shade100,
    ];
    final subjectColor =
    subjectColors[session.subject.length % subjectColors.length];
    final xp = isPomodoro ? 25 : 10;

    return Dismissible(
      key: Key('session_${session.id}'),
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
      onDismissed: (_) {
        if (session.id != null) {
          provider.deleteSession(session.id!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.outline, width: 1.5),
        ),
        child: Row(
          children: [
            // Left colored icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: subjectColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  isPomodoro ? '🍅' : '📖',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        session.subject,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer
                              .withOpacity(0.3),
                          borderRadius:
                          BorderRadius.circular(50),
                        ),
                        child: Text(
                          session.date.length > 7
                              ? 'Today, ${session.createdAt.substring(11, 16)}'
                              : session.date,
                          style: GoogleFonts.quicksand(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 14,
                          color: AppTheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${session.duration} min',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('⭐',
                          style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '+$xp XP',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (session.notes != null &&
                      session.notes!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius:
                            BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Notes: ${session.notes}',
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  Future<void> _showAddSessionDialog(BuildContext context) async {
    final subjectController = TextEditingController();
    final notesController = TextEditingController();
    int selectedDuration = 30;
    final provider = context.read<SessionProvider>();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Add Manual Session 📖',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    hintText: 'Math, Physics...',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('📖',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Note (optional)',
                    hintText: 'A note for this session...',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('📝',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Duration: ',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600)),
                    Expanded(
                      child: Slider(
                        value: selectedDuration.toDouble(),
                        min: 5,
                        max: 120,
                        divisions: 23,
                        label: '$selectedDuration min',
                        onChanged: (value) {
                          setDialogState(() =>
                          selectedDuration =
                              value.toInt());
                        },
                      ),
                    ),
                    Text('$selectedDuration min',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.quicksand(
                      color: AppTheme.onSurfaceVariant)),
            ),
            ElevatedButton(
              onPressed: () async {
                final subject =
                subjectController.text.trim();
                if (subject.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a subject name 📚',
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600)),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12)),
                    ),
                  );
                  return;
                }
                Navigator.pop(ctx);
                await provider.addSession(
                  subject: subject,
                  duration: selectedDuration,
                  sessionType: 'manual',
                  notes: notesController.text.trim().isEmpty
                      ? null
                      : notesController.text.trim(),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$subject - $selectedDuration min added! 🎉',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              child: Text('Add',
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );

    subjectController.dispose();
    notesController.dispose();
  }
}