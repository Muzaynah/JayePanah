import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

const _steps = [
  {
    'icon': Icons.stay_current_portrait_rounded,
    'key': 'helper.immediate.stay',
    'description': 'Stay calm and grounded. Your presence matters most.',
  },
  {
    'icon': Icons.people_rounded,
    'key': 'helper.immediate.with',
    'description': 'Keep them company. Let them know they\'re not alone.',
  },
  {
    'icon': Icons.volume_down_rounded,
    'key': 'helper.immediate.lower',
    'description': 'Reduce stimulation. Lower lights, sounds, and temperature.',
  },
];

class ImmediateResponseScreen extends StatefulWidget {
  const ImmediateResponseScreen({super.key});

  @override
  State<ImmediateResponseScreen> createState() => _ImmediateResponseScreenState();
}

class _ImmediateResponseScreenState extends State<ImmediateResponseScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
    _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _handleNext(BuildContext context) {
    if (_step < _steps.length - 1) {
      _iconController.reset();
      setState(() => _step++);
      _iconController.forward();
    } else {
      final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
      interventionState.setHelperScreen(HelperGuidanceScreen.communication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final item = _steps[_step];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? DesignSystem.darkBase : DesignSystem.lightBase,
        body: SceneBackground(
          child: SafeArea(
            child: Column(
              children: [
                // Header with progress
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to Help',
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
                        'Step ${_step + 1} of ${_steps.length}',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? DesignSystem.darkTextSecondary
                              : DesignSystem.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_step + 1) / _steps.length,
                          minHeight: 4,
                          backgroundColor: isDark
                              ? DesignSystem.darkTextSecondary.withValues(alpha: 0.2)
                              : DesignSystem.textSecondary.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            DesignSystem.accentSage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spaceLG),
                    child: Column(
                      children: [
                        const SizedBox(height: DesignSystem.spaceXL),
                        // Animated icon
                        AnimatedBuilder(
                          animation: _iconScale,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _iconScale.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: DesignSystem.accentSage.withValues(alpha: 0.15),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 56,
                                  color: DesignSystem.accentSage,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: DesignSystem.spaceXL),
                        // Title card
                        GlassCard(
                          tintColor: DesignSystem.glassSage,
                          tintOpacity: 0.22,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                lang.t(item['key'] as String),
                                style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? DesignSystem.darkTextPrimary
                                      : DesignSystem.lightTextPrimary,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: DesignSystem.spaceMD),
                              Text(
                                item['description'] as String,
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? DesignSystem.darkTextSecondary
                                      : DesignSystem.lightTextSecondary,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: DesignSystem.spaceXL),
                      ],
                    ),
                  ),
                ),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleNext(context),
                        child: Text(
                          _step < _steps.length - 1 ? 'Next Step' : 'Continue',
                        ),
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
