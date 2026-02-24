import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

class StabilizationPhaseScreen extends StatefulWidget {
  const StabilizationPhaseScreen({super.key});

  @override
  State<StabilizationPhaseScreen> createState() => _StabilizationPhaseScreenState();
}

class _StabilizationPhaseScreenState extends State<StabilizationPhaseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  void _handleStart() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setSelfRegulationPhase(SelfRegulationPhase.breathing);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A9B99), Color(0xFF6B9A9E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _breathingAnimation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: Center(
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  languageProvider.t('self.stabilization.title'),
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: _handleStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A9B99),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      languageProvider.t('self.stabilization.start'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
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
