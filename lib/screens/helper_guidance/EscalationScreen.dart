import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../routes/app_routes.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/EmergencyModal.dart';
import '../../components/crisis_home_button.dart';

class EscalationScreen extends StatefulWidget {
  const EscalationScreen({super.key});

  @override
  State<EscalationScreen> createState() => _EscalationScreenState();
}

class _EscalationScreenState extends State<EscalationScreen> {
  int _step = 0;
  void _handleNextContent() {
    if (_step < 1) {
      setState(() => _step++);
    }
  }

  void _handleFinish() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.resetIntervention();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final phase = CalmPalette.helper(context);

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
                      translationKey: 'helper.escalation.title',
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
                        child: Column(
                          children: [
                            if (_step == 0) ...[
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: phase.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: phase.secondary.withCalmAlpha(0.35),
                                  ),
                                ),
                                child: Icon(
                                  Icons.medical_information_rounded,
                                  size: 48,
                                  color: phase.accent,
                                ),
                              ),
                              const SizedBox(height: 28),
                              BilingualLine(
                                translationKey: 'helper.escalation.redflags',
                                primaryStyle: TextStyle(
                                  fontSize: 20,
                                  color: phase.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                secondaryStyle: TextStyle(
                                  fontSize: 16,
                                  color: phase.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              BilingualLine(
                                translationKey: 'helper.escalation.redflags.text',
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
                            ] else ...[
                              BilingualLine(
                                translationKey: 'helper.escalation.justification',
                                primaryStyle: TextStyle(
                                  fontSize: 20,
                                  color: phase.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                secondaryStyle: TextStyle(
                                  fontSize: 16,
                                  color: phase.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              BilingualLine(
                                translationKey: 'helper.escalation.justification.text',
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
                          ],
                        ),
                      ),
                    ),
                    if (_step == 0)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _handleNextContent,
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
                      )
                    else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () => EmergencyModal.show(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: phase.ctaBackground,
                            foregroundColor: phase.ctaForeground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone_in_talk_rounded, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                languageProvider.t('helper.escalation.emergency'),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: _handleFinish,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: phase.textPrimary,
                            side: BorderSide(color: phase.secondary.withCalmAlpha(0.5), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            languageProvider.t('helper.escalation.finish'),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                        ),
                      ),
                    ],
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
