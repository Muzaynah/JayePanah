import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/crisis_home_button.dart';

const _groundingSteps = [
  {'key': 'see', 'icon': Icons.remove_red_eye_rounded, 'instruction': 'self.grounding.see'},
  {'key': 'touch', 'icon': Icons.touch_app_rounded, 'instruction': 'self.grounding.touch'},
  {'key': 'hear', 'icon': Icons.hearing_rounded, 'instruction': 'self.grounding.hear'},
  {'key': 'smell', 'icon': Icons.spa_rounded, 'instruction': 'self.grounding.smell'},
  {'key': 'taste', 'icon': Icons.restaurant_rounded, 'instruction': 'self.grounding.taste'},
];

class GroundingPhaseScreen extends StatelessWidget {
  final int currentStep;

  const GroundingPhaseScreen({super.key, required this.currentStep});

  void _handleNext(BuildContext context) {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    if (currentStep < _groundingSteps.length - 1) {
      interventionState.setGroundingStep(currentStep + 1);
    } else {
      interventionState.setSelfRegulationPhase(SelfRegulationPhase.reassurance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final step = _groundingSteps[currentStep];
    final phase = CalmPalette.regulation(context);

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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: phase.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: phase.secondary.withCalmAlpha(0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                step['icon'] as IconData,
                                size: 56,
                                color: phase.accent,
                              ),
                            ),
                            const SizedBox(height: 40),
                            BilingualLine(
                              translationKey: step['instruction'] as String,
                              primaryStyle: TextStyle(
                                fontSize: 26,
                                color: phase.textPrimary,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                              secondaryStyle: TextStyle(
                                fontSize: 17,
                                color: phase.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () => _handleNext(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: phase.ctaBackground,
                          foregroundColor: phase.ctaForeground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          currentStep < _groundingSteps.length - 1
                              ? languageProvider.t('self.grounding.next')
                              : languageProvider.t('self.grounding.continue'),
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
