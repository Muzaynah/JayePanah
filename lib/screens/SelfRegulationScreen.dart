import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/InterventionStateProvider.dart';
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
    if (interventionState.selfRegulationPhase == null) {
      interventionState.startSelfRegulation();
    }
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

        switch (phase) {
          case SelfRegulationPhase.stabilization:
            return const StabilizationPhaseScreen();
          case SelfRegulationPhase.breathing:
            return const BreathingPhaseScreen();
          case SelfRegulationPhase.grounding:
            return GroundingPhaseScreen(currentStep: interventionState.groundingStep);
          case SelfRegulationPhase.reassurance:
            return ReassurancePhaseScreen(currentStep: interventionState.reassuranceStep);
          case SelfRegulationPhase.recovery:
            return const RecoveryPhaseScreen();
        }
      },
    );
  }
}
