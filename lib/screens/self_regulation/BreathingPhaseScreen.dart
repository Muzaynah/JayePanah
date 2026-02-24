import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';
import '../../providers/LanguageProvider.dart';
import '../../providers/InterventionStateProvider.dart';

class BreathingPhaseScreen extends StatefulWidget {
  const BreathingPhaseScreen({super.key});

  @override
  State<BreathingPhaseScreen> createState() => _BreathingPhaseScreenState();
}

class _BreathingPhaseScreenState extends State<BreathingPhaseScreen> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _instructionController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _pulseAnimation;
  bool _isPaused = false;
  FlutterTts? _flutterTts;
  bool _audioEnabled = true;
  bool _hapticEnabled = true;
  int _breathCount = 0;
  String _currentInstruction = '';
  bool _isInhaling = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    
    _instructionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(begin: 0.4, end: 1.6).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
    
    _initTts();
    _breathingController.addStatusListener(_onBreathingStatusChanged);
    _updateInstruction();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _audioEnabled = prefs.getBool('jayepanah_audio') ?? true;
      _hapticEnabled = prefs.getBool('jayepanah_haptic') ?? true;
    });
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    await _flutterTts?.setLanguage(languageProvider.currentLanguage);
    await _flutterTts?.setSpeechRate(0.4);
    await _flutterTts?.setVolume(0.6);
    await _flutterTts?.setPitch(1.0);
  }

  void _onBreathingStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.forward && _breathingAnimation.value > 1.0) {
      if (!_isInhaling) {
        setState(() {
          _isInhaling = true;
        });
        _updateInstruction();
        _instructionController.forward(from: 0.0);
      }
      if (_audioEnabled && _flutterTts != null && _breathingAnimation.value > 1.2) {
        final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
        _flutterTts?.speak(languageProvider.t('self.breathing.inhale'));
      }
      if (_hapticEnabled && _breathingAnimation.value > 1.2) {
        Vibration.vibrate(duration: 100);
      }
    } else if (status == AnimationStatus.reverse && _breathingAnimation.value < 1.0) {
      if (_isInhaling) {
        setState(() {
          _isInhaling = false;
        });
        _updateInstruction();
        _instructionController.forward(from: 0.0);
      }
      if (_audioEnabled && _flutterTts != null && _breathingAnimation.value < 0.6) {
        final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
        _flutterTts?.speak(languageProvider.t('self.breathing.exhale'));
      }
      if (_hapticEnabled && _breathingAnimation.value < 0.6) {
        Vibration.vibrate(duration: 100);
      }
      if (_breathingAnimation.value < 0.5) {
        setState(() {
          _breathCount++;
        });
      }
    }
  }

  void _updateInstruction() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    setState(() {
      _currentInstruction = _isInhaling
          ? languageProvider.t('self.breathing.inhale')
          : languageProvider.t('self.breathing.exhale');
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setBreathingPaused(_isPaused);
    if (_isPaused) {
      _breathingController.stop();
    } else {
      _breathingController.repeat(reverse: true);
    }
  }

  void _handleContinue() {
    final interventionState = Provider.of<InterventionStateProvider>(context, listen: false);
    interventionState.setSelfRegulationPhase(SelfRegulationPhase.grounding);
  }

  @override
  void dispose() {
    _breathingController.removeStatusListener(_onBreathingStatusChanged);
    _breathingController.dispose();
    _instructionController.dispose();
    _flutterTts?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFF4A9B99),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _instructionController,
                    child: Text(
                      _currentInstruction,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                  const SizedBox(height: 60),
                  AnimatedBuilder(
                    animation: _breathingAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: _breathingAnimation.value,
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.25),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: _breathingAnimation.value * 0.7,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.35),
                                    Colors.white.withOpacity(0.15),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: _breathingAnimation.value * 0.45,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                          if (_isInhaling)
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _pulseAnimation.value,
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          else
                            const Icon(
                              Icons.arrow_downward_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.air_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${languageProvider.t('self.breathing.count')}: $_breathCount',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _togglePause,
                      icon: Icon(
                        _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      iconSize: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4A9B99),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        languageProvider.t('self.breathing.continue'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
