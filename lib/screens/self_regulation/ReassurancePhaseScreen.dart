import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

const _reassuranceMessages = [
  'self.reassurance.1',
  'self.reassurance.2',
  'self.reassurance.3',
];

class ReassurancePhaseScreen extends StatelessWidget {
  final int currentStep;

  const ReassurancePhaseScreen({super.key, required this.currentStep});

  void _handleNext(BuildContext context) {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    if (currentStep < _reassuranceMessages.length - 1) {
      interventionState.setReassuranceStep(currentStep + 1);
    } else {
      interventionState.setSelfRegulationPhase(SelfRegulationPhase.recovery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final message = _reassuranceMessages[currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFF4A9B99),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                children: List.generate(
                  _reassuranceMessages.length,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsetsDirectional.only(
                        end: index < _reassuranceMessages.length - 1 ? 4 : 0,
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
                  child: Text(
                    languageProvider.t(message),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                    currentStep < _reassuranceMessages.length - 1
                        ? languageProvider.t('self.reassurance.next')
                        : languageProvider.t('self.reassurance.continue'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
