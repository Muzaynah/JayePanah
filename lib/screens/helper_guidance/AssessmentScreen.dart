import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _severity = 1;

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
                        'Assess Their State',
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
                        'On a scale of 1-10, how anxious are they?',
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
                // Slider
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _severityColor().withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Text(
                              '$_severity',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 56,
                                fontWeight: FontWeight.w400,
                                color: _severityColor(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignSystem.spaceXL),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spaceLG),
                          child: Slider(
                            value: _severity.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: '$_severity',
                            activeColor: _severityColor(),
                            onChanged: (value) {
                              setState(() => _severity = value.toInt());
                            },
                          ),
                        ),
                        const SizedBox(height: DesignSystem.spaceXL),
                        GlassCard(
                          tintColor: _severityColor(),
                          tintOpacity: 0.15,
                          child: Text(
                            _severityLabel(),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? DesignSystem.darkTextPrimary
                                  : DesignSystem.lightTextPrimary,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _severityColor(),
                        ),
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

  Color _severityColor() {
    if (_severity <= 3) return DesignSystem.accentSage;
    if (_severity <= 6) return const Color(0xFFFFB347);
    return const Color(0xFFD4635F);
  }

  String _severityLabel() {
    if (_severity <= 3) return 'Mild anxiety. Support basics and grounding.';
    if (_severity <= 6) return 'Moderate anxiety. Use breathing & reassurance.';
    return 'High anxiety. Priority: safety & immediate support.';
  }
}
