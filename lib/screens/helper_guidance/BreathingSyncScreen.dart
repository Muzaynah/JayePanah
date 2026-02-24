import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

class BreathingSyncScreen extends StatefulWidget {
  const BreathingSyncScreen({super.key});

  @override
  State<BreathingSyncScreen> createState() => _BreathingSyncScreenState();
}

class _BreathingSyncScreenState extends State<BreathingSyncScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    _breathingAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setHelperScreen(HelperGuidanceScreen.environmental);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFF7FA99E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                children: List.generate(
                  6,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsetsDirectional.only(
                        end: index < 5 ? 4 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: index <= 2 ? Colors.white : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        languageProvider.t('helper.breathing.title'),
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 48),
                      AnimatedBuilder(
                        animation: _breathingAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _breathingAnimation.value,
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7FA99E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    languageProvider.t('helper.next'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
