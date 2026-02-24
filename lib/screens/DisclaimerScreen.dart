import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/LanguageProvider.dart';
import '../routes/app_routes.dart';

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
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageProvider.t('disclaimer.title'),
                            style: const TextStyle(
                              fontSize: 36,
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFD4CFC4)),
                            ),
                            child: Text(
                              languageProvider.t('disclaimer.text'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF5A6C7D),
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFF4A9B99),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isChecked = !_isChecked;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      languageProvider.t('disclaimer.understand'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF2C3E50),
                                      ),
                                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isChecked ? _handleContinue : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A9B99),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: const Color(0xFF4A9B99).withOpacity(0.5),
                                disabledForegroundColor: Colors.white.withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                languageProvider.t('disclaimer.continue'),
                                style: const TextStyle(fontSize: 18),
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
