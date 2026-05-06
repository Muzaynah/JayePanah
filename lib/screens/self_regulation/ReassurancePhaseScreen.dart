import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

const _reassuranceMessages = [
  'self.reassurance.1',
  'self.reassurance.2',
  'self.reassurance.3',
  'self.reassurance.4',
  'self.reassurance.5',
  'self.reassurance.6',
];

class ReassurancePhaseScreen extends StatefulWidget {
  final int currentStep;

  const ReassurancePhaseScreen({super.key, required this.currentStep});

  @override
  State<ReassurancePhaseScreen> createState() => _ReassurancePhaseScreenState();
}

class _ReassurancePhaseScreenState extends State<ReassurancePhaseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _messageController;
  late Animation<double> _messageFade;

  @override
  void initState() {
    super.initState();
    _messageController = AnimationController(
      duration: DesignSystem.durationNormal,
      vsync: this,
    );
    _messageFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _messageController, curve: Curves.easeInOut),
    );
    _messageController.forward();
  }

  @override
  void didUpdateWidget(ReassurancePhaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _messageController.reset();
      _messageController.forward();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleNext(BuildContext context) {
    final interventionState = context.read<InterventionStateProvider>();
    if (widget.currentStep < _reassuranceMessages.length - 1) {
      interventionState.setReassuranceStep(widget.currentStep + 1);
    } else {
      interventionState.setSelfRegulationPhase(SelfRegulationPhase.recovery);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final message = _reassuranceMessages[widget.currentStep];
    final stepNum = widget.currentStep + 1;

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
      appBar: AppBar(
        title: Text(lang.t('self.reassurance.continue')),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background blobs
          BackgroundBlob(
            top: -60,
            left: -80,
            width: 280,
            height: 280,
            color: DesignSystem.glassSage,
            opacity: 0.35,
          ),
          BackgroundBlob(
            bottom: 80,
            right: -60,
            width: 240,
            height: 240,
            color: DesignSystem.glassLavender,
            opacity: 0.30,
          ),
          // Main content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Step indicator dots
                Padding(
                  padding: const EdgeInsets.only(bottom: DesignSystem.spaceXL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _reassuranceMessages.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignSystem.spaceSM,
                        ),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == widget.currentStep
                                ? DesignSystem.accentSage
                                : DesignSystem.textSecondary.withValues(
                                    alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Reassurance message with fade animation
                FadeTransition(
                  opacity: _messageFade,
                  child: GlassCard(
                    tintColor: DesignSystem.glassPeach,
                    tintOpacity: 0.18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          lang.t(message),
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: DesignSystem.textPrimary,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignSystem.spaceMD),
                        Text(
                          'Message ${stepNum} of ${_reassuranceMessages.length}',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: DesignSystem.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Next button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _handleNext(context),
                    child: Text(
                      widget.currentStep < _reassuranceMessages.length - 1
                          ? lang.t('self.reassurance.next')
                          : lang.t('self.reassurance.continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
