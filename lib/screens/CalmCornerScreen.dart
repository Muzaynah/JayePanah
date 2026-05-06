import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class CalmCornerScreen extends StatelessWidget {
  const CalmCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRTL = lang.isRTL;

    return Scaffold(
      backgroundColor: isDark ? DesignSystem.darkBase : DesignSystem.lightBase,
      body: SceneBackground(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: DesignSystem.accentSage),
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
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isRTL
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t('calm.corner.title'),
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang.t('calm.corner.subtitle'),
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    _CalmCard(
                      title: lang.t('calm.sounds.title'),
                      subtitle: lang.t('calm.sounds.subtitle'),
                      icon: Icons.music_note_rounded,
                      color: DesignSystem.accentSage,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.soundGallery),
                      isRTL: isRTL,
                    ),
                    const SizedBox(height: 24),
                    _CalmCard(
                      title: lang.t('calm.game.title'),
                      subtitle: lang.t('calm.game.subtitle'),
                      icon: Icons.bubble_chart_rounded,
                      color: DesignSystem.accentLavender,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.bubbleGame),
                      isRTL: isRTL,
                    ),
                    const SizedBox(height: 24),
                    _CalmCard(
                      title: lang.t('calm.match.title'),
                      subtitle: lang.t('calm.match.subtitle'),
                      icon: Icons.dashboard_rounded,
                      color: const Color(0xFFB19CD9),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.tileMatch),
                      isRTL: isRTL,
                    ),
                    const SizedBox(height: 24),
                    _CalmCard(
                      title: lang.t('calm.color.title'),
                      subtitle: lang.t('calm.color.subtitle'),
                      icon: Icons.palette_rounded,
                      color: const Color(0xFF7EC17F),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.colorCycle),
                      isRTL: isRTL,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalmCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isRTL;

  const _CalmCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      tintColor: color,
      tintOpacity: 0.15,
      onTap: onTap,
      child: Row(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? DesignSystem.darkTextPrimary
                        : DesignSystem.textPrimary,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: isDark
                        ? DesignSystem.darkTextSecondary
                        : DesignSystem.textSecondary,
                    height: 1.4,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            isRTL ? Icons.chevron_left : Icons.chevron_right,
            color: color.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
