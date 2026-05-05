import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../theme/calm_palette.dart';
import '../widgets/bilingual_line.dart';

const _educationSections = [
  {
    'key': 'section1',
    'icon': Icons.psychology_rounded,
    'color': 0xFF2D7EA8,
  },
  {
    'key': 'section2',
    'icon': Icons.favorite_rounded,
    'color': 0xFF1D6B50,
  },
  {
    'key': 'section3',
    'icon': Icons.help_outline_rounded,
    'color': 0xFF3A9A7A,
  },
  {
    'key': 'section4',
    'icon': Icons.waves_rounded,
    'color': 0xFF1D4E6B,
  },
  {
    'key': 'section5',
    'icon': Icons.shield_rounded,
    'color': 0xFF2A6F94,
  },
  {
    'key': 'section6',
    'icon': Icons.medical_services_rounded,
    'color': 0xFF1D6B50,
  },
  {
    'key': 'section7',
    'icon': Icons.health_and_safety_rounded,
    'color': 0xFF2D7EA8,
  },
  {
    'key': 'section8',
    'icon': Icons.schedule_rounded,
    'color': 0xFF5A9E7E,
  },
  {
    'key': 'section9',
    'icon': Icons.local_hospital_rounded,
    'color': 0xFF1D4E6B,
  },
  {
    'key': 'section10',
    'icon': Icons.info_outline_rounded,
    'color': 0xFF3D4F5C,
  },
];

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cs.primary,
              ),
              child: Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      isRTL ? Icons.chevron_right : Icons.chevron_left,
                      color: cs.onPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: cs.onPrimary.withCalmAlpha(0.15),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BilingualLine(
                      translationKey: 'education.title',
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      primaryStyle: TextStyle(
                        fontSize: 24,
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      secondaryStyle: TextStyle(
                        fontSize: 16,
                        color: cs.onPrimary.withCalmAlpha(0.85),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: _educationSections.map((section) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EducationCard(
                          titleKey: 'education.${section['key']}',
                          contentKey: 'education.${section['key']}.text',
                          icon: section['icon'] as IconData,
                          color: Color(section['color'] as int),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String titleKey;
  final String contentKey;
  final IconData icon;
  final Color color;

  const EducationCard({
    super.key,
    required this.titleKey,
    required this.contentKey,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withCalmAlpha(0.65);
    final title = languageProvider.t(titleKey);
    final content = languageProvider.t(contentKey);
    final showBoth = context.watch<AppSettingsProvider>().showBilingualCaptions;
    final titleAlt = showBoth ? languageProvider.tAlternate(titleKey) : '';
    final contentAlt = showBoth ? languageProvider.tAlternate(contentKey) : '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withCalmAlpha(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withCalmAlpha(theme.brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withCalmAlpha(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
            ],
          ),
          if (titleAlt.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              titleAlt,
              style: TextStyle(
                fontSize: 16,
                color: muted,
                height: 1.45,
              ),
              textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
            ),
          ],
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: muted,
              height: 1.6,
            ),
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
          if (contentAlt.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              contentAlt,
              style: TextStyle(
                fontSize: 16,
                color: muted.withCalmAlpha(0.92),
                height: 1.6,
              ),
              textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }
}
