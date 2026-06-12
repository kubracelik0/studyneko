import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/theme/app_theme.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with WidgetsBindingObserver {
  late AudioPlayer _player;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Map<String, String>> _tracks = [
    {'title': 'Cozy Morning', 'emoji': '☀️', 'file': 'assets/audio/lofi_1.mp3'},
    {'title': 'Rainy Day', 'emoji': '🌧️', 'file': 'assets/audio/lofi_2.mp3'},
    {'title': 'Night Study', 'emoji': '🌙', 'file': 'assets/audio/lofi_3.mp3'},
    {'title': 'Spring Breeze', 'emoji': '🌸', 'file': 'assets/audio/lofi_4.mp3'},
    {'title': 'Deep Focus', 'emoji': '🎯', 'file': 'assets/audio/lofi_5.mp3'},
    {'title': 'Café Vibes', 'emoji': '☕', 'file': 'assets/audio/lofi_6.mp3'},
    {'title': 'Starry Night', 'emoji': '⭐', 'file': 'assets/audio/lofi_7.mp3'},
    {'title': 'Forest Walk', 'emoji': '🌿', 'file': 'assets/audio/lofi_8.mp3'},
    {'title': 'Pink Clouds', 'emoji': '🌸', 'file': 'assets/audio/lofi_9.mp3'},
    {'title': 'Lazy Sunday', 'emoji': '🛋️', 'file': 'assets/audio/lofi_10.mp3'},
    {'title': 'Ocean Waves', 'emoji': '🌊', 'file': 'assets/audio/lofi_11.mp3'},
    {'title': 'Neko Dreams', 'emoji': '🐱', 'file': 'assets/audio/lofi_12.mp3'},
    {'title': 'Soft Piano', 'emoji': '🎹', 'file': 'assets/audio/lofi_13.mp3'},
    {'title': 'Chill Beats', 'emoji': '🎧', 'file': 'assets/audio/lofi_14.mp3'},
    {'title': 'Lavender Sky', 'emoji': '💜', 'file': 'assets/audio/lofi_15.mp3'},
    {'title': 'Sweet Melody', 'emoji': '🎵', 'file': 'assets/audio/lofi_16.mp3'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _player = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _player.durationStream.listen((d) {
      if (mounted) setState(() => _duration = d ?? Duration.zero);
    });

    _player.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
        if (state.processingState == ProcessingState.completed) {
          _nextTrack();
        }
      }
    });

    await _loadTrack(_currentIndex);
  }

  Future<void> _loadTrack(int index) async {
    try {
      await _player.setAsset(_tracks[index]['file']!);
      setState(() => _currentIndex = index);
    } catch (e) {
      debugPrint('Track could not be loaded: $e');
    }
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _nextTrack() async {
    final next = (_currentIndex + 1) % _tracks.length;
    await _loadTrack(next);
    await _player.play();
  }

  Future<void> _previousTrack() async {
    final prev =
        (_currentIndex - 1 + _tracks.length) % _tracks.length;
    await _loadTrack(prev);
    await _player.play();
  }

  Future<void> _selectTrack(int index) async {
    await _loadTrack(index);
    await _player.play();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _tracks[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.background,
            elevation: 0,
            title: Text(
              'Music 🎵',
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
                _buildPlayerCard(context, current),
                const SizedBox(height: 24),
                _buildTrackList(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Main player card
  Widget _buildPlayerCard(
      BuildContext context, Map<String, String> current) {
    final progress = _duration.inSeconds > 0
        ? _position.inSeconds / _duration.inSeconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8A0BF), Color(0xFF7D5070)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Track title
          Text(
            current['emoji']! + ' ' + current['title']!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lo-fi Music 🌸',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),

          // Progress bar
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor:
                  Colors.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: progress.clamp(0.0, 1.0),
                  onChanged: (value) {
                    final position = Duration(
                      seconds:
                      (value * _duration.inSeconds).toInt(),
                    );
                    _player.seek(position);
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous
              GestureDetector(
                onTap: _previousTrack,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Play/Pause
              GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: AppTheme.primary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Next
              GestureDetector(
                onTap: _nextTrack,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Track list
  Widget _buildTrackList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Playlist 🎶',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ..._tracks.asMap().entries.map((entry) {
          final index = entry.key;
          final track = entry.value;
          final isPlaying =
              _currentIndex == index && _isPlaying;
          final isSelected = _currentIndex == index;

          return GestureDetector(
            onTap: () => _selectTrack(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryContainer
                    .withOpacity(0.2)
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryContainer
                      : AppTheme.outline,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Row(
                children: [
                  // Number or animation
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.outline.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: isPlaying
                          ? const Icon(
                        Icons.equalizer_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                          : Text(
                        isSelected
                            ? track['emoji']!
                            : '${index + 1}',
                        style: TextStyle(
                          fontSize: isSelected ? 16 : 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      track['emoji']! + '  ' + track['title']!,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.onSurface,
                      ),
                    ),
                  ),
                  if (isPlaying)
                    const Icon(
                      Icons.volume_up_rounded,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}