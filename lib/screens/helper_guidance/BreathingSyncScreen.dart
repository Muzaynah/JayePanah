import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class BreathingSyncScreen extends StatefulWidget {
  const BreathingSyncScreen({super.key});

  @override
  State<BreathingSyncScreen> createState() => _BreathingSyncScreenState();
}

class _BreathingSyncScreenState extends State<BreathingSyncScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathScale;
  String _phase = 'inhale';

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _breathScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _breathController.addListener(_updatePhase);
  }

  void _updatePhase() {
    final progress = _breathController.value;
    String newPhase = 'inhale';
    if (progress < 0.4) {
      newPhase = 'inhale';
    } else if (progress < 0.5) {
      newPhase = 'hold';
    } else if (progress < 0.9) {
      newPhase = 'exhale';
    } else {
      newPhase = 'hold';
    }
    if (_phase != newPhase) {
      setState(() => _phase = newPhase);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? DesignSystem.darkBase : DesignSystem.lightBase,
        body: SceneBackground(
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Breathing Sync',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? DesignSystem.darkTextPrimary
                              : DesignSystem.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sync your breathing with theirs to calm them',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? DesignSystem.darkTextSecondary
                              : DesignSystem.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Animated breathing orb
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _breathScale,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _breathScale.value,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      DesignSystem.accentLavender.withValues(alpha: 0.8),
                                      DesignSystem.accentLavender.withValues(alpha: 0.3),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.7, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: DesignSystem.accentLavender.withValues(alpha: 0.4),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSystem.spaceLG,
                            vertical: DesignSystem.spaceMD,
                          ),
                          decoration: BoxDecoration(
                            color: DesignSystem.accentLavender.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _phase.toUpperCase(),
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: DesignSystem.accentLavender,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tips card
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: GlassCard(
                    tintColor: DesignSystem.glassLavender,
                    tintOpacity: 0.20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Tips',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? DesignSystem.darkTextPrimary
                                : DesignSystem.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '• Breathe slowly and deliberately\n• Maintain eye contact if comfortable\n• Continue for 2-3 minutes\n• Your calm helps them calm',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? DesignSystem.darkTextSecondary
                                : DesignSystem.lightTextSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final interventionState = Provider.of<InterventionStateProvider>(
                            context,
                            listen: false,
                          );
                          interventionState.setHelperScreen(
                            HelperGuidanceScreen.environmental,
                          );
                        },
                        child: const Text('Continue'),
                      ),
                      const SizedBox(height: DesignSystem.spaceMD),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Home'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
