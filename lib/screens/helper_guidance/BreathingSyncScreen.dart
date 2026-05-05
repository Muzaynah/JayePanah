import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../providers/app_settings_provider.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/crisis_home_button.dart';

/// Same rhythm as self-regulation: inhale 40% of cycle, exhale 60%.
class BreathingSyncScreen extends StatefulWidget {
  const BreathingSyncScreen({super.key});

  @override
  State<BreathingSyncScreen> createState() => _BreathingSyncScreenState();
}

class _BreathingSyncScreenState extends State<BreathingSyncScreen>
    with SingleTickerProviderStateMixin {
  static const _inhaleFraction = 4 / 10;

  late AnimationController _cycle;
  double _scale = 0.9;

  @override
  void initState() {
    super.initState();
    _cycle = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _cycle.addListener(_tick);
    _tick();
  }

  void _tick() {
    final v = _cycle.value;
    double scale;
    if (v < _inhaleFraction) {
      final t = Curves.easeInOutCubic.transform(v / _inhaleFraction);
      scale = lerpDouble(0.82, 1.06, t)!;
    } else {
      final t = Curves.easeInOutCubic.transform((v - _inhaleFraction) / (1 - _inhaleFraction));
      scale = lerpDouble(1.06, 0.82, t)!;
    }
    setState(() => _scale = scale);
  }

  @override
  void dispose() {
    _cycle.removeListener(_tick);
    _cycle.dispose();
    super.dispose();
  }

  void _handleNext() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setHelperScreen(HelperGuidanceScreen.environmental);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final reduceMotion = context.watch<AppSettingsProvider>().reduceMotion;
    final phase = CalmPalette.helper(context);
    final scale = reduceMotion ? 1.0 : _scale;

    return PopScope(
      canPop: false,
      child: Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: phase.backgroundGradient),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  children: [
                    BilingualLine(
                      translationKey: 'helper.breathing.title',
                      primaryStyle: TextStyle(
                        fontSize: 24,
                        color: phase.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      secondaryStyle: TextStyle(
                        fontSize: 17,
                        color: phase.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Center(
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: phase.accent.withCalmAlpha(0.45),
                                width: 2,
                              ),
                              color: phase.accent.withCalmAlpha(0.1),
                            ),
                            child: Center(
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: phase.accent.withCalmAlpha(0.22),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _handleNext,
                        style: FilledButton.styleFrom(
                          backgroundColor: phase.ctaBackground,
                          foregroundColor: phase.ctaForeground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          languageProvider.t('helper.next'),
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
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
    );
  }
}
