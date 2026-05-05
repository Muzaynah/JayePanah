import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/calm_palette.dart';
import '../../widgets/bilingual_line.dart';
import '../../components/crisis_home_button.dart';

const _steps = [
  {'icon': Icons.stay_current_portrait_rounded, 'key': 'helper.immediate.stay'},
  {'icon': Icons.people_rounded, 'key': 'helper.immediate.with'},
  {'icon': Icons.volume_down_rounded, 'key': 'helper.immediate.lower'},
];

class ImmediateResponseScreen extends StatefulWidget {
  const ImmediateResponseScreen({super.key});

  @override
  State<ImmediateResponseScreen> createState() => _ImmediateResponseScreenState();
}

class _ImmediateResponseScreenState extends State<ImmediateResponseScreen> {
  int _step = 0;

  void _handleNext(BuildContext context) {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
      interventionState.setHelperScreen(HelperGuidanceScreen.communication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final phase = CalmPalette.helper(context);
    final item = _steps[_step];

    return PopScope(
      canPop: false,
      child: Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: phase.backgroundGradient),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  children: [
                    BilingualLine(
                      translationKey: 'helper.immediate.title',
                      primaryStyle: TextStyle(
                        fontSize: 22,
                        color: phase.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      secondaryStyle: TextStyle(
                        fontSize: 16,
                        color: phase.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                color: phase.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: phase.secondary.withCalmAlpha(0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                size: 52,
                                color: phase.accent,
                              ),
                            ),
                            const SizedBox(height: 36),
                            BilingualLine(
                              translationKey: item['key'] as String,
                              primaryStyle: TextStyle(
                                fontSize: 26,
                                color: phase.textPrimary,
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                              ),
                              secondaryStyle: TextStyle(
                                fontSize: 17,
                                color: phase.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () => _handleNext(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: phase.ctaBackground,
                          foregroundColor: phase.ctaForeground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          languageProvider.t('helper.next'),
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            CrisisHomeButton(
              backgroundColor: phase.surface,
              iconColor: phase.textPrimary,
              borderColor: phase.textSecondary.withCalmAlpha(0.25),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
