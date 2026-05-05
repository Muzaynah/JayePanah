import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../providers/app_settings_provider.dart';
import '../../theme/calm_palette.dart';
import '../../components/crisis_home_button.dart';

/// Map [AnimationController] value (0→1 over one breath cycle) to ring scale.
class _BreathCircleScale extends Animatable<double> {
  const _BreathCircleScale();

  static const double _inhaleFraction = 4 / 10;

  @override
  double transform(double t) {
    if (t < _inhaleFraction) {
      final u = Curves.easeInOutSine.transform(t / _inhaleFraction);
      return lerpDouble(0.86, 1.06, u)!;
    }
    final u = Curves.easeInOutSine.transform((t - _inhaleFraction) / (1 - _inhaleFraction));
    return lerpDouble(1.06, 0.86, u)!;
  }
}

/// Inhale 4s of a 10s cycle; exhale 8s (exhale longer than inhale).
class BreathingPhaseScreen extends StatefulWidget {
  const BreathingPhaseScreen({super.key});

  @override
  State<BreathingPhaseScreen> createState() => _BreathingPhaseScreenState();
}

class _BreathingPhaseScreenState extends State<BreathingPhaseScreen>
    with TickerProviderStateMixin {
  static const _inhaleFraction = 4 / 10;
  static const _inhaleBarDuration = Duration(seconds: 4);
  static const _exhaleBarDuration = Duration(seconds: 8);
  static const _breathBarTrackWidth = 200.0;
  static const _breathBarHeight = 5.0;

  late AnimationController _cycleController;
  late Animation<double> _breathScaleAnimation;
  late AnimationController _instructionFadeController;
  late Animation<double> _instructionFadeCurve;
  bool _hapticEnabled = true;
  bool _isPaused = false;
  bool _isInhaling = true;
  String _instructionKey = 'self.breathing.inhale';
  double _barWidthFactor = 0;
  Duration _barAnimDuration = Duration.zero;
  int _barPhaseNonce = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _cycleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _breathScaleAnimation = const _BreathCircleScale().animate(_cycleController);

    _instructionFadeController = AnimationController(
      duration: const Duration(milliseconds: 720),
      vsync: this,
    )..value = 1;
    _instructionFadeCurve = CurvedAnimation(
      parent: _instructionFadeController,
      curve: Curves.easeInOutCubic,
    );

    _cycleController.addListener(_onCycleListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _kickBreathProgressBarForPhase(isInhaling: true);
    });
  }

  void _onCycleListener() {
    _onPhaseEdge();
  }

  /// Inhale: empty → full. Exhale: full → empty. Restarts every phase
  void _kickBreathProgressBarForPhase({required bool isInhaling}) {
    if (_isPaused) return;
    final reduceMotion = context.read<AppSettingsProvider>().reduceMotion;
    if (reduceMotion) {
      setState(() {
        _barAnimDuration = Duration.zero;
        _barWidthFactor = isInhaling ? 1.0 : 0.0;
        _barPhaseNonce++;
      });
      return;
    }
    if (isInhaling) {
      setState(() {
        _barPhaseNonce++;
        _barAnimDuration = _inhaleBarDuration;
        _barWidthFactor = 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isPaused) return;
        setState(() => _barWidthFactor = 1);
      });
    } else {
      setState(() {
        _barPhaseNonce++;
        _barAnimDuration = _exhaleBarDuration;
        _barWidthFactor = 1;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isPaused) return;
        setState(() => _barWidthFactor = 0);
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _hapticEnabled = prefs.getBool('jayepanah_haptic') ?? true;
    });
  }

  void _onPhaseEdge() {
    if (_isPaused) return;
    final v = _cycleController.value;
    final nextInhaling = v < _inhaleFraction;
    if (nextInhaling != _isInhaling) {
      setState(() {
        _isInhaling = nextInhaling;
        _instructionKey =
            _isInhaling ? 'self.breathing.inhale' : 'self.breathing.exhale';
      });
      _kickBreathProgressBarForPhase(isInhaling: nextInhaling);
      final rm = context.read<AppSettingsProvider>().reduceMotion;
      _instructionFadeController.duration =
          rm ? Duration.zero : const Duration(milliseconds: 720);
      _instructionFadeController.forward(from: 0);
      _cueGuidance();
    }
  }

  Future<void> _cueGuidance() async {
    if (!mounted || !_hapticEnabled) return;
    await Vibration.vibrate(duration: 80);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setBreathingPaused(_isPaused);
    if (_isPaused) {
      _cycleController.stop();
    } else {
      _cycleController.repeat();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final v = _cycleController.value;
        final inhaling = v < _inhaleFraction;
        _kickBreathProgressBarForPhase(isInhaling: inhaling);
      });
    }
  }

  void _handleContinue() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setSelfRegulationPhase(SelfRegulationPhase.grounding);
  }

  @override
  void dispose() {
    _cycleController.removeListener(_onCycleListener);
    _cycleController.dispose();
    _instructionFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final reduceMotion = context.watch<AppSettingsProvider>().reduceMotion;
    final showBilingual = context.watch<AppSettingsProvider>().showBilingualCaptions;
    final phase = CalmPalette.breathing(context);
    final barDuration = reduceMotion ? Duration.zero : _barAnimDuration;
    final textStyleDuration = reduceMotion ? Duration.zero : const Duration(milliseconds: 700);
    final instructionText = languageProvider.t(_instructionKey);
    final instructionAlt = showBilingual ? languageProvider.tAlternate(_instructionKey) : '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Inhale: lighter, open tone; exhale: deeper, darker (still on-theme).
    final inhaleMainColor = Color.lerp(phase.textPrimary, phase.accent, isDark ? 0.52 : 0.28)!;
    final exhaleMainColor =
        Color.lerp(phase.textPrimary, Colors.black, isDark ? 0.38 : 0.1)!;
    final inhaleAltColor = Color.lerp(phase.textSecondary, phase.accent, isDark ? 0.38 : 0.22)!;
    final exhaleAltColor =
        Color.lerp(phase.textSecondary, Colors.black, isDark ? 0.32 : 0.12)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: phase.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 168),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: SizedBox(
                          width: _breathBarTrackWidth,
                          height: _breathBarHeight,
                          child: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: phase.textSecondary.withCalmAlpha(0.2),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                                child: AnimatedContainer(
                                  key: ValueKey(_barPhaseNonce),
                                  duration: barDuration,
                                  curve: Curves.easeInOutCubic,
                                  width: _breathBarTrackWidth * _barWidthFactor,
                                  height: _breathBarHeight,
                                  decoration: BoxDecoration(
                                    color: phase.accent,
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: [
                                      BoxShadow(
                                        color: phase.accent.withCalmAlpha(0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _instructionFadeCurve,
                        child: Column(
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: textStyleDuration,
                              curve: Curves.easeInOutCubic,
                              style: TextStyle(
                                fontSize: _isInhaling ? 22 : 20,
                                color: _isInhaling ? inhaleMainColor : exhaleMainColor,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.6,
                              ),
                              child: Text(
                                instructionText,
                                textAlign: TextAlign.center,
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ),
                            if (instructionAlt.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              AnimatedDefaultTextStyle(
                                duration: textStyleDuration,
                                curve: Curves.easeInOutCubic,
                                style: TextStyle(
                                  fontSize: _isInhaling ? 17 : 16,
                                  color: _isInhaling ? inhaleAltColor : exhaleAltColor,
                                  height: 1.45,
                                ),
                                child: Text(
                                  instructionAlt,
                                  textAlign: TextAlign.center,
                                  textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      Semantics(
                        label: languageProvider.t('self.breathing.semantics'),
                        child: ScaleTransition(
                          scale: reduceMotion || _isPaused
                              ? const AlwaysStoppedAnimation<double>(1.0)
                              : _breathScaleAnimation,
                          child: _BreathingRings(phase: phase),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 28,
                left: 24,
                right: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      label: languageProvider.t('self.breathing.pauseSemantics'),
                      button: true,
                      child: Material(
                        color: phase.surface,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _togglePause,
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                              color: phase.textPrimary,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _handleContinue,
                        style: FilledButton.styleFrom(
                          backgroundColor: phase.ctaBackground,
                          foregroundColor: phase.ctaForeground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          languageProvider.t('self.breathing.continue'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CrisisHomeButton(
                backgroundColor: phase.surface,
                iconColor: phase.textPrimary,
                borderColor: phase.textSecondary.withCalmAlpha(0.25),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _BreathingRings extends StatelessWidget {
  final CalmPhase phase;

  const _BreathingRings({
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: phase.secondary.withCalmAlpha(0.45), width: 2),
              color: phase.accent.withCalmAlpha(0.08),
            ),
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: phase.accent.withCalmAlpha(0.5), width: 2.5),
              color: phase.accent.withCalmAlpha(0.12),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: phase.accent.withCalmAlpha(0.28),
            ),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: phase.accent,
                boxShadow: [
                  BoxShadow(
                    color: phase.accent.withCalmAlpha(0.35),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
