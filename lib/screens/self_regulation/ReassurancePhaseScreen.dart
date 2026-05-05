import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/crisis_home_button.dart';

const _reassuranceMessages = [
  'self.reassurance.1',
  'self.reassurance.2',
  'self.reassurance.3',
  'self.reassurance.4',
  'self.reassurance.5',
  'self.reassurance.6',
];

class ReassurancePhaseScreen extends StatelessWidget {
  final int currentStep;

  const ReassurancePhaseScreen({super.key, required this.currentStep});

  void _handleNext(BuildContext context) {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    if (currentStep < _reassuranceMessages.length - 1) {
      interventionState.setReassuranceStep(currentStep + 1);
    } else {
      interventionState.setSelfRegulationPhase(SelfRegulationPhase.recovery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final message = _reassuranceMessages[currentStep];
    final phase = CalmPalette.regulation(context);

    return Scaffold(
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
                        child: BilingualLine(
                          translationKey: message,
                          primaryStyle: TextStyle(
                            fontSize: 28,
                            color: phase.textPrimary,
                            fontWeight: FontWeight.w300,
                            height: 1.45,
                          ),
                          secondaryStyle: TextStyle(
                            fontSize: 17,
                            color: phase.textSecondary,
                            height: 1.5,
                          ),
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
                          currentStep < _reassuranceMessages.length - 1
                              ? languageProvider.t('self.reassurance.next')
                              : languageProvider.t('self.reassurance.continue'),
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
    );
  }
}
