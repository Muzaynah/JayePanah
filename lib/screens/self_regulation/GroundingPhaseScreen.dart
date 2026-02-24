import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

const _groundingSteps = [
  {'key': 'see', 'icon': Icons.remove_red_eye, 'instruction': 'self.grounding.see'},
  {'key': 'touch', 'icon': Icons.touch_app, 'instruction': 'self.grounding.touch'},
  {'key': 'hear', 'icon': Icons.hearing, 'instruction': 'self.grounding.hear'},
  {'key': 'smell', 'icon': Icons.air, 'instruction': 'self.grounding.smell'},
  {'key': 'taste', 'icon': Icons.restaurant, 'instruction': 'self.grounding.taste'},
];

class GroundingPhaseScreen extends StatelessWidget {
  final int currentStep;

  const GroundingPhaseScreen({super.key, required this.currentStep});

  void _handleNext(BuildContext context) {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    if (currentStep < _groundingSteps.length - 1) {
      interventionState.setGroundingStep(currentStep + 1);
    } else {
      interventionState.setSelfRegulationPhase(SelfRegulationPhase.reassurance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final step = _groundingSteps[currentStep];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF4A9B99),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Row(
                  children: List.generate(
                    _groundingSteps.length,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsetsDirectional.only(
                          end: index < _groundingSteps.length - 1 ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: index <= currentStep
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          languageProvider.t(step['instruction'] as String),
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () => _handleNext(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A9B99),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      currentStep < _groundingSteps.length - 1
                          ? languageProvider.t('self.grounding.next')
                          : languageProvider.t('self.grounding.continue'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
  }
}
