import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/InterventionStateProvider.dart';
import '../components/EmergencyModal.dart';
import 'AnchorModeScreen.dart';
import 'self_regulation/StabilizationPhaseScreen.dart';
import 'self_regulation/BreathingPhaseScreen.dart';
import 'self_regulation/GroundingPhaseScreen.dart';
import 'self_regulation/ReassurancePhaseScreen.dart';
import 'self_regulation/RecoveryPhaseScreen.dart';

class SelfRegulationScreen extends StatefulWidget {
  const SelfRegulationScreen({super.key});

  @override
  State<SelfRegulationScreen> createState() => _SelfRegulationScreenState();
}

class _SelfRegulationScreenState extends State<SelfRegulationScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);

    // Handle severity-based initial routing
    if (interventionState.selfRegulationPhase == null && interventionState.severityLevel != null) {
      switch (interventionState.severityLevel!) {
        case SeverityLevel.mild:
          // Quick reset mode - start with breathing
          interventionState.setSelfRegulationPhase(SelfRegulationPhase.breathing);
          break;
        case SeverityLevel.moderate:
          // Full flow - start with stabilization
          interventionState.setSelfRegulationPhase(SelfRegulationPhase.stabilization);
          break;
        case SeverityLevel.severe:
          // Severe - show emergency modal first, then anchor mode
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSevereEmergencyModal();
          });
          interventionState.setSelfRegulationPhase(SelfRegulationPhase.stabilization);
          break;
      }
    } else if (interventionState.selfRegulationPhase == null) {
      interventionState.startSelfRegulation();
    }
  }

  Future<void> _showSevereEmergencyModal() async {
    // Show emergency modal for severe cases
    await EmergencyModal.show(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
      interventionState.saveState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterventionStateProvider>(
      builder: (context, interventionState, child) {
        final phase = interventionState.selfRegulationPhase ?? SelfRegulationPhase.stabilization;
        final severity = interventionState.severityLevel;

        // Show anchor mode for severe cases
        if (severity == SeverityLevel.severe && phase == SelfRegulationPhase.stabilization) {
          return const AnchorModeScreen();
        }

        Widget phaseWidget;
        switch (phase) {
          case SelfRegulationPhase.stabilization:
            phaseWidget = const StabilizationPhaseScreen();
            break;
          case SelfRegulationPhase.breathing:
            phaseWidget = const BreathingPhaseScreen();
            break;
          case SelfRegulationPhase.grounding:
            phaseWidget = GroundingPhaseScreen(currentStep: interventionState.groundingStep);
            break;
          case SelfRegulationPhase.reassurance:
            phaseWidget = ReassurancePhaseScreen(currentStep: interventionState.reassuranceStep);
            break;
          case SelfRegulationPhase.recovery:
            phaseWidget = const RecoveryPhaseScreen();
            break;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: phaseWidget,
        );
      },
    );
  }
}
