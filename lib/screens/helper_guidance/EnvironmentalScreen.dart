import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

const _tips = [
  {'title': 'Lighting', 'icon': Icons.lightbulb_outline, 'hint': 'Dim lights or move to a quiet room'},
  {'title': 'Temperature', 'icon': Icons.thermostat, 'hint': 'Keep room cool and comfortable'},
  {'title': 'Sound', 'icon': Icons.volume_off, 'hint': 'Minimize loud noises and distractions'},
  {'title': 'Space', 'icon': Icons.space_dashboard, 'hint': 'Give them personal space if needed'},
];

class EnvironmentalScreen extends StatefulWidget {
  const EnvironmentalScreen({super.key});

  @override
  State<EnvironmentalScreen> createState() => _EnvironmentalScreenState();
}

class _EnvironmentalScreenState extends State<EnvironmentalScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? DesignSystem.darkBase : DesignSystem.lightBase,
        body: SceneBackground(
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Environment Matters',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? DesignSystem.darkTextPrimary
                              : DesignSystem.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create a calm, safe space',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? DesignSystem.darkTextSecondary
                              : DesignSystem.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tips grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spaceLG),
                    child: Column(
                      children: List.generate(
                        _tips.length,
                        (index) {
                          final tip = _tips[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: DesignSystem.spaceMD),
                            child: GlassCard(
                              tintColor: DesignSystem.glassMist,
                              tintOpacity: 0.25,
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: DesignSystem.accentSage.withValues(alpha: 0.15),
                                    ),
                                    child: Icon(
                                      tip['icon'] as IconData,
                                      size: 28,
                                      color: DesignSystem.accentSage,
                                    ),
                                  ),
                                  const SizedBox(width: DesignSystem.spaceMD),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tip['title'] as String,
                                          style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? DesignSystem.darkTextPrimary
                                                : DesignSystem.lightTextPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tip['hint'] as String,
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: isDark
                                                ? DesignSystem.darkTextSecondary
                                                : DesignSystem.lightTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final interventionState = Provider.of<InterventionStateProvider>(
                            context,
                            listen: false,
                          );
                          interventionState.setHelperScreen(HelperGuidanceScreen.escalation);
                        },
                        child: const Text('Continue'),
                      ),
                      const SizedBox(height: DesignSystem.spaceMD),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Home'),
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
