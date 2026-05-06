import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

const _steps = [
  {
    'title': 'helper.communication.say',
    'body': 'helper.communication.say.text',
    'icon': Icons.check_circle_outline_rounded,
    'color': Color(0xFF6B9B6B),
  },
  {
    'title': 'helper.communication.dont',
    'body': 'helper.communication.dont.text',
    'icon': Icons.block_rounded,
    'color': Color(0xFFD4635F),
  },
  {
    'title': 'helper.communication.tone',
    'body': 'helper.communication.tone.text',
    'icon': Icons.record_voice_over_rounded,
    'color': Color(0xFF7E74B8),
  },
];

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  late AnimationController _cardController;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _handleNext(BuildContext context) {
    if (_step < _steps.length - 1) {
      _cardController.reset();
      setState(() => _step++);
      _cardController.forward();
    } else {
      final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
      interventionState.setHelperScreen(HelperGuidanceScreen.breathingSync);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final step = _steps[_step];
    final stepColor = step['color'] as Color;

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
                        'Communication Guide',
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
                      // Progress dots
                      Row(
                        children: List.generate(
                          _steps.length,
                          (index) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: index == _step
                                      ? stepColor
                                      : isDark
                                          ? DesignSystem.darkTextSecondary.withValues(alpha: 0.3)
                                          : DesignSystem.textSecondary.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
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
                        // Icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: stepColor.withValues(alpha: 0.15),
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            size: 50,
                            color: stepColor,
                          ),
                        ),
                        const SizedBox(height: DesignSystem.spaceXL),
                        // Content card with animation
                        SlideTransition(
                          position: _cardSlide,
                          child: GlassCard(
                            tintColor: stepColor,
                            tintOpacity: 0.18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  lang.t(step['title'] as String),
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 22,
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
                                  lang.t(step['body'] as String),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: stepColor,
                        ),
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
