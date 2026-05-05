import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../routes/app_routes.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/EmergencyModal.dart';
import '../../components/crisis_home_button.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  bool _showMoreOptions = false;

  void _handleBetter() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setRecoveryResponse('better');
    interventionState.resetIntervention();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
  }

  void _handleSame() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setRecoveryResponse('same');
    interventionState.setSelfRegulationPhase(SelfRegulationPhase.grounding);
    interventionState.setGroundingStep(0);
  }

  void _handleWorse() {
    EmergencyModal.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final phase = CalmPalette.recovery(context);

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
                            BilingualLine(
                              translationKey: 'self.recovery.question',
                              primaryStyle: TextStyle(
                                fontSize: 28,
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
                            const SizedBox(height: 40),
                            _RecoveryPrimaryButton(
                              label: languageProvider.t('self.recovery.better'),
                              onTap: _handleBetter,
                              phase: phase,
                              isRTL: isRTL,
                              emphasize: true,
                            ),
                            if (!_showMoreOptions) ...[
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () => setState(() => _showMoreOptions = true),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(48, 48),
                                  foregroundColor: phase.textSecondary,
                                ),
                                child: Text(
                                  languageProvider.t('self.recovery.other'),
                                  style: const TextStyle(fontSize: 17, decoration: TextDecoration.underline),
                                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ),
                            ],
                            if (_showMoreOptions) ...[
                              const SizedBox(height: 28),
                              _RecoveryPrimaryButton(
                                label: languageProvider.t('self.recovery.same'),
                                onTap: _handleSame,
                                phase: phase,
                                isRTL: isRTL,
                                emphasize: false,
                              ),
                              const SizedBox(height: 16),
                              _RecoveryPrimaryButton(
                                label: languageProvider.t('self.recovery.worse'),
                                onTap: _handleWorse,
                                phase: phase,
                                isRTL: isRTL,
                                emphasize: false,
                                outline: true,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => EmergencyModal.show(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: phase.textPrimary,
                          side: BorderSide(color: phase.secondary.withCalmAlpha(0.55), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone_in_talk_rounded, color: phase.accent, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              languageProvider.t('home.emergency'),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ],
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
              borderColor: phase.textSecondary.withCalmAlpha(0.28),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _RecoveryPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final CalmPhase phase;
  final bool isRTL;
  final bool emphasize;
  final bool outline;

  const _RecoveryPrimaryButton({
    required this.label,
    required this.onTap,
    required this.phase,
    required this.isRTL,
    this.emphasize = false,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    final fill = emphasize ? phase.ctaBackground : phase.surface;
    final fg = emphasize ? phase.ctaForeground : phase.textPrimary;
    final border = outline ? phase.secondary.withCalmAlpha(0.6) : Colors.transparent;

    return Material(
      color: outline ? Colors.transparent : fill,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border, width: outline ? 1.5 : 0),
            color: outline ? phase.surface : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: emphasize ? 20 : 18,
              color: fg,
              fontWeight: emphasize ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
