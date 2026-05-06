import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../providers/InterventionStateProvider.dart';
import '../components/EmergencyModal.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AnchorModeScreen extends StatefulWidget {
  const AnchorModeScreen({super.key});

  @override
  State<AnchorModeScreen> createState() => _AnchorModeScreenState();
}

class _AnchorModeScreenState extends State<AnchorModeScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _breathScale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
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
                // Breathing animation
                AnimatedBuilder(
                  animation: _breathScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _breathScale.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignSystem.glassSage
                              .withValues(alpha: 0.3),
                          border: Border.all(
                            color: DesignSystem.accentSage,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: DesignSystem.glassSage
                                  .withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 80,
                          color: DesignSystem.accentSage,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                // Safety message
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: GlassCard(
                    tintColor: DesignSystem.glassSage,
                    tintOpacity: 0.22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          lang.t('anchor.safe'),
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: DesignSystem.textPrimary,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignSystem.spaceMD),
                        Text(
                          'You are experiencing severe symptoms. Help is available.',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: DesignSystem.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => EmergencyModal.show(context),
                        icon: const Icon(Icons.phone_in_talk_rounded),
                        label: Text(lang.t('home.emergency')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4635F)
                              .withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spaceMD),
                      OutlinedButton(
                        onPressed: () {
                          context
                              .read<InterventionStateProvider>()
                              .setSelfRegulationPhase(
                                SelfRegulationPhase.stabilization,
                              );
                        },
                        child: Text(lang.t('anchor.continue_breathing')),
                      ),
                    ],
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
