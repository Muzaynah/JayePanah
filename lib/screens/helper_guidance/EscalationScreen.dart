import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../components/EmergencyModal.dart';
import '../../routes/app_routes.dart';

class EscalationScreen extends StatefulWidget {
  const EscalationScreen({super.key});

  @override
  State<EscalationScreen> createState() => _EscalationScreenState();
}

class _EscalationScreenState extends State<EscalationScreen> {
  bool _showEmergency = false;

  void _handleFinish() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.resetIntervention();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFF7FA99E),
      body: Stack(
        children: [
          SafeArea(
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
                            color: Colors.white,
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
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.warning_amber,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            languageProvider.t('helper.escalation.title'),
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  languageProvider.t('helper.escalation.redflags'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  languageProvider.t('helper.escalation.redflags.text'),
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
                                Text(
                                  languageProvider.t('helper.escalation.justification'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  languageProvider.t('helper.escalation.justification.text'),
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
                      onPressed: () {
                        setState(() {
                          _showEmergency = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD64545),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            languageProvider.t('helper.escalation.emergency'),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: OutlinedButton(
                      onPressed: _handleFinish,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        languageProvider.t('helper.escalation.finish'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showEmergency)
            EmergencyModal(
              isOpen: _showEmergency,
              onClose: () {
                setState(() {
                  _showEmergency = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
