import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/bilingual_line.dart';

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

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  int? _exitingStep;
  late AnimationController _slideController;
  late Animation<Offset> _incomingPosition;
  late Animation<Offset> _outgoingPosition;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _slideController.addStatusListener(_onSlideStatus);
    _updateSlideAnimations();
  }

  void _updateSlideAnimations() {
    final reduceMotion = context.read<AppSettingsProvider>().reduceMotion;
    _slideController.duration = reduceMotion ? Duration.zero : const Duration(milliseconds: 700);
    _incomingPosition = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeInOutCubic));
    _outgoingPosition = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeInOutCubic));
  }

  void _onSlideStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _exitingStep = null;
      });
      _slideController.reset();
    }
  }

  @override
  void dispose() {
    _slideController.removeStatusListener(_onSlideStatus);
    _slideController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_currentStep < _onboardingSteps.length - 1) {
      final reduceMotion = context.read<AppSettingsProvider>().reduceMotion;
      if (reduceMotion) {
        setState(() => _currentStep++);
        return;
      }
      _updateSlideAnimations();
      setState(() {
        _exitingStep = _currentStep;
        _currentStep++;
      });
      _slideController.forward(from: 0);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.languageSelection);
    }
  }

  Widget _buildStepContent(int index) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final step = _onboardingSteps[index];
    final theme = Theme.of(context);
    final onBg = theme.colorScheme.onSurface;
    final muted = onBg.withValues(alpha: 0.68);

    return Column(
      key: ValueKey(index),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BilingualLine(
          translationKey: step['titleKey']!,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          primaryStyle: TextStyle(
            fontSize: 34,
            color: onBg,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
          secondaryStyle: TextStyle(
            fontSize: 17,
            color: muted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),
        BilingualLine(
          translationKey: step['descriptionKey']!,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          primaryStyle: TextStyle(
            fontSize: 19,
            color: muted,
            height: 1.55,
          ),
          secondaryStyle: TextStyle(
            fontSize: 17,
            color: muted.withValues(alpha: 0.92),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final exiting = _exitingStep;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: exiting == null
                        ? _buildStepContent(_currentStep)
                        : AnimatedBuilder(
                            animation: _slideController,
                            builder: (context, child) {
                              return Stack(
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  // Assignment: SlideTransition (outgoing step)
                                  SlideTransition(
                                    position: _outgoingPosition,
                                    child: _buildStepContent(exiting),
                                  ),
                                  // Assignment: SlideTransition (incoming step)
                                  SlideTransition(
                                    position: _incomingPosition,
                                    child: _buildStepContent(_currentStep),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _handleContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        languageProvider.t('onboarding.continue'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isRTL ? Icons.chevron_left : Icons.chevron_right,
                        size: 22,
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
