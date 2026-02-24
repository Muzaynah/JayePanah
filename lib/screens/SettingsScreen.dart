import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/LanguageProvider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _expandedSection;
  String _textSize = 'medium';
  bool _reduceMotion = false;
  bool _darkMode = false;
  bool _audioGuidance = true;
  String _voiceType = 'neutral';
  bool _hapticBreathing = true;
  String _emergencyNumber = '1122';
  bool _anonymousUsage = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textSize = prefs.getString('jayepanah_textsize') ?? 'medium';
      _reduceMotion = prefs.getBool('jayepanah_reducemotion') ?? false;
      _darkMode = prefs.getBool('jayepanah_darkmode') ?? false;
      _audioGuidance = prefs.getBool('jayepanah_audio') ?? true;
      _voiceType = prefs.getString('jayepanah_voice') ?? 'neutral';
      _hapticBreathing = prefs.getBool('jayepanah_haptic') ?? true;
      _emergencyNumber = prefs.getString('jayepanah_emergency_number') ?? '1122';
      _anonymousUsage = prefs.getBool('jayepanah_anonymous') ?? true;
    });
  }

  Future<void> _handleReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
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
                      languageProvider.t('settings.title'),
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
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
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
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.small')),
                              value: 'small',
                              groupValue: _textSize,
                              onChanged: (value) async {
                                if (value != null) {
                                  setState(() => _textSize = value);
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('jayepanah_textsize', value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.medium')),
                              value: 'medium',
                              groupValue: _textSize,
                              onChanged: (value) async {
                                if (value != null) {
                                  setState(() => _textSize = value);
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('jayepanah_textsize', value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.large')),
                              value: 'large',
                              groupValue: _textSize,
                              onChanged: (value) async {
                                if (value != null) {
                                  setState(() => _textSize = value);
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('jayepanah_textsize', value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 24),
                            SettingToggle(
                              label: languageProvider.t('settings.reducemotion'),
                              checked: _reduceMotion,
                              onChanged: (value) async {
                                setState(() => _reduceMotion = value);
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('jayepanah_reducemotion', value);
                              },
                              icon: Icons.flash_on,
                              isRTL: isRTL,
                            ),
                            const SizedBox(height: 16),
                            SettingToggle(
                              label: languageProvider.t('settings.darkmode'),
                              checked: _darkMode,
                              onChanged: (value) async {
                                setState(() => _darkMode = value);
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('jayepanah_darkmode', value);
                              },
                              icon: Icons.dark_mode,
                              isRTL: isRTL,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSection(
                        title: languageProvider.t('settings.guidance'),
                        icon: Icons.volume_up,
                        expanded: _expandedSection == 'guidance',
                        onToggle: () => _toggleSection('guidance'),
                        isRTL: isRTL,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            SettingToggle(
                              label: languageProvider.t('settings.audio'),
                              checked: _audioGuidance,
                              onChanged: (value) async {
                                setState(() => _audioGuidance = value);
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('jayepanah_audio', value);
                              },
                              icon: Icons.volume_up,
                              isRTL: isRTL,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              languageProvider.t('settings.voicetype'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 12),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.voice.neutral')),
                              value: 'neutral',
                              groupValue: _voiceType,
                              onChanged: (value) async {
                                if (value != null) {
                                  setState(() => _voiceType = value);
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('jayepanah_voice', value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text(languageProvider.t('settings.voice.human')),
                              value: 'human',
                              groupValue: _voiceType,
                              onChanged: (value) async {
                                if (value != null) {
                                  setState(() => _voiceType = value);
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('jayepanah_voice', value);
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 24),
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
                              controller: TextEditingController(text: _emergencyNumber),
                              onChanged: (value) async {
                                setState(() => _emergencyNumber = value);
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
                              'Feature coming soon',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                              'Feature coming soon',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A6C7D),
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _handleReset,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD64545),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  languageProvider.t('settings.reset.button'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

class SettingsSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A9B99).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: const Color(0xFF4A9B99), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ),
                    Icon(
                      isRTL
                          ? (expanded ? Icons.chevron_left : Icons.chevron_right)
                          : (expanded ? Icons.chevron_right : Icons.chevron_left),
                      color: const Color(0xFF5A6C7D),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: const Color(0xFFD4CFC4).withOpacity(0.3)),
                        ),
                      ),
                      child: child,
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
                Icon(icon, color: const Color(0xFF5A6C7D), size: 20),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
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
          activeColor: const Color(0xFF4A9B99),
        ),
      ],
    );
  }
}
