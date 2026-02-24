import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final Map<String, bool> _checks = {
    'speak': false,
    'breathe': false,
    'reducing': false,
  };

  void _handleNext() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setHelperScreen(HelperGuidanceScreen.escalation);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFF7FA99E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                children: List.generate(
                  6,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsetsDirectional.only(
                        end: index < 5 ? 4 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: index <= 4 ? Colors.white : Colors.white.withOpacity(0.3),
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
                      Text(
                        languageProvider.t('helper.assessment.title'),
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 48),
                      _CheckItem(
                        label: languageProvider.t('helper.assessment.speak'),
                        checked: _checks['speak']!,
                        onChanged: (value) {
                          setState(() {
                            _checks['speak'] = value;
                          });
                        },
                        isRTL: isRTL,
                      ),
                      const SizedBox(height: 16),
                      _CheckItem(
                        label: languageProvider.t('helper.assessment.breathe'),
                        checked: _checks['breathe']!,
                        onChanged: (value) {
                          setState(() {
                            _checks['breathe'] = value;
                          });
                        },
                        isRTL: isRTL,
                      ),
                      const SizedBox(height: 16),
                      _CheckItem(
                        label: languageProvider.t('helper.assessment.reducing'),
                        checked: _checks['reducing']!,
                        onChanged: (value) {
                          setState(() {
                            _checks['reducing'] = value;
                          });
                        },
                        isRTL: isRTL,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7FA99E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    languageProvider.t('helper.next'),
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

class _CheckItem extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool isRTL;

  const _CheckItem({
    required this.label,
    required this.checked,
    required this.onChanged,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: checked ? Colors.white : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              checked ? Icons.check_circle : Icons.circle_outlined,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
