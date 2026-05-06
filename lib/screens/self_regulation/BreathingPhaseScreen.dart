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
  late AnimationController _cycleController;
  late Animation<double> _scaleAnimation;
  bool _hapticEnabled = true;
  bool _isPaused = false;
  int _breathCount = 0;
  String _currentPhase = 'inhale';

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
    _cycleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _cycleController, curve: Curves.easeInOut),
    );

    _cycleController.addListener(_onCycleUpdate);
  }

  void _onCycleUpdate() {
    final progress = _cycleController.value;
    String newPhase = 'inhale';

    if (progress < 0.4) {
      newPhase = 'inhale';
    } else if (progress < 0.5) {
      newPhase = 'hold';
    } else if (progress < 0.9) {
      newPhase = 'exhale';
    } else {
      newPhase = 'hold';
    }

    if (newPhase != _currentPhase) {
      setState(() {
        _currentPhase = newPhase;
        if (newPhase == 'exhale' && progress > 0.5 && progress < 0.51) {
          _breathCount++;
        }
      });

      if (_hapticEnabled && newPhase == 'inhale') {
        Vibration.vibrate(duration: 100);
      }
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _cycleController.stop();
    } else {
      _cycleController.forward();
    }
  }

  @override
  void dispose() {
    _cycleController.dispose();
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
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
      appBar: AppBar(
        title: Text(lang.t('self.breathing.continue')),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background blobs
          BackgroundBlob(
            top: -60,
            left: -80,
            width: 280,
            height: 280,
            color: DesignSystem.glassSage,
            opacity: 0.35,
          ),
          BackgroundBlob(
            bottom: 80,
            right: -60,
            width: 240,
            height: 240,
            color: DesignSystem.glassLavender,
            opacity: 0.30,
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Breathing orb
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              DesignSystem.glassSage.withValues(alpha: 0.9),
                              DesignSystem.glassLavender.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: DesignSystem.glassSage
                                  .withValues(alpha: 0.4),
                              blurRadius: _scaleAnimation.value > 0.8 ? 60 : 20,
                              spreadRadius:
                                  _scaleAnimation.value > 0.8 ? 20 : 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                // Instruction text
                Text(
                  _getInstruction(_currentPhase),
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: DesignSystem.textPrimary,
                  ),
                ),
                const SizedBox(height: 40),
                // Breath counter
                GlassCard(
                  tintColor: DesignSystem.glassLavender,
                  tintOpacity: 0.20,
                  child: Text(
                    '$_breathCount ${lang.t('self.breathing.count')}',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: DesignSystem.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Pause button
                FloatingActionButton.extended(
                  onPressed: _togglePause,
                  label: Text(_isPaused ? 'Resume' : 'Pause'),
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  backgroundColor: DesignSystem.accentSage,
                ),
                const SizedBox(height: 40),
                // Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<InterventionStateProvider>()
                          .setSelfRegulationPhase(SelfRegulationPhase.grounding);
                      Navigator.pop(context);
                    },
                    child: Text(lang.t('self.breathing.continue')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
