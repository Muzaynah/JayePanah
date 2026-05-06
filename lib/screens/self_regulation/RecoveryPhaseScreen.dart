import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../components/EmergencyModal.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  void _handleBetter() {
    final interventionState = context.read<InterventionStateProvider>();
    interventionState.setRecoveryResponse('better');
    interventionState.resetIntervention();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
  }

  void _handleSame() {
    final interventionState = context.read<InterventionStateProvider>();
    interventionState.setRecoveryResponse('same');
    interventionState.setSelfRegulationPhase(SelfRegulationPhase.grounding);
    interventionState.setGroundingStep(0);
  }

  void _handleWorse() {
    EmergencyModal.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? DesignSystem.darkBase : DesignSystem.lightBase,
        body: SceneBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DesignSystem.spaceLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    lang.t('self.recovery.question'),
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? DesignSystem.darkTextPrimary
                          : DesignSystem.textPrimary,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignSystem.spaceXXL),
                  _RecoveryOptionCard(
                    label: lang.t('self.recovery.better'),
                    icon: Icons.check_circle_outline_rounded,
                    color: DesignSystem.accentSage,
                    backgroundColor: DesignSystem.glassSage,
                    onTap: _handleBetter,
                  ),
                  const SizedBox(height: DesignSystem.spaceLG),
                  _RecoveryOptionCard(
                    label: lang.t('self.recovery.same'),
                    icon: Icons.pause_circle_outline_rounded,
                    color: DesignSystem.textSecondary,
                    backgroundColor: DesignSystem.glassMist,
                    onTap: _handleSame,
                  ),
                  const SizedBox(height: DesignSystem.spaceLG),
                  _RecoveryOptionCard(
                    label: lang.t('self.recovery.worse'),
                    icon: Icons.warning_amber_outlined,
                    color: const Color(0xFFD4635F),
                    backgroundColor: const Color(0xFFFFEAEA),
                    onTap: _handleWorse,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecoveryOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _RecoveryOptionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      tintColor: backgroundColor,
      tintOpacity: 0.22,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor.withValues(alpha: 0.4),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: DesignSystem.spaceMD),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? DesignSystem.darkTextPrimary
                    : DesignSystem.textPrimary,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: color,
          ),
        ],
      ),
    );
  }
}
