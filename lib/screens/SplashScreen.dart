import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/LanguageProvider.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('jayepanah_onboarding_complete') ?? false;

    if (!mounted) return;
    if (hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          languageProvider.t('app.name'),
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.2,
                          ),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          languageProvider.t('app.tagline'),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        const SizedBox(height: 48),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.5, end: 1.0),
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.scale(
                                scale: 1.0 + (value - 0.5) * 0.4,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          onEnd: () {
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}