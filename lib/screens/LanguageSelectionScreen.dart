import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../routes/app_routes.dart';
import '../widgets/bilingual_line.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  void _handleLanguageSelect(BuildContext context, String lang) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.setLanguage(lang);
    Navigator.pushReplacementNamed(context, AppRoutes.disclaimer);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onBg = cs.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 16 * (1 - value)),
                          child: Column(
                            children: [
                              BilingualLine(
                                translationKey: 'language.title',
                                primaryStyle: TextStyle(
                                  fontSize: 34,
                                  color: onBg,
                                  fontWeight: FontWeight.w600,
                                ),
                                secondaryStyle: TextStyle(
                                  fontSize: 17,
                                  color: onBg.withValues(alpha: 0.65),
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 14),
                              BilingualLine(
                                translationKey: 'language.subtitle',
                                primaryStyle: TextStyle(
                                  fontSize: 17,
                                  color: onBg.withValues(alpha: 0.68),
                                  height: 1.4,
                                ),
                                secondaryStyle: TextStyle(
                                  fontSize: 16,
                                  color: onBg.withValues(alpha: 0.55),
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 36),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: () => _handleLanguageSelect(context, 'en'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: onBg,
                                    side: BorderSide(color: cs.primary.withValues(alpha: 0.65), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: cs.surface,
                                  ),
                                  child: const Text(
                                    'English',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: FilledButton(
                                  onPressed: () => _handleLanguageSelect(context, 'ur'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    foregroundColor: cs.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'اردو',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
