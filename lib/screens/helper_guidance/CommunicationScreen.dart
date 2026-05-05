import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/crisis_home_button.dart';

/// One communication block per step (say / don't / tone).
const _steps = [
  {
    'title': 'helper.communication.say',
    'body': 'helper.communication.say.text',
    'icon': Icons.check_circle_outline_rounded,
  },
  {
    'title': 'helper.communication.dont',
    'body': 'helper.communication.dont.text',
    'icon': Icons.block_rounded,
  },
  {
    'title': 'helper.communication.tone',
    'body': 'helper.communication.tone.text',
    'icon': Icons.record_voice_over_rounded,
  },
];

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  int _step = 0;

  void _handleNext(BuildContext context) {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
      interventionState.setHelperScreen(HelperGuidanceScreen.breathingSync);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final phase = CalmPalette.helper(context);
    final step = _steps[_step];

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
                    BilingualLine(
                      translationKey: 'helper.communication.title',
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
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: phase.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: phase.secondary.withCalmAlpha(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Icon(
                                step['icon'] as IconData,
                                color: phase.accent,
                                size: 36,
                              ),
                              const SizedBox(height: 18),
                              BilingualLine(
                                translationKey: step['title'] as String,
                                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                primaryStyle: TextStyle(
                                  fontSize: 21,
                                  color: phase.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                                secondaryStyle: TextStyle(
                                  fontSize: 17,
                                  color: phase.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 18),
                              BilingualLine(
                                translationKey: step['body'] as String,
                                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                primaryStyle: TextStyle(
                                  fontSize: 17,
                                  color: phase.textPrimary.withCalmAlpha(0.92),
                                  height: 1.55,
                                ),
                                secondaryStyle: TextStyle(
                                  fontSize: 16,
                                  color: phase.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          languageProvider.t('helper.next'),
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
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
