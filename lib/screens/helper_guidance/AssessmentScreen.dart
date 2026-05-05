import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/crisis_home_button.dart';

const _steps = [
  'helper.assessment.speak',
  'helper.assessment.breathe',
  'helper.assessment.reducing',
];

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _step = 0;

  void _handleNext() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
      interventionState.setHelperScreen(HelperGuidanceScreen.escalation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final phase = CalmPalette.helper(context);
    final key = _steps[_step];

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
                      translationKey: 'helper.assessment.title',
                      primaryStyle: TextStyle(
                        fontSize: 22,
                        color: phase.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      secondaryStyle: TextStyle(
                        fontSize: 16,
                        color: phase.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Center(
                        child: BilingualLine(
                          translationKey: key,
                          primaryStyle: TextStyle(
                            fontSize: 28,
                            color: phase.textPrimary,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
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
