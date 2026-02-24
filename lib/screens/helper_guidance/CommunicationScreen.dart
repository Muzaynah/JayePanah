import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key});

  void _handleNext(BuildContext context) {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setHelperScreen(HelperGuidanceScreen.breathingSync);
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
                        color: index <= 1 ? Colors.white : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        languageProvider.t('helper.communication.title'),
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white, size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  languageProvider.t('helper.communication.say'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              languageProvider.t('helper.communication.say.text'),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                const Icon(Icons.cancel, color: Colors.white, size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  languageProvider.t('helper.communication.dont'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              languageProvider.t('helper.communication.dont.text'),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                const Icon(Icons.volume_down, color: Colors.white, size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  languageProvider.t('helper.communication.tone'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              languageProvider.t('helper.communication.tone.text'),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                height: 1.6,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
