import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/InterventionStateProvider.dart' show InterventionStateProvider, HelperGuidanceScreen;
import 'helper_guidance/ImmediateResponseScreen.dart';
import 'helper_guidance/CommunicationScreen.dart';
import 'helper_guidance/BreathingSyncScreen.dart';
import 'helper_guidance/EnvironmentalScreen.dart';
import 'helper_guidance/AssessmentScreen.dart';
import 'helper_guidance/EscalationScreen.dart';

class HelperGuidanceScreenWidget extends StatefulWidget {
  const HelperGuidanceScreenWidget({super.key});

  @override
  State<HelperGuidanceScreenWidget> createState() => _HelperGuidanceScreenWidgetState();
}

class _HelperGuidanceScreenWidgetState extends State<HelperGuidanceScreenWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    if (interventionState.helperScreen == null) {
      interventionState.setHelperScreen(HelperGuidanceScreen.immediateResponse);
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
        final screen = interventionState.helperScreen ?? HelperGuidanceScreen.immediateResponse;

        switch (screen) {
          case HelperGuidanceScreen.immediateResponse:
            return const ImmediateResponseScreen();
          case HelperGuidanceScreen.communication:
            return const CommunicationScreen();
          case HelperGuidanceScreen.breathingSync:
            return const BreathingSyncScreen();
          case HelperGuidanceScreen.environmental:
            return const EnvironmentalScreen();
          case HelperGuidanceScreen.assessment:
            return const AssessmentScreen();
          case HelperGuidanceScreen.escalation:
            return const EscalationScreen();
        }
      },
    );
  }
}
