import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../widgets/bilingual_line.dart';
import '../services/audio_service.dart';

class _SoundItem {
  final String label;
  final String path;
  final IconData icon;
  final List<Color> gradientColors;

  const _SoundItem({
    required this.label,
    required this.path,
    required this.icon,
    required this.gradientColors,
  });
}

class SoundGalleryScreen extends StatefulWidget {
  const SoundGalleryScreen({super.key});

  @override
  State<SoundGalleryScreen> createState() => _SoundGalleryScreenState();
}

class _SoundGalleryScreenState extends State<SoundGalleryScreen>
    with TickerProviderStateMixin {
  String? _playingSound;
  late AnimationController _playingController;
  final Map<String, AnimationController> _soundControllers = {};
  late AudioService _audioService;

  static const _sounds = [
    _SoundItem(
      label: 'calm.sound.rain',
      path: 'assets/asmr sounds/dragon-studio-gentle-rain-06-437318.mp3',
      icon: Icons.cloud_queue_rounded,
      gradientColors: [Color(0xFF6B9BD1), Color(0xFF4A7BA7)],
    ),
    _SoundItem(
      label: 'calm.sound.ocean',
      path: 'assets/asmr sounds/soundreality-calm-sea-waves-227521.mp3',
      icon: Icons.water_rounded,
      gradientColors: [Color(0xFF2E96DE), Color(0xFF1E5BA8)],
    ),
    _SoundItem(
      label: 'calm.sound.keyboard',
      path: 'assets/asmr sounds/virtualzero-mechanical-keyboard-typing-hd-372290.mp3',
      icon: Icons.keyboard_rounded,
      gradientColors: [Color(0xFFD4A574), Color(0xFFA0826D)],
    ),
    _SoundItem(
      label: 'calm.sound.fireplace',
      path: 'assets/asmr sounds/virtualzero-campfire-burning-wood-ambience-hd-375866.mp3',
      icon: Icons.local_fire_department_rounded,
      gradientColors: [Color(0xFFE67E22), Color(0xFFC0392B)],
    ),
    _SoundItem(
      label: 'calm.sound.water',
      path: 'assets/asmr sounds/54570407-water-bubbling-sound-effect-close-up-487894.mp3',
      icon: Icons.waves_rounded,
      gradientColors: [Color(0xFF3498DB), Color(0xFF2980B9)],
    ),
    _SoundItem(
      label: 'calm.sound.cooking',
      path: 'assets/asmr sounds/vegetable chopping.mp3',
      icon: Icons.restaurant_rounded,
      gradientColors: [Color(0xFF27AE60), Color(0xFF1E8449)],
    ),
    _SoundItem(
      label: 'calm.sound.rain2',
      path: 'assets/asmr sounds/gingerleegalaxy_1-rainy-window-sleep-sounds-12-asmr-247407.mp3',
      icon: Icons.grain_rounded,
      gradientColors: [Color(0xFF34495E), Color(0xFF2C3E50)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _playingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    for (final sound in _sounds) {
      _soundControllers[sound.path] = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _playingController.dispose();
    for (final controller in _soundControllers.values) {
      controller.dispose();
    }
    _audioService.stopSound();
    super.dispose();
  }

  void _toggleSound(String soundPath) async {
    setState(() {
      if (_playingSound == soundPath) {
        _playingSound = null;
        _soundControllers[soundPath]?.stop();
        _soundControllers[soundPath]?.reverse();
        _audioService.stopSound();
      } else {
        final previousSound = _playingSound;
        if (previousSound != null) {
          _soundControllers[previousSound]?.stop();
          _soundControllers[previousSound]?.reverse();
        }
        _playingSound = soundPath;
        _soundControllers[soundPath]?.repeat(reverse: true);
        _audioService.playSound(soundPath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isRTL = lang.isRTL;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: cs.primary),
              child: Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      isRTL ? Icons.chevron_right : Icons.chevron_left,
                      color: cs.onPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: cs.onPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BilingualLine(
                      translationKey: 'calm.sounds.title',
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      primaryStyle: TextStyle(
                        fontSize: 24,
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      secondaryStyle: TextStyle(
                        fontSize: 18,
                        color: cs.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final sound in _sounds) ...[
                      _SoundCard(
                        soundItem: sound,
                        isPlaying: _playingSound == sound.path,
                        onTap: () => _toggleSound(sound.path),
                        animationController: _soundControllers[sound.path]!,
                        lang: lang,
                        isRTL: isRTL,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoundCard extends StatelessWidget {
  final _SoundItem soundItem;
  final bool isPlaying;
  final VoidCallback onTap;
  final AnimationController animationController;
  final LanguageProvider lang;
  final bool isRTL;

  const _SoundCard({
    required this.soundItem,
    required this.isPlaying,
    required this.onTap,
    required this.animationController,
    required this.lang,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: soundItem.gradientColors,
            ),
            boxShadow: isPlaying
                ? [
                    BoxShadow(
                      color: soundItem.gradientColors[0].withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if (isPlaying)
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Transform.scale(
                              scale: 1 + (animationController.value * 0.3),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.3 * (1 - animationController.value),
                                    ),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                            child: Icon(soundItem.icon, color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    );
                  },
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                  child: Icon(soundItem.icon, color: Colors.white, size: 24),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.t(soundItem.label),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    if (isPlaying)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          lang.t('calm.sounds.playing'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
