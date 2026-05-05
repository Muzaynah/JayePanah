import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../routes/app_routes.dart';
import '../theme/calm_palette.dart';

/// High-contrast text on the splash gradient (not theme [ColorScheme.onSurface]).
Color _splashHeroTextBase(Brightness brightness) =>
    brightness == Brightness.dark ? const Color(0xFFE8EEF4) : const Color(0xFF152028);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _opacityAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _runSplashSequence());
  }

  /// Show branding, then leave after a short hold (loading-style; no tap).
  Future<void> _runSplashSequence() async {
    if (!mounted) return;
    final reduceMotion = context.read<AppSettingsProvider>().reduceMotion;
    final prefsFuture = SharedPreferences.getInstance();

    if (reduceMotion) {
      _fadeController.duration = Duration.zero;
      _fadeController.value = 1.0;
    } else {
      _fadeController.forward();
    }

    final minDisplay = reduceMotion ? const Duration(milliseconds: 1000) : const Duration(milliseconds: 2000);
    final done = await Future.wait<dynamic>([
      prefsFuture,
      Future<void>.delayed(minDisplay),
    ]);
    final prefs = done[0] as SharedPreferences;
    if (!mounted) return;
    await _navigateToNext(prefs);
  }

  Future<void> _navigateToNext(SharedPreferences prefs) async {
    if (!mounted || _navigated) return;
    _navigated = true;

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
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = context.watch<AppSettingsProvider>().reduceMotion;
    final languageProvider = context.watch<LanguageProvider>();
    final brightness = Theme.of(context).brightness;
    final heroText = _splashHeroTextBase(brightness);
    final ringColor =
        brightness == Brightness.dark ? CalmPalette.darkCalmBlue : CalmPalette.lightCalmBlue;
    final taglineDir = languageProvider.isRTL ? TextDirection.rtl : TextDirection.ltr;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: CalmPalette.homeGradient(context),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Opacity(
                  opacity: reduceMotion ? 1.0 : _opacityAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          languageProvider.tLang('app.name', 'ur'),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4,
                            color: heroText,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageProvider.tLang('app.name', 'en'),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.8,
                            color: heroText,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          languageProvider.t('app.tagline'),
                          textAlign: TextAlign.center,
                          textDirection: taglineDir,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: heroText.withCalmAlpha(0.76),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ringColor.withCalmAlpha(0.12),
                            border: Border.all(
                              color: ringColor.withCalmAlpha(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.spa_rounded,
                            size: 34,
                            color: ringColor.withCalmAlpha(0.88),
                          ),
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
