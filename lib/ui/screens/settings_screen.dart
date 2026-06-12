import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../business/providers/settings_provider.dart';
import '../../business/providers/pomodoro_provider.dart';
import '../../business/providers/session_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.background,
            elevation: 0,
            title: Text(
              'Settings ⚙️',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildTimerCard(context, settings),
                const SizedBox(height: 16),
                _buildAboutCard(),
                const SizedBox(height: 32),
                _buildResetButton(context, settings),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          Positioned(
            left: -10,
            bottom: -20,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customize your study experience,\nNeko! ✨',
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Text('🐱', style: TextStyle(fontSize: 52)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard(
      BuildContext context, SettingsProvider settings) {
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
            'Study Timer ⏱️',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          _buildCounter(
            context,
            emoji: '🍅',
            label: 'Pomodoro Duration',
            value: settings.pomodoroDuration,
            min: 5,
            max: 60,
            onMinus: () {
              if (settings.pomodoroDuration > 5) {
                setState(() {
                  settings.updatePomodoroDuration(
                      settings.pomodoroDuration - 5);
                  context
                      .read<PomodoroProvider>()
                      .updateDurations(
                    settings.pomodoroDuration,
                    settings.breakDuration,
                  );
                });
              }
            },
            onPlus: () {
              if (settings.pomodoroDuration < 60) {
                setState(() {
                  settings.updatePomodoroDuration(
                      settings.pomodoroDuration + 5);
                  context
                      .read<PomodoroProvider>()
                      .updateDurations(
                    settings.pomodoroDuration,
                    settings.breakDuration,
                  );
                });
              }
            },
          ),
          const Divider(height: 28),
          _buildCounter(
            context,
            emoji: '☕',
            label: 'Break Duration',
            value: settings.breakDuration,
            min: 1,
            max: 30,
            onMinus: () {
              if (settings.breakDuration > 1) {
                setState(() {
                  settings.updateBreakDuration(
                      settings.breakDuration - 1);
                  context
                      .read<PomodoroProvider>()
                      .updateDurations(
                    settings.pomodoroDuration,
                    settings.breakDuration,
                  );
                });
              }
            },
            onPlus: () {
              if (settings.breakDuration < 30) {
                setState(() {
                  settings.updateBreakDuration(
                      settings.breakDuration + 1);
                  context
                      .read<PomodoroProvider>()
                      .updateDurations(
                    settings.pomodoroDuration,
                    settings.breakDuration,
                  );
                });
              }
            },
          ),
          const Divider(height: 28),
          _buildCounter(
            context,
            emoji: '🎯',
            label: 'Daily Goal',
            value: settings.dailyGoal,
            min: 30,
            max: 480,
            step: 30,
            onMinus: () {
              if (settings.dailyGoal > 30) {
                setState(() {
                  settings.updateDailyGoal(
                      settings.dailyGoal - 30);
                  context.read<SessionProvider>().loadData();
                });
              }
            },
            onPlus: () {
              if (settings.dailyGoal < 480) {
                setState(() {
                  settings.updateDailyGoal(
                      settings.dailyGoal + 30);
                  context.read<SessionProvider>().loadData();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(
      BuildContext context, {
        required String emoji,
        required String label,
        required int value,
        required int min,
        required int max,
        int step = 5,
        required VoidCallback onMinus,
        required VoidCallback onPlus,
      }) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
        ),
        // Minus button
        GestureDetector(
          onTap: onMinus,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value <= min
                  ? AppTheme.outline.withOpacity(0.15)
                  : AppTheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: value <= min
                    ? AppTheme.outline.withOpacity(0.3)
                    : AppTheme.primaryContainer,
              ),
            ),
            child: Icon(
              Icons.remove_rounded,
              size: 18,
              color: value <= min
                  ? AppTheme.onSurfaceVariant.withOpacity(0.3)
                  : AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Value box
        Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.primaryContainer, width: 1.5),
          ),
          child: Text(
            '$value min',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Plus button
        GestureDetector(
          onTap: onPlus,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value >= max
                  ? AppTheme.outline.withOpacity(0.15)
                  : AppTheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: value >= max
                    ? AppTheme.outline.withOpacity(0.3)
                    : AppTheme.primaryContainer,
              ),
            ),
            child: Icon(
              Icons.add_rounded,
              size: 18,
              color: value >= max
                  ? AppTheme.onSurfaceVariant.withOpacity(0.3)
                  : AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outline, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primaryContainer,
                      AppTheme.secondaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('🌸',
                      style: TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'StudyNeko',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    'CEN306 Final Project',
                    style: GoogleFonts.quicksand(
                      color: AppTheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          _buildAboutRow('Version', '1.0.0'),
          _buildAboutRow('Database', 'SQLite'),
          _buildAboutRow('State Management', 'Provider'),
          _buildAboutRow('Architecture', 'Layered Architecture'),
          _buildAboutRow('Theme', 'Soft Pink 🌸'),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.quicksand(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 14)),
          Text(value,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildResetButton(
      BuildContext context, SettingsProvider settings) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            settings.updatePomodoroDuration(25);
            settings.updateBreakDuration(5);
            settings.updateDailyGoal(120);
            context
                .read<PomodoroProvider>()
                .updateDurations(25, 5);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Restored to default settings 🌸',
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600),
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
              color: AppTheme.outline, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          'Restore Defaults',
          style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}