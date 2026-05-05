import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../providers/app_settings_provider.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/crisis_home_button.dart';

class StabilizationPhaseScreen extends StatefulWidget {
  const StabilizationPhaseScreen({super.key});

  @override
  State<StabilizationPhaseScreen> createState() => _StabilizationPhaseScreenState();
}

class _StabilizationPhaseScreenState extends State<StabilizationPhaseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringController;
  late Animation<double> _gentleScale;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    )..repeat(reverse: true);
    _gentleScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  void _handleStart() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setSelfRegulationPhase(SelfRegulationPhase.breathing);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final reduceMotion = context.watch<AppSettingsProvider>().reduceMotion;
    final phase = CalmPalette.crisis(context);

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
                    Expanded(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _gentleScale,
                          builder: (context, child) {
                            final scale = reduceMotion ? 1.0 : _gentleScale.value;
                            return Transform.scale(
                              scale: scale,
                              child: _BreathHalo(
                                outer: phase.accent.withCalmAlpha(0.22),
                                mid: phase.secondary.withCalmAlpha(0.35),
                                inner: phase.accent.withCalmAlpha(0.12),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    BilingualLine(
                      translationKey: 'self.stabilization.title',
                      primaryStyle: TextStyle(
                        fontSize: 30,
                        color: phase.textPrimary,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                      secondaryStyle: TextStyle(
                        fontSize: 17,
                        color: phase.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _handleStart,
                        style: FilledButton.styleFrom(
                          backgroundColor: phase.ctaBackground,
                          foregroundColor: phase.ctaForeground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          languageProvider.t('self.stabilization.start'),
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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

class _BreathHalo extends StatelessWidget {
  final Color outer;
  final Color mid;
  final Color inner;

  const _BreathHalo({
    required this.outer,
    required this.mid,
    required this.inner,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: outer,
            ),
          ),
          Container(
            width: 168,
            height: 168,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mid.withCalmAlpha(0.25),
              border: Border.all(color: mid.withCalmAlpha(0.4), width: 1.5),
            ),
          ),
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: inner,
            ),
          ),
        ],
      ),
    );
  }
}
