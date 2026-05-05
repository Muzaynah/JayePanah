import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../routes/app_routes.dart';
import '../theme/calm_palette.dart';
import '../widgets/bilingual_line.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _isChecked = false;

  Future<void> _handleContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('jayepanah_onboarding_complete', true);
    if (!mounted) return;
    context.read<AppSettingsProvider>().markInitialOnboardingComplete();
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final muted = cs.onSurface.withCalmAlpha(0.68);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 16 * (1 - value)),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BilingualLine(
                            translationKey: 'disclaimer.title',
                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
                            primaryStyle: TextStyle(
                              fontSize: 34,
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            secondaryStyle: TextStyle(
                              fontSize: 17,
                              color: muted,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: cs.outline.withCalmAlpha(0.28)),
                            ),
                            child: BilingualLine(
                              translationKey: 'disclaimer.text',
                              textAlign: isRTL ? TextAlign.right : TextAlign.left,
                              primaryStyle: TextStyle(
                                fontSize: 16,
                                color: muted,
                                height: 1.6,
                              ),
                              secondaryStyle: TextStyle(
                                fontSize: 16,
                                color: muted.withCalmAlpha(0.92),
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value ?? false;
                                    });
                                  },
                                  activeColor: cs.primary,
                                  checkColor: cs.onPrimary,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isChecked = !_isChecked;
                                    });
                                  },
                                  child: BilingualLine(
                                    translationKey: 'disclaimer.understand',
                                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                    primaryStyle: TextStyle(
                                      fontSize: 17,
                                      color: cs.onSurface,
                                    ),
                                    secondaryStyle: TextStyle(
                                      fontSize: 16,
                                      color: muted,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: _isChecked ? _handleContinue : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                disabledBackgroundColor: cs.primary.withCalmAlpha(0.45),
                                disabledForegroundColor: cs.onPrimary.withCalmAlpha(0.75),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                languageProvider.t('disclaimer.continue'),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
