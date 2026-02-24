import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../routes/app_routes.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  void _handleLanguageSelect(BuildContext context, String lang) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.setLanguage(lang);
    Navigator.pushReplacementNamed(context, AppRoutes.disclaimer);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3ED),
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
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Column(
                            children: [
                              Text(
                                languageProvider.t('language.title'),
                                style: const TextStyle(
                                  fontSize: 36,
                                  color: Color(0xFF2C3E50),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                languageProvider.t('language.subtitle'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF5A6C7D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 80,
                                child: ElevatedButton(
                                  onPressed: () => _handleLanguageSelect(context, 'en'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF2C3E50),
                                    side: const BorderSide(
                                      color: Color(0xFF4A9B99),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onLongPress: null,
                                  child: const Text(
                                    'English',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 80,
                                child: ElevatedButton(
                                  onPressed: () => _handleLanguageSelect(context, 'ur'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF2C3E50),
                                    side: const BorderSide(
                                      color: Color(0xFF4A9B99),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onLongPress: null,
                                  child: const Text(
                                    'اردو',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
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
