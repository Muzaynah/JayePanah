import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../providers/InterventionStateProvider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? DesignSystem.darkBase : DesignSystem.lightBase,
      appBar: AppBar(
        title: Text(lang.t('severity.title')),
        elevation: 0,
      ),
      body: SceneBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(DesignSystem.spaceLG),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassCard(
                  tintColor: DesignSystem.glassSage,
                  tintOpacity: 0.22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Take a moment for yourself',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? DesignSystem.darkTextPrimary
                              : DesignSystem.lightTextPrimary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignSystem.spaceMD),
                      Text(
                        'We\'ll guide you through a calming breathing exercise to help you feel better.',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? DesignSystem.darkTextSecondary
                              : DesignSystem.lightTextSecondary,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignSystem.spaceXL),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<InterventionStateProvider>()
                              .startWithSeverity(SeverityLevel.moderate);
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.selfRegulation,
                          );
                        },
                        child: Text('Begin breathing exercise'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
