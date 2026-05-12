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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141A18) : const Color(0xFFF4F2ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          lang.t('app.name'),
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFFECEAE0) : const Color(0xFF2A2A25),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: lang.t('home.settings'),
            color: isDark ? const Color(0xFF8A9488) : const Color(0xFF7C7B72),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SceneBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  lang.t('home.greeting'),
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: isDark ? const Color(0xFF8A9488) : const Color(0xFF7C7B72),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // SECTION: Immediate Help
                _buildSectionHeader(lang.t('home.self.title'), isDark),
                const SizedBox(height: 12),
                GlassCard(
                  tintColor: DesignSystem.glassSage,
                  tintOpacity: 0.22,
                  onTap: () {
                    context.read<InterventionStateProvider>().startWithSeverity(SeverityLevel.moderate);
                    Navigator.pushNamed(context, AppRoutes.selfRegulation);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignSystem.glassSage.withValues(alpha: 0.4),
                        ),
                        child: const Icon(Icons.favorite_rounded, color: DesignSystem.accentSage, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.t('home.self.subtitle'),
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFFECEAE0) : const Color(0xFF2A2A25),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lang.t('severity.moderate.sub'),
                              style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF8A9488) : const Color(0xFF7C7B72)),
                            ),
                          ],
                        ),
                      ),
                      Icon(isRTL ? Icons.chevron_left : Icons.chevron_right, color: cs.primary),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // SECTION: Helping Others
                _buildSectionHeader(lang.t('home.helper.title'), isDark),
                const SizedBox(height: 12),
                GlassCard(
                  tintColor: DesignSystem.glassLavender,
                  tintOpacity: 0.20,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.helperGuidance),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignSystem.glassLavender.withValues(alpha: 0.4),
                        ),
                        child: const Icon(Icons.people_alt_outlined, color: DesignSystem.accentLavender, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          lang.t('home.helper.subtitle'),
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFECEAE0) : const Color(0xFF2A2A25),
                          ),
                        ),
                      ),
                      Icon(isRTL ? Icons.chevron_left : Icons.chevron_right, color: DesignSystem.accentLavender),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // SECTION: Calm Corner
                _buildSectionHeader(lang.t('calm.corner.title'), isDark),
                const SizedBox(height: 12),
                GlassCard(
                  tintColor: DesignSystem.glassMist,
                  tintOpacity: 0.25,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.calmCorner),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignSystem.glassMist.withValues(alpha: 0.4),
                        ),
                        child: const Icon(Icons.spa_outlined, color: DesignSystem.accentSage, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          lang.t('calm.corner.subtitle'),
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFECEAE0) : const Color(0xFF2A2A25),
                          ),
                        ),
                      ),
                      Icon(isRTL ? Icons.chevron_left : Icons.chevron_right, color: DesignSystem.accentSage),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // SECTION: Learning & Emergency
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        tintColor: DesignSystem.glassPeach,
                        tintOpacity: 0.18,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.education),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.auto_stories_outlined, color: Colors.orangeAccent),
                            const SizedBox(height: 12),
                            Text(lang.t('home.learn'), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        tintColor: const Color(0xFFFFEAEA),
                        tintOpacity: 0.25,
                        onTap: () => EmergencyModal.show(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.emergency_outlined, color: Colors.redAccent),
                            const SizedBox(height: 12),
                            Text(lang.t('home.emergency'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.dmSerifDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: isDark ? const Color(0xFFECEAE0) : const Color(0xFF2A2A25),
      ),
    );
  }
}
