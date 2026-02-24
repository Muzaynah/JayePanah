import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../routes/app_routes.dart';

const _onboardingSteps = [
  {
    'key': 'what',
    'titleKey': 'onboarding.what.title',
    'descriptionKey': 'onboarding.what.description',
  },
  {
    'key': 'whatnot',
    'titleKey': 'onboarding.whatnot.title',
    'descriptionKey': 'onboarding.whatnot.description',
  },
  {
    'key': 'privacy',
    'titleKey': 'onboarding.privacy.title',
    'descriptionKey': 'onboarding.privacy.description',
  },
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;

  void _handleContinue() {
    if (_currentStep < _onboardingSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.languageSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final step = _onboardingSteps[_currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(isRTL ? -0.2 : 0.2, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        key: ValueKey(_currentStep),
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageProvider.t(step['titleKey']!),
                            style: const TextStyle(
                              fontSize: 36,
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            languageProvider.t(step['descriptionKey']!),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF5A6C7D),
                              height: 1.6,
                            ),
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: List.generate(
                  _onboardingSteps.length,
                  (index) => Expanded(
                    child: Container(
                      height: 6,
                      margin: EdgeInsetsDirectional.only(
                        end: index < _onboardingSteps.length - 1 ? 8 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: index == _currentStep
                            ? const Color(0xFF4A9B99)
                            : const Color(0xFFD4CFC4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A9B99),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        languageProvider.t('onboarding.continue'),
                        style: const TextStyle(fontSize: 18),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isRTL ? Icons.chevron_left : Icons.chevron_right,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
