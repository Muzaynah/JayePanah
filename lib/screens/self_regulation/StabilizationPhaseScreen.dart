import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class StabilizationPhaseScreen extends StatefulWidget {
  const StabilizationPhaseScreen({super.key});

  @override
  State<StabilizationPhaseScreen> createState() =>
      _StabilizationPhaseScreenState();
}

class _StabilizationPhaseScreenState extends State<StabilizationPhaseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringController;
  late Animation<double> _ringScale;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _ringScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  void _handleStart() {
    context
        .read<InterventionStateProvider>()
        .setSelfRegulationPhase(SelfRegulationPhase.breathing);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
      appBar: AppBar(
        title: Text(lang.t('self.stabilization.title')),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated rings
                AnimatedBuilder(
                  animation: _ringScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _ringScale.value,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: DesignSystem.glassSage
                                    .withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                          ),
                          // Middle ring
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: DesignSystem.glassLavender
                                    .withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                          ),
                          // Center circle with icon
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DesignSystem.glassSage
                                  .withValues(alpha: 0.3),
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 60,
                              color: DesignSystem.accentSage,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: Text(
                    lang.t('self.stabilization.subtitle'),
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: DesignSystem.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXXL),
                // Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: ElevatedButton(
                    onPressed: _handleStart,
                    child: Text(lang.t('self.stabilization.start')),
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
