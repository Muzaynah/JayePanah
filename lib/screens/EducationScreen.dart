import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

const _educationSections = [
  {
    'key': 'section1',
    'icon': Icons.psychology_rounded,
  },
  {
    'key': 'section2',
    'icon': Icons.favorite_rounded,
  },
  {
    'key': 'section3',
    'icon': Icons.help_outline_rounded,
  },
  {
    'key': 'section4',
    'icon': Icons.waves_rounded,
  },
  {
    'key': 'section5',
    'icon': Icons.shield_rounded,
  },
  {
    'key': 'section6',
    'icon': Icons.medical_services_rounded,
  },
  {
    'key': 'section7',
    'icon': Icons.health_and_safety_rounded,
  },
  {
    'key': 'section8',
    'icon': Icons.schedule_rounded,
  },
  {
    'key': 'section9',
    'icon': Icons.local_hospital_rounded,
  },
  {
    'key': 'section10',
    'icon': Icons.info_outline_rounded,
  },
];

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
      appBar: AppBar(
        title: Text(lang.t('education.title')),
        elevation: 0,
      ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ..._educationSections.map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _EducationCard(
                        sectionKey: section['key'] as String,
                        icon: section['icon'] as IconData,
                        lang: lang,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final String sectionKey;
  final IconData icon;
  final LanguageProvider lang;

  const _EducationCard({
    required this.sectionKey,
    required this.icon,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final titleKey = 'education.$sectionKey.title';
    final textKey = 'education.$sectionKey.text';

    return GlassCard(
      tintColor: DesignSystem.glassLavender,
      tintOpacity: 0.20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: DesignSystem.glassLavender.withValues(alpha: 0.4),
                ),
                child: Icon(
                  icon,
                  color: DesignSystem.accentLavender,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  lang.t(titleKey),
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: DesignSystem.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            lang.t(textKey),
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: DesignSystem.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
