import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';

const _educationSections = [
  {
    'key': 'section1',
    'icon': Icons.psychology,
    'color': 0xFF4A9B99,
  },
  {
    'key': 'section2',
    'icon': Icons.favorite,
    'color': 0xFF7FA99E,
  },
  {
    'key': 'section3',
    'icon': Icons.help_outline,
    'color': 0xFF8FAA85,
  },
  {
    'key': 'section4',
    'icon': Icons.warning_amber,
    'color': 0xFFD6A545,
  },
  {
    'key': 'section5',
    'icon': Icons.shield,
    'color': 0xFF7FA99E,
  },
  {
    'key': 'section6',
    'icon': Icons.medical_services,
    'color': 0xFF4A9B99,
  },
];

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3ED),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF4A9B99),
              ),
              child: Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      isRTL ? Icons.chevron_right : Icons.chevron_left,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      languageProvider.t('education.title'),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                          title: languageProvider.t('education.${section['key']}'),
                          content: languageProvider.t('education.${section['key']}.text'),
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
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const EducationCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF2C3E50),
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF5A6C7D),
              height: 1.6,
            ),
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}
