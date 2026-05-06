import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../providers/InterventionStateProvider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../components/EmergencyModal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _emergencyNumber = '1122';

  @override
  void initState() {
    super.initState();
    _loadEmergencyNumber();
  }

  Future<void> _loadEmergencyNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emergencyNumber = prefs.getString('jayepanah_emergency_number') ?? '1122';
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isRTL = lang.isRTL;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141A18) : const Color(0xFFF4F2ED),
      body: SceneBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with greeting
                Padding(
                  padding: const EdgeInsets.only(bottom: DesignSystem.spaceXL),
                  child: Column(
                    crossAxisAlignment: isRTL
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.t('app.name'),
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFFECEAE0)
                              : const Color(0xFF2A2A25),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lang.t('home.greeting'),
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFF8A9488)
                              : const Color(0xFF7C7B72),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Main action card
                GlassCard(
                  tintColor: DesignSystem.glassSage,
                  tintOpacity: 0.22,
                  onTap: () {
                    context.read<InterventionStateProvider>().startWithSeverity(
                          SeverityLevel.moderate,
                        );
                    Navigator.pushNamed(context, AppRoutes.selfRegulation);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DesignSystem.glassSage.withValues(alpha: 0.4),
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: DesignSystem.accentSage,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.t('home.self.title'),
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? const Color(0xFFECEAE0)
                                        : const Color(0xFF2A2A25),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lang.t('home.self.subtitle'),
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? const Color(0xFF8A9488)
                                        : const Color(0xFF7C7B72),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<InterventionStateProvider>().startWithSeverity(
                                SeverityLevel.moderate,
                              );
                          Navigator.pushNamed(context, AppRoutes.selfRegulation);
                        },
                        child: Text(lang.t('self.stabilization.start')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Helper section label
                Text(
                  lang.t('home.helper.title'),
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFFECEAE0)
                        : const Color(0xFF2A2A25),
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceMD),
                // Helper and Calm Corner cards
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        tintColor: DesignSystem.glassLavender,
                        tintOpacity: 0.20,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.helperGuidance),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: DesignSystem.glassLavender
                                    .withValues(alpha: 0.4),
                              ),
                              child: const Icon(
                                Icons.people_outline,
                                color: DesignSystem.accentLavender,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              lang.t('home.helper.subtitle'),
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFF8A9488)
                                    : const Color(0xFF7C7B72),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignSystem.spaceMD),
                    Expanded(
                      child: GlassCard(
                        tintColor: DesignSystem.glassMist,
                        tintOpacity: 0.25,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.calmCorner),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: DesignSystem.glassMist.withValues(alpha: 0.4),
                              ),
                              child: const Icon(
                                Icons.local_florist_outlined,
                                color: DesignSystem.accentSage,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              lang.t('calm.corner.subtitle'),
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFF8A9488)
                                    : const Color(0xFF7C7B72),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Learn section
                GlassCard(
                  tintColor: DesignSystem.glassPeach,
                  tintOpacity: 0.18,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.education),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignSystem.glassPeach.withValues(alpha: 0.4),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: DesignSystem.accentSage,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          lang.t('home.learn'),
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFECEAE0)
                                : const Color(0xFF2A2A25),
                          ),
                        ),
                      ),
                      Icon(
                        isRTL ? Icons.chevron_left : Icons.chevron_right,
                        color: isDark
                            ? const Color(0xFF8A9488)
                            : const Color(0xFF7C7B72),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Settings button
                OutlinedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.settings),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.settings_outlined),
                      const SizedBox(width: 8),
                      Text(lang.t('home.settings')),
                    ],
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Emergency section
                if (_emergencyNumber.isNotEmpty)
                  GlassCard(
                    tintColor: const Color(0xFFFFEAEA),
                    tintOpacity: 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          lang.t('home.emergency.call_title'),
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFF8A9488)
                                : const Color(0xFF7C7B72),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _emergencyNumber,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFFECEAE0)
                                : const Color(0xFF2A2A25),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => EmergencyModal.show(context),
                          icon: const Icon(Icons.phone_in_talk_rounded),
                          label: Text(lang.t('home.emergency')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFD4635F).withValues(alpha: 0.8),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: DesignSystem.spaceXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
