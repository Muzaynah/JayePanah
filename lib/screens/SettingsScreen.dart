import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../components/EmergencyModal.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _hapticBreathing = true;
  late final TextEditingController _emergencyController;

  @override
  void initState() {
    super.initState();
    _emergencyController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _emergencyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _hapticBreathing = prefs.getBool('jayepanah_haptic') ?? true;
      _emergencyController.text = prefs.getString('jayepanah_emergency_number') ?? '1122';
    });
  }

  Future<void> _saveEmergencyNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jayepanah_emergency_number', number);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final appSettings = context.watch<AppSettingsProvider>();
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
                    child: Text(
                      lang.t('settings.title'),
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
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
                    // Theme selection
                    Text(
                      'Theme',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: isDark
                            ? DesignSystem.darkTextSecondary
                            : DesignSystem.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ThemeButton(
                            label: 'System',
                            isSelected: appSettings.themePreference == 'system',
                            isDark: isDark,
                            onTap: () => appSettings.setThemePreference('system'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ThemeButton(
                            label: 'Light',
                            isSelected: appSettings.themePreference == 'light',
                            isDark: isDark,
                            onTap: () => appSettings.setThemePreference('light'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ThemeButton(
                            label: 'Dark',
                            isSelected: appSettings.themePreference == 'dark',
                            isDark: isDark,
                            onTap: () => appSettings.setThemePreference('dark'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Language selection
                    Text(
                      lang.t('settings.language'),
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: isDark
                            ? DesignSystem.darkTextSecondary
                            : DesignSystem.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: DesignSystem.textSecondary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: lang.currentLanguage == 'en'
                                  ? DesignSystem.accentSage
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () => lang.setLanguage('en'),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'English',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                      color: lang.currentLanguage == 'en'
                                          ? Colors.white
                                          : DesignSystem.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            color: DesignSystem.textSecondary.withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: Material(
                              color: lang.currentLanguage == 'ur'
                                  ? DesignSystem.accentSage
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () => lang.setLanguage('ur'),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'اردو',
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.nunito(
                                      color: lang.currentLanguage == 'ur'
                                          ? Colors.white
                                          : DesignSystem.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Haptic Feedback
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.t('settings.haptic'),
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? DesignSystem.darkTextPrimary
                                : DesignSystem.textPrimary,
                          ),
                        ),
                        Switch(
                          value: _hapticBreathing,
                          onChanged: (value) async {
                            setState(() => _hapticBreathing = value);
                            final prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('jayepanah_haptic', value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Emergency Number
                    Text(
                      lang.t('settings.emergencynumber'),
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: isDark
                            ? DesignSystem.darkTextSecondary
                            : DesignSystem.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emergencyController,
                      keyboardType: TextInputType.phone,
                      onSubmitted: _saveEmergencyNumber,
                      style: TextStyle(
                        color: isDark
                            ? DesignSystem.darkTextPrimary
                            : DesignSystem.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '1122',
                        hintStyle: TextStyle(
                          color: isDark
                              ? DesignSystem.darkTextSecondary
                              : DesignSystem.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => EmergencyModal.show(context),
                        icon: const Icon(Icons.phone_in_talk_rounded),
                        label: Text(lang.t('home.emergency')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4635F)
                              .withValues(alpha: 0.8),
                        ),
                      ),
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

class _ThemeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? DesignSystem.accentSage : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? DesignSystem.accentSage
                  : DesignSystem.textSecondary.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? DesignSystem.darkTextPrimary
                        : DesignSystem.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
