import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../providers/InterventionStateProvider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AssessmentResultScreen extends StatelessWidget {
  const AssessmentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final state = context.watch<InterventionStateProvider>();
    final severity = state.severityLevel;

    String titleKey = 'assessment.result.mild';
    String descKey = 'assessment.result.mild.desc';
    IconData icon = Icons.sentiment_satisfied_outlined;
    Color accentColor = DesignSystem.accentSage;

    if (severity == SeverityLevel.severe) {
      titleKey = 'assessment.result.severe';
      descKey = 'assessment.result.severe.desc';
      icon = Icons.warning_amber_outlined;
      accentColor = const Color(0xFFD4635F);
    } else if (severity == SeverityLevel.moderate) {
      titleKey = 'assessment.result.moderate';
      descKey = 'assessment.result.moderate.desc';
      icon = Icons.favorite_outlined;
      accentColor = DesignSystem.accentLavender;
    }

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
      body: Stack(
        children: [
          // Background blobs
          BackgroundBlob(
            top: -60,
            left: -80,
            width: 280,
            height: 280,
            color: DesignSystem.glassSage,
            opacity: 0.35,
          ),
          BackgroundBlob(
            bottom: 80,
            right: -60,
            width: 240,
            height: 240,
            color: DesignSystem.glassLavender,
            opacity: 0.30,
          ),
          // Main content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon display area
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      icon,
                      size: 60,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Title and description
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        lang.t(titleKey),
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          color: DesignSystem.textPrimary,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignSystem.spaceMD),
                      Text(
                        lang.t(descKey),
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: DesignSystem.textSecondary,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXXL),
                // Action button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.selfRegulation,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                    child: Text(lang.t('assessment.result.continue')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
