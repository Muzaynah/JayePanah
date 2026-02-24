import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

class EnvironmentalScreen extends StatelessWidget {
  const EnvironmentalScreen({super.key});

  void _handleNext(BuildContext context) {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setHelperScreen(HelperGuidanceScreen.assessment);
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
                        color: index <= 3 ? Colors.white : Colors.white.withOpacity(0.3),
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
                        languageProvider.t('helper.environmental.title'),
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 48),
                      _GuidanceItem(
                        icon: Icons.volume_off,
                        text: languageProvider.t('helper.environmental.noise'),
                        isRTL: isRTL,
                      ),
                      const SizedBox(height: 16),
                      _GuidanceItem(
                        icon: Icons.people_outline,
                        text: languageProvider.t('helper.environmental.crowd'),
                        isRTL: isRTL,
                      ),
                      const SizedBox(height: 16),
                      _GuidanceItem(
                        icon: Icons.chair,
                        text: languageProvider.t('helper.environmental.sit'),
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
                  onPressed: () => _handleNext(context),
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

class _GuidanceItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isRTL;

  const _GuidanceItem({
    required this.icon,
    required this.text,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
        ),
      ],
    );
  }
}
