import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../routes/app_routes.dart';
import '../../components/EmergencyModal.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  String? _selectedResponse;
  bool _showEmergency = false;

  void _handleResponse(String response) {
    setState(() {
      _selectedResponse = response;
    });
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setRecoveryResponse(response);
    _handleNext(response);
  }

  void _handleNext(String response) {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    if (response == 'better') {
      interventionState.resetIntervention();
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    } else if (response == 'same') {
      interventionState.setSelfRegulationPhase(SelfRegulationPhase.grounding);
      interventionState.setGroundingStep(0);
    } else if (response == 'worse') {
      setState(() {
        _showEmergency = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFF4A9B99),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageProvider.t('self.recovery.question'),
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                          const SizedBox(height: 48),
                          _ResponseButton(
                            label: languageProvider.t('self.recovery.better'),
                            isSelected: _selectedResponse == 'better',
                            onTap: () => _handleResponse('better'),
                            color: const Color(0xFF8FAA85),
                          ),
                          const SizedBox(height: 16),
                          _ResponseButton(
                            label: languageProvider.t('self.recovery.same'),
                            isSelected: _selectedResponse == 'same',
                            onTap: () => _handleResponse('same'),
                            color: const Color(0xFFD6A545),
                          ),
                          const SizedBox(height: 16),
                          _ResponseButton(
                            label: languageProvider.t('self.recovery.worse'),
                            isSelected: _selectedResponse == 'worse',
                            onTap: () => _handleResponse('worse'),
                            color: const Color(0xFFD64545),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
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
                      const Icon(Icons.warning_rounded, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        languageProvider.t('home.emergency'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
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

class _ResponseButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _ResponseButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
