import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../business/providers/pomodoro_provider.dart';
import '../../business/providers/session_provider.dart';
import '../../business/providers/settings_provider.dart';
import '../../core/theme/app_theme.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final TextEditingController _subjectController =
  TextEditingController();
  final TextEditingController _notesController =
  TextEditingController();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsProvider>();
      context.read<PomodoroProvider>().updateDurations(
        settings.pomodoroDuration,
        settings.breakDuration,
      );
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(
          'StudyNeko',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PomodoroProvider>(
        builder: (context, pomodoro, child) {
          return SingleChildScrollView(
            padding:
            const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildStatusChip(context, pomodoro),
                const SizedBox(height: 32),
                _buildTimerCard(context, pomodoro),
                const SizedBox(height: 24),
                _buildControls(context, pomodoro),
                const SizedBox(height: 24),
                _buildInputCard(context, pomodoro),
                const SizedBox(height: 16),
                _buildSessionInfoCard(context, pomodoro),
                if (pomodoro.state == PomodoroState.finished &&
                    !pomodoro.isBreak)
                  _buildXPCard(context, pomodoro),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context, PomodoroProvider pomodoro) {
    String text;
    Color color;

    switch (pomodoro.state) {
      case PomodoroState.idle:
        text = 'Ready to start 🌸';
        color = AppTheme.onSurfaceVariant;
        break;
      case PomodoroState.running:
        text = 'Stay focused 💪';
        color = AppTheme.primary;
        break;
      case PomodoroState.paused:
        text = 'Paused ⏸️';
        color = Colors.orange;
        break;
      case PomodoroState.finished:
        text = pomodoro.isBreak
            ? 'Break is over! Are you ready? 🎉'
            : 'Great work! 🎉';
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTimerCard(
      BuildContext context, PomodoroProvider pomodoro) {
    final totalSeconds = pomodoro.isBreak
        ? pomodoro.breakDuration * 60
        : pomodoro.workDuration * 60;
    final progress = totalSeconds > 0
        ? pomodoro.remainingSeconds / totalSeconds
        : 0.0;
    final color = pomodoro.isBreak
        ? Colors.green.shade400
        : AppTheme.primary;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🐾',
                  style: TextStyle(
                      fontSize: 20,
                      color: AppTheme.outline.withOpacity(0.5))),
              Text('🐾',
                  style: TextStyle(
                      fontSize: 20,
                      color:
                      AppTheme.outline.withOpacity(0.5))),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 12,
                  backgroundColor:
                  AppTheme.outline.withOpacity(0.2),
                  valueColor:
                  AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    pomodoro.timeDisplay,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'TIME REMAINING',
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            pomodoro.isBreak
                ? '☕ Break Time'
                : '📚 Study',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: AppTheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(
      BuildContext context, PomodoroProvider pomodoro) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleButton(
          icon: Icons.refresh_rounded,
          color: AppTheme.onSurfaceVariant,
          size: 52,
          onTap: () {
            pomodoro.reset();
            _subjectController.clear();
            _notesController.clear();
            setState(() => _isSaved = false);
          },
        ),
        const SizedBox(width: 20),

        if (pomodoro.state == PomodoroState.finished)
          pomodoro.isBreak
              ? ElevatedButton.icon(
            onPressed: () {
              pomodoro.reset();
              setState(() => _isSaved = false);
            },
            icon: const Icon(Icons.refresh),
            label: Text('New Session',
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(50)),
            ),
          )
              : _isSaved
              ? ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.check_rounded),
            label: Text('Saved ✅',
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              Colors.grey.shade300,
              foregroundColor:
              Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(50)),
            ),
          )
              : ElevatedButton.icon(
            onPressed: () =>
                _saveSession(context, pomodoro),
            icon:
            const Icon(Icons.save_rounded),
            label: Text('Save & Finish',
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              Colors.green.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(50)),
            ),
          )
        else
          _buildCircleButton(
            icon: pomodoro.state == PomodoroState.running
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            color: AppTheme.primary,
            size: 72,
            iconSize: 36,
            onTap: () {
              if (_subjectController.text.trim().isEmpty &&
                  pomodoro.state == PomodoroState.idle) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please enter a subject name 📚',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12)),
                  ),
                );
                return;
              }
              pomodoro.state == PomodoroState.running
                  ? pomodoro.pause()
                  : pomodoro.start();
            },
          ),

        const SizedBox(width: 20),
        const SizedBox(width: 52),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 52,
    double iconSize = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(
              color: color.withOpacity(0.3), width: 2),
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }

  Widget _buildInputCard(
      BuildContext context, PomodoroProvider pomodoro) {
    final isRunning = pomodoro.state == PomodoroState.running;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUBJECT',
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectController,
            enabled: !isRunning,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Math, Physics...',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('📖',
                    style: TextStyle(fontSize: 18)),
              ),
              filled: true,
              fillColor: AppTheme.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'NOTES',
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            enabled: !isRunning,
            maxLines: 2,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'A note for this session...',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('📝',
                    style: TextStyle(fontSize: 18)),
              ),
              filled: true,
              fillColor: AppTheme.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfoCard(
      BuildContext context, PomodoroProvider pomodoro) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppTheme.primaryContainer, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoChip(
              '⏱️', '${pomodoro.workDuration} min'),
          Container(
              width: 1,
              height: 30,
              color: AppTheme.outline.withOpacity(0.5)),
          _buildInfoChip(
              '☕', '${pomodoro.breakDuration} min'),
          Container(
              width: 1,
              height: 30,
              color: AppTheme.outline.withOpacity(0.5)),
          _buildInfoChip(
            '📚',
            _subjectController.text.isEmpty
                ? '—'
                : _subjectController.text,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String emoji, String text) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.quicksand(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildXPCard(
      BuildContext context, PomodoroProvider pomodoro) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.green.shade200, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child:
              Text('⭐', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You earned +25 XP! 🎉',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Press the Save & Finish button! 👇',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSession(
      BuildContext context, PomodoroProvider pomodoro) async {
    if (_isSaved) return;

    final subject = _subjectController.text.trim();
    final notes = _notesController.text.trim();

    if (subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a subject name 📚',
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600)),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaved = true);

    await context.read<SessionProvider>().addSession(
      subject: subject,
      duration: pomodoro.workDuration,
      sessionType: 'pomodoro',
      notes: notes.isEmpty ? null : notes,
    );

    if (context.mounted) {
      pomodoro.reset();
      _subjectController.clear();
      _notesController.clear();
      setState(() => _isSaved = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$subject saved! +25 XP 🎉',
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}