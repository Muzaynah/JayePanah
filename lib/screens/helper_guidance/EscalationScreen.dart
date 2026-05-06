import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../components/EmergencyModal.dart';

const _warningSigns = [
  {
    'title': 'Severe Panic',
    'description': 'Rapid breathing, chest pain, feeling of unreality',
    'icon': Icons.warning_rounded,
  },
  {
    'title': 'Self-Harm Talk',
    'description': 'Any mention of harming themselves or others',
    'icon': Icons.health_and_safety_rounded,
  },
  {
    'title': 'Loss of Consciousness',
    'description': 'Fainting, dizziness, confusion, or dissociation',
    'icon': Icons.person_outline_rounded,
  },
  {
    'title': 'No Improvement',
    'description': 'After 15-20 minutes, still in severe distress',
    'icon': Icons.trending_down_rounded,
  },
];

class EscalationScreen extends StatelessWidget {
  const EscalationScreen({super.key});

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
                        'When to Call 911',
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
                        'Watch for these critical warning signs',
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
                // Warning signs list
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spaceLG),
                    child: Column(
                      children: List.generate(
                        _warningSigns.length,
                        (index) {
                          final sign = _warningSigns[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: DesignSystem.spaceMD),
                            child: GlassCard(
                              tintColor: const Color(0xFFD4635F),
                              tintOpacity: 0.15,
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFD4635F).withValues(alpha: 0.2),
                                    ),
                                    child: Icon(
                                      sign['icon'] as IconData,
                                      size: 26,
                                      color: const Color(0xFFD4635F),
                                    ),
                                  ),
                                  const SizedBox(width: DesignSystem.spaceMD),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sign['title'] as String,
                                          style: GoogleFonts.nunito(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? DesignSystem.darkTextPrimary
                                                : DesignSystem.lightTextPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          sign['description'] as String,
                                          style: GoogleFonts.nunito(
                                            fontSize: 12,
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
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => EmergencyModal.show(context),
                        icon: const Icon(Icons.phone_in_talk_rounded),
                        label: const Text('Call Emergency'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4635F),
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spaceMD),
                      ElevatedButton(
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
