import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class BreathingPhaseScreen extends StatefulWidget {
  const BreathingPhaseScreen({super.key});

  @override
  State<BreathingPhaseScreen> createState() => _BreathingPhaseScreenState();
}

class _BreathingPhaseScreenState extends State<BreathingPhaseScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _hapticEnabled = true;
  bool _isPressing = false;
  int _breathCount = 0;
  String _currentPhase = 'idle';
  int _paletteIndex = 0;
  bool _isHoldingAfterRelease = false;

  static const List<List<Color>> _phasePalettes = [
    [Color(0xFF6B9BD1), Color(0xFF7EC17F), Color(0xFFB19CD9)],
    [Color(0xFF2E96DE), Color(0xFFF17CB0), Color(0xFFFFC75F)],
    [Color(0xFF4FC3C8), Color(0xFF845EC2), Color(0xFF7EC17F)],
    [Color(0xFF6B9BD1), Color(0xFFE67E22), Color(0xFFB19CD9)],
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeAnimations();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hapticEnabled = prefs.getBool('jayepanah_haptic') ?? true;
    });
  }

  void _initializeAnimations() {
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOutCubic),
    );
  }

  Future<void> _startInhale() async {
    if (_isHoldingAfterRelease || _isPressing) return;
    setState(() {
      _isPressing = true;
      _currentPhase = 'inhale';
    });
    if (_hapticEnabled) {
      Vibration.vibrate(duration: 45);
    }
    await _breathController.forward();
  }

  Future<void> _onRelease() async {
    if (!_isPressing || _isHoldingAfterRelease) return;
    setState(() {
      _isPressing = false;
      _isHoldingAfterRelease = true;
      _currentPhase = 'hold';
    });
    if (_hapticEnabled) {
      Vibration.vibrate(duration: 70);
    }
    await Future.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;
    setState(() {
      _currentPhase = 'exhale';
      _isHoldingAfterRelease = false;
    });
    await _breathController.reverse();

    if (!mounted) return;
    setState(() {
      _breathCount++;
      _paletteIndex = (_paletteIndex + 1) % _phasePalettes.length;
      _currentPhase = 'idle';
    });
    if (_hapticEnabled) {
      Vibration.vibrate(duration: 55);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _getInstruction(String phase) {
    final lang = context.read<LanguageProvider>();
    switch (phase) {
      case 'inhale':
        return lang.t('calm.color.inhale');
      case 'hold':
        return lang.t('calm.color.hold');
      case 'exhale':
        return lang.t('calm.color.exhale');
      case 'idle':
        return lang.t('self.breathing.tap_hold');
      default:
        return '';
    }
  }

  List<Color> _phaseColors(bool isDark) {
    final base = _phasePalettes[_paletteIndex];
    if (isDark) {
      return [
        base[0].withValues(alpha: 0.88),
        base[1].withValues(alpha: 0.62),
        base[2].withValues(alpha: 0.28),
      ];
    }
    return [
      base[0].withValues(alpha: 0.9),
      base[1].withValues(alpha: 0.56),
      base[2].withValues(alpha: 0.16),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? DesignSystem.darkBase : DesignSystem.lightBase,
      appBar: AppBar(
        title: Text(lang.t('self.breathing.continue')),
        elevation: 0,
      ),
      body: SceneBackground(
        isBreathingScreen: true,
        child: SafeArea(
          child: Center(
            child: GestureDetector(
              onTapDown: (_) => _startInhale(),
              onTapUp: (_) => _onRelease(),
              onTapCancel: _onRelease,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _scaleAnimation,
                      _pulseController,
                    ]),
                    builder: (context, child) {
                      final colors = _phaseColors(isDark);
                      final pulse = (_pulseController.value * 0.15) + 0.86;
                      return Transform.scale(
                        scale: _scaleAnimation.value * pulse,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: colors,
                              stops: const [0.0, 0.62, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.first.withValues(alpha: 0.35),
                                blurRadius: _scaleAnimation.value > 0.85
                                    ? 65
                                    : 28,
                                spreadRadius: _scaleAnimation.value > 0.85
                                    ? 18
                                    : 6,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  Text(
                    _getInstruction(_currentPhase),
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? DesignSystem.darkTextPrimary
                          : DesignSystem.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lang.t('self.breathing.hold_hint'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? DesignSystem.darkTextSecondary
                          : DesignSystem.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 26),
                  GlassCard(
                    tintColor: DesignSystem.glassLavender,
                    tintOpacity: 0.20,
                    child: Text(
                      '$_breathCount ${lang.t('self.breathing.count')}',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? DesignSystem.darkTextPrimary
                            : DesignSystem.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<InterventionStateProvider>()
                            .setGroundingStep(0);
                        context
                            .read<InterventionStateProvider>()
                            .setSelfRegulationPhase(
                              SelfRegulationPhase.grounding,
                            );
                      },
                      child: Text(lang.t('self.breathing.continue')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
