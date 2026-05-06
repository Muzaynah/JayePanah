import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

const _groundingSteps = [
  {'key': 'see', 'icon': Icons.remove_red_eye_rounded, 'instruction': 'self.grounding.see'},
  {'key': 'touch', 'icon': Icons.touch_app_rounded, 'instruction': 'self.grounding.touch'},
  {'key': 'hear', 'icon': Icons.hearing_rounded, 'instruction': 'self.grounding.hear'},
  {'key': 'smell', 'icon': Icons.spa_rounded, 'instruction': 'self.grounding.smell'},
  {'key': 'taste', 'icon': Icons.restaurant_rounded, 'instruction': 'self.grounding.taste'},
];

class GroundingPhaseScreen extends StatefulWidget {
  final int currentStep;

  const GroundingPhaseScreen({super.key, required this.currentStep});

  @override
  State<GroundingPhaseScreen> createState() => _GroundingPhaseScreenState();
}

class _GroundingPhaseScreenState extends State<GroundingPhaseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: DesignSystem.durationNormal,
      vsync: this,
    );
    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOut),
    );
    _iconController.forward();
  }

  @override
  void didUpdateWidget(GroundingPhaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _iconController.reset();
      _iconController.forward();
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _handleNext(BuildContext context) {
    final interventionState = context.read<InterventionStateProvider>();
    if (widget.currentStep < _groundingSteps.length - 1) {
      interventionState.setGroundingStep(widget.currentStep + 1);
    } else {
      interventionState.setSelfRegulationPhase(SelfRegulationPhase.reassurance);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final step = _groundingSteps[widget.currentStep];
    final stepNum = widget.currentStep + 1;

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
      appBar: AppBar(
        title: Text(lang.t('self.grounding.continue')),
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
                      _groundingSteps.length,
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
                // Animated icon
                Center(
                  child: AnimatedBuilder(
                    animation: _iconScale,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconScale.value,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: DesignSystem.glassLavender
                                .withValues(alpha: 0.25),
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            size: 70,
                            color: DesignSystem.accentLavender,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Instruction text
                GlassCard(
                  tintColor: DesignSystem.glassLavender,
                  tintOpacity: 0.20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        lang.t(step['instruction'] as String),
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: DesignSystem.textPrimary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignSystem.spaceMD),
                      Text(
                        'Step $stepNum of ${_groundingSteps.length}',
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
                const SizedBox(height: DesignSystem.spaceXL),
                // Next button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _handleNext(context),
                    child: Text(
                      widget.currentStep < _groundingSteps.length - 1
                          ? lang.t('self.grounding.next')
                          : lang.t('self.grounding.continue'),
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
