import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../theme/calm_palette.dart';

/// **Assignment — named animation:** [RotationTransition] on settings section chevrons ([SettingsSection]).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _expandedSection;
  bool _hapticBreathing = true;
  bool _anonymousUsage = true;

  late final TextEditingController _emergencyController;
  late final TextEditingController _trustedController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _emergencyController = TextEditingController();
    _trustedController = TextEditingController();
    _messageController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _emergencyController.dispose();
    _trustedController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final defaultMessage = lang.t('settings.message.default');
    setState(() {
      _hapticBreathing = prefs.getBool('jayepanah_haptic') ?? true;
      _anonymousUsage = prefs.getBool('jayepanah_anonymous') ?? true;
      _emergencyController.text = prefs.getString('jayepanah_emergency_number') ?? '1122';
      _trustedController.text = prefs.getString('jayepanah_trusted_contact') ?? '';
      _messageController.text =
          prefs.getString('jayepanah_message_template') ?? defaultMessage;
    });
  }

  Future<void> _handleReset() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          languageProvider.t('settings.reset.dialog.title'),
          textDirection: languageProvider.isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        content: Text(
          languageProvider.t('settings.reset.dialog.body'),
          textDirection: languageProvider.isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(languageProvider.t('settings.reset.dialog.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(languageProvider.t('settings.reset.dialog.confirm')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return;
      await context.read<AppSettingsProvider>().reload();
      await languageProvider.setLanguage('en');
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSection = _expandedSection == section ? null : section;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appSettings = context.watch<AppSettingsProvider>();
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
                    child: Text(
                      languageProvider.t('settings.title'),
                      style: TextStyle(
                        fontSize: 24,
                        color: cs.onPrimary,
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
                    children: [
                      SettingsSection(
                        title: languageProvider.t('settings.general'),
                        icon: Icons.text_fields,
                        expanded: _expandedSection == 'general',
                        onToggle: () => _toggleSection('general'),
                        isRTL: isRTL,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.language'),
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            RadioListTile<String>(
                              title: const Text('English'),
                              value: 'en',
                              groupValue: languageProvider.currentLanguage,
                              onChanged: (value) {
                                if (value != null) {
                                  languageProvider.setLanguage(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: const Text('اردو', textDirection: TextDirection.rtl),
                              value: 'ur',
                              groupValue: languageProvider.currentLanguage,
                              onChanged: (value) {
                                if (value != null) {
                                  languageProvider.setLanguage(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.textsize'),
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.small')),
                              value: 'small',
                              groupValue: appSettings.textSize,
                              onChanged: (value) async {
                                if (value != null) {
                                  await appSettings.setTextSize(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.medium')),
                              value: 'medium',
                              groupValue: appSettings.textSize,
                              onChanged: (value) async {
                                if (value != null) {
                                  await appSettings.setTextSize(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.large')),
                              value: 'large',
                              groupValue: appSettings.textSize,
                              onChanged: (value) async {
                                if (value != null) {
                                  await appSettings.setTextSize(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 24),
                            SettingToggle(
                              label: languageProvider.t('settings.reducemotion'),
                              checked: appSettings.reduceMotion,
                              onChanged: (value) async {
                                await appSettings.setReduceMotion(value);
                              },
                              icon: Icons.flash_on,
                              isRTL: isRTL,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              languageProvider.t('settings.appearance'),
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.theme.system')),
                              value: 'system',
                              groupValue: appSettings.themePreference,
                              onChanged: (value) async {
                                if (value != null) {
                                  await appSettings.setThemePreference(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.theme.light')),
                              value: 'light',
                              groupValue: appSettings.themePreference,
                              onChanged: (value) async {
                                if (value != null) {
                                  await appSettings.setThemePreference(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.theme.dark')),
                              value: 'dark',
                              groupValue: appSettings.themePreference,
                              onChanged: (value) async {
                                if (value != null) {
                                  await appSettings.setThemePreference(value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSection(
                        title: languageProvider.t('settings.guidance'),
                        icon: Icons.vibration,
                        expanded: _expandedSection == 'guidance',
                        onToggle: () => _toggleSection('guidance'),
                        isRTL: isRTL,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            SettingToggle(
                              label: languageProvider.t('settings.haptic'),
                              checked: _hapticBreathing,
                              onChanged: (value) async {
                                setState(() => _hapticBreathing = value);
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('jayepanah_haptic', value);
                              },
                              icon: Icons.vibration,
                              isRTL: isRTL,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSection(
                        title: languageProvider.t('settings.emergency'),
                        icon: Icons.phone,
                        expanded: _expandedSection == 'emergency',
                        onToggle: () => _toggleSection('emergency'),
                        isRTL: isRTL,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.emergencynumber'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _emergencyController,
                              onChanged: (value) async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('jayepanah_emergency_number', value);
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '1122',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD4CFC4)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD4CFC4)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF4A9B99), width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.trustedcontacts'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.contacts.hint'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.5,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _trustedController,
                              onChanged: (value) async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('jayepanah_trusted_contact', value);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD4CFC4)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD4CFC4)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF4A9B99), width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.messagetemplate'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.message.hint'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.5,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _messageController,
                              maxLines: 3,
                              onChanged: (value) async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('jayepanah_message_template', value);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD4CFC4)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD4CFC4)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF4A9B99), width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSection(
                        title: languageProvider.t('settings.safety'),
                        icon: Icons.shield,
                        expanded: _expandedSection == 'safety',
                        onToggle: () => _toggleSection('safety'),
                        isRTL: isRTL,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.datausage'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.datausage.description'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            SettingToggle(
                              label: languageProvider.t('settings.anonymous'),
                              checked: _anonymousUsage,
                              onChanged: (value) async {
                                setState(() => _anonymousUsage = value);
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('jayepanah_anonymous', value);
                              },
                              isRTL: isRTL,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.reset'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.reset.description'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                onPressed: _handleReset,
                                style: FilledButton.styleFrom(
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                                      ? CalmPalette.darkMidBlue
                                      : CalmPalette.lightMidBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  languageProvider.t('settings.reset.button'),
                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSection(
                        title: languageProvider.t('settings.about'),
                        icon: Icons.info,
                        expanded: _expandedSection == 'about',
                        onToggle: () => _toggleSection('about'),
                        isRTL: isRTL,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.purpose'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.purpose.text'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.disclaimer'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.disclaimer.text'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.resources'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.t('settings.resources.text'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.store.privacy'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class SettingsSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final bool isRTL;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.expanded,
    required this.onToggle,
    required this.child,
    required this.isRTL,
  });

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> with SingleTickerProviderStateMixin {
  late AnimationController _chevronController;
  late Animation<double> _chevronTurns;

  @override
  void initState() {
    super.initState();
    _chevronController = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    );
    _chevronTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _chevronController, curve: Curves.easeInOutCubic),
    );
    if (widget.expanded) {
      _chevronController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expanded != widget.expanded) {
      final rm = Provider.of<AppSettingsProvider>(context, listen: false).reduceMotion;
      _chevronController.duration = rm ? Duration.zero : const Duration(milliseconds: 850);
      if (widget.expanded) {
        _chevronController.forward();
      } else {
        _chevronController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _chevronController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.colorScheme.primary;
    final outline = theme.colorScheme.outline.withCalmAlpha(0.35);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outline.withCalmAlpha(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withCalmAlpha(theme.brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onToggle,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primary.withCalmAlpha(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon, color: primary, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          color: onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ),
                    // Assignment: RotationTransition
                    RotationTransition(
                      turns: _chevronTurns,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: onSurface.withCalmAlpha(0.55),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: widget.expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: outline.withCalmAlpha(0.6)),
                        ),
                      ),
                      child: widget.child,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class SettingToggle extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final bool isRTL;

  const SettingToggle({
    super.key,
    required this.label,
    required this.checked,
    required this.onChanged,
    this.icon,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: onSurface.withCalmAlpha(0.55), size: 20),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: onSurface,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: checked,
          onChanged: onChanged,
          activeThumbColor: primary,
          activeTrackColor: primary.withCalmAlpha(0.45),
        ),
      ],
    );
  }
}
