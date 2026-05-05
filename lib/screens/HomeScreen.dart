import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../providers/InterventionStateProvider.dart';
import '../routes/app_routes.dart';
import '../theme/calm_palette.dart';
import '../widgets/bilingual_line.dart';
import '../components/EmergencyModal.dart';

Color _vividRoleIcon(ColorScheme cs, Brightness b, {required bool primaryAccent}) {
  final onC = primaryAccent ? cs.onPrimaryContainer : cs.onSecondaryContainer;
  final role = primaryAccent ? cs.primary : cs.secondary;
  return Color.lerp(onC, role, b == Brightness.dark ? 0.32 : 0.2)!;
}

List<BoxShadow> _glassElevation(ColorScheme cs, Brightness b) {
  return [
    BoxShadow(
      color: cs.shadow.withCalmAlpha(b == Brightness.dark ? 0.22 : 0.09),
      blurRadius: 22,
      offset: const Offset(0, 10),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: cs.primary.withCalmAlpha(0.07),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
  ];
}

/// Frosted / glass-style panel
class _GlassCardShell extends StatelessWidget {
  final double radius;
  final bool reduceMotion;
  final ColorScheme colorScheme;
  final Brightness brightness;
  final List<Color> gradientColors;
  final Color outlineColor;
  final double outlineWidth;
  final Widget child;

  const _GlassCardShell({
    required this.radius,
    required this.reduceMotion,
    required this.colorScheme,
    required this.brightness,
    required this.gradientColors,
    required this.outlineColor,
    this.outlineWidth = 1.2,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    Widget panel = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: r,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        border: Border.all(color: outlineColor, width: outlineWidth),
        boxShadow: _glassElevation(colorScheme, brightness),
      ),
      child: child,
    );

    panel = ClipRRect(
      borderRadius: r,
      child: reduceMotion
          ? panel
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: panel,
            ),
    );
    return panel;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool? _lastReduceMotionSynced;
  String _emergencyNumber = '1122';
  late AnimationController _ambientController;
  late AnimationController _cardController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadEmergencyNumber();
    _ambientController = AnimationController(
      duration: const Duration(seconds: 22),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );
    _cardController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncAmbientAnimation());
  }

  Future<void> _loadEmergencyNumber() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _emergencyNumber = prefs.getString('jayepanah_emergency_number') ?? '1122';
    });
  }

  void _syncAmbientAnimation() {
    if (!mounted) return;
    final reduceMotion = context.read<AppSettingsProvider>().reduceMotion;
    if (reduceMotion) {
      _ambientController.stop();
      _ambientController.value = 0.5;
    } else {
      _ambientController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _openSelfRegulation() async {
    final intervention = context.read<InterventionStateProvider>();
    final lang = context.read<LanguageProvider>();

    if (intervention.selfRegulationPhase != null) {
      final choice = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          final dark = Theme.of(ctx).brightness == Brightness.dark;
          final panel = dark ? CalmPalette.darkCrisisBg : const Color(0xFFEEF2F6);
          final onPanel = dark ? const Color(0xFFE4E9EE) : const Color(0xFF1A2832);
          final muted = dark ? const Color(0xFFA8B4BF) : const Color(0xFF4A5A66);
          final accent = dark ? CalmPalette.darkCalmBlue : CalmPalette.lightCalmBlue;
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(ctx).bottom),
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: accent.withCalmAlpha(0.22)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BilingualLine(
                      translationKey: 'home.resume.title',
                      textAlign: TextAlign.start,
                      primaryStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: onPanel,
                      ),
                      secondaryStyle: TextStyle(fontSize: 16, color: muted, height: 1.45),
                    ),
                    const SizedBox(height: 14),
                    BilingualLine(
                      translationKey: 'home.resume.body',
                      textAlign: TextAlign.start,
                      primaryStyle: TextStyle(fontSize: 17, color: muted, height: 1.5),
                      secondaryStyle: TextStyle(fontSize: 16, color: muted.withCalmAlpha(0.9), height: 1.45),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx, 'continue'),
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(lang.t('home.resume.continue')),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, 'restart'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: onPanel,
                          side: BorderSide(color: muted.withCalmAlpha(0.35)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(lang.t('home.resume.restart')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      if (!mounted || choice == null) return;
      if (choice == 'restart') {
        await intervention.resetIntervention();
        await intervention.startSelfRegulation();
      }
    }
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.selfRegulation);
  }

  Future<void> _openHelperGuidance() async {
    final intervention = context.read<InterventionStateProvider>();
    final lang = context.read<LanguageProvider>();

    if (intervention.shouldOfferResumeHelper) {
      final choice = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          final dark = Theme.of(ctx).brightness == Brightness.dark;
          final panel = dark ? CalmPalette.darkCrisisBg : const Color(0xFFEEF2F6);
          final onPanel = dark ? const Color(0xFFE4E9EE) : const Color(0xFF1A2832);
          final muted = dark ? const Color(0xFFA8B4BF) : const Color(0xFF4A5A66);
          final accent = dark ? CalmPalette.darkCalmBlue : CalmPalette.lightCalmBlue;
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(ctx).bottom),
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: accent.withCalmAlpha(0.22)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BilingualLine(
                      translationKey: 'home.resume.helper.title',
                      textAlign: TextAlign.start,
                      primaryStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: onPanel,
                      ),
                      secondaryStyle: TextStyle(fontSize: 16, color: muted, height: 1.45),
                    ),
                    const SizedBox(height: 14),
                    BilingualLine(
                      translationKey: 'home.resume.helper.body',
                      textAlign: TextAlign.start,
                      primaryStyle: TextStyle(fontSize: 17, color: muted, height: 1.5),
                      secondaryStyle: TextStyle(fontSize: 16, color: muted.withCalmAlpha(0.9), height: 1.45),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx, 'continue'),
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(lang.t('home.resume.continue')),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, 'restart'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: onPanel,
                          side: BorderSide(color: muted.withCalmAlpha(0.35)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(lang.t('home.resume.restart')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      if (!mounted || choice == null) return;
      if (choice == 'restart') {
        await intervention.resetHelperGuidanceOnly();
      }
    }
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.helperGuidance);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final reduceMotion = context.watch<AppSettingsProvider>().reduceMotion;
    final isRTL = languageProvider.isRTL;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final crisis = CalmPalette.crisis(context);
    final accent = crisis.accent;

    if (_lastReduceMotionSynced != reduceMotion) {
      _lastReduceMotionSynced = reduceMotion;
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncAmbientAnimation());
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: CalmPalette.homeGradient(context)),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withCalmAlpha(0.07),
                    Colors.transparent,
                    cs.secondary.withCalmAlpha(0.06),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _ambientController,
            builder: (context, child) {
              final v = reduceMotion ? 0.5 : _ambientController.value;
              return IgnorePointer(
                child: Stack(
                  children: [
                    Positioned(
                      top: -100,
                      right: -60,
                      child: Opacity(
                        opacity: 0.06 + (v * 0.05),
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.15, -0.2),
                              radius: 1.05,
                              colors: [
                                Color.lerp(accent, cs.primary, 0.2)!.withCalmAlpha(0.55),
                                accent.withCalmAlpha(0.28),
                                cs.secondary.withCalmAlpha(0.12),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.38, 0.72, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -120,
                      left: -40,
                      child: Opacity(
                        opacity: 0.05 + ((1 - v) * 0.04),
                        child: Container(
                          width: 340,
                          height: 340,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(0.2, 0.35),
                              radius: 1.0,
                              colors: [
                                Color.lerp(crisis.secondary, cs.tertiary, 0.25)!
                                    .withCalmAlpha(0.5),
                                crisis.secondary.withCalmAlpha(0.22),
                                cs.primary.withCalmAlpha(0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.42, 0.78, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 16, 4),
                  child: Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BilingualLine(
                          translationKey: 'home.title',
                          textAlign: isRTL ? TextAlign.right : TextAlign.left,
                          primaryStyle: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                                letterSpacing: -0.6,
                                height: 1.15,
                              ) ??
                              TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                          secondaryStyle: TextStyle(
                            fontSize: 16,
                            height: 1.35,
                            color: cs.onSurface.withCalmAlpha(0.72),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          _HeaderIconButton(
                            icon: Icons.menu_book_rounded,
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.education),
                            tooltip: languageProvider.t('home.learn'),
                            accentColor: cs.secondary,
                            brightness: theme.brightness,
                            surface: cs.surface,
                            onSurface: cs.onSurface,
                          ),
                          const SizedBox(width: 8),
                          _HeaderIconButton(
                            icon: Icons.settings_rounded,
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
                            tooltip: languageProvider.t('home.settings'),
                            accentColor: cs.primary,
                            brightness: theme.brightness,
                            surface: cs.surface,
                            onSurface: cs.onSurface,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _GreetingCard(
                              isRTL: isRTL,
                              languageProvider: languageProvider,
                              colorScheme: cs,
                              textTheme: theme.textTheme,
                              reduceMotion: reduceMotion,
                              brightness: theme.brightness,
                            ),
                            const SizedBox(height: 24),
                            _HomeModeCard(
                              title: languageProvider.t('home.self.title'),
                              subtitle: languageProvider.t('home.self.subtitle'),
                              icon: Icons.self_improvement_rounded,
                              onTap: _openSelfRegulation,
                              isRTL: isRTL,
                              primaryTone: true,
                              colorScheme: cs,
                              textTheme: theme.textTheme,
                              brightness: theme.brightness,
                              reduceMotion: reduceMotion,
                            ),
                            const SizedBox(height: 16),
                            _HomeModeCard(
                              title: languageProvider.t('home.helper.title'),
                              subtitle: languageProvider.t('home.helper.subtitle'),
                              icon: Icons.people_rounded,
                              onTap: _openHelperGuidance,
                              isRTL: isRTL,
                              primaryTone: false,
                              colorScheme: cs,
                              textTheme: theme.textTheme,
                              brightness: theme.brightness,
                              reduceMotion: reduceMotion,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _EmergencySectionDivider(
                        label: languageProvider.t('home.emergency.section'),
                        colorScheme: cs,
                        textTheme: theme.textTheme,
                      ),
                      const SizedBox(height: 14),
                      Semantics(
                        label: languageProvider.t('home.emergency'),
                        button: true,
                        child: _EmergencyCallRow(
                          title: languageProvider.t('home.emergency.call_title'),
                          subtitle: languageProvider
                              .t('home.emergency.call_subtitle')
                              .replaceAll('%s', _emergencyNumber),
                          isRTL: isRTL,
                          onPressed: () => EmergencyModal.show(context, fromHome: true),
                          colorScheme: cs,
                          textTheme: theme.textTheme,
                          brightness: theme.brightness,
                          reduceMotion: reduceMotion,
                          heroPhoneChip: true,
                        ),
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

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color accentColor;
  final Brightness brightness;
  final Color surface;
  final Color onSurface;

  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.accentColor,
    required this.brightness,
    required this.surface,
    required this.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Color.lerp(
      accentColor,
      onSurface,
      brightness == Brightness.dark ? 0.58 : 0.26,
    )!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Color.alphaBlend(
          accentColor.withCalmAlpha(brightness == Brightness.dark ? 0.26 : 0.2),
          surface.withCalmAlpha(brightness == Brightness.dark ? 0.22 : 0.14),
        ),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: iconColor, size: 25),
          ),
        ),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final bool isRTL;
  final LanguageProvider languageProvider;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool reduceMotion;
  final Brightness brightness;

  const _GreetingCard({
    required this.isRTL,
    required this.languageProvider,
    required this.colorScheme,
    required this.textTheme,
    required this.reduceMotion,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    final outline = colorScheme.onSurface.withCalmAlpha(brightness == Brightness.dark ? 0.14 : 0.1);
    final handIcon = _vividRoleIcon(colorScheme, brightness, primaryAccent: false);
    final grad = [
      colorScheme.surface.withCalmAlpha(brightness == Brightness.dark ? 0.38 : 0.52),
      colorScheme.tertiaryContainer.withCalmAlpha(brightness == Brightness.dark ? 0.32 : 0.44),
      colorScheme.primary.withCalmAlpha(0.09),
    ];
    return _GlassCardShell(
      radius: 20,
      reduceMotion: reduceMotion,
      colorScheme: colorScheme,
      brightness: brightness,
      gradientColors: grad,
      outlineColor: outline,
      outlineWidth: 1.15,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isRTL ? 14 : 18,
              16,
              isRTL ? 18 : 14,
              16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.secondaryContainer.withCalmAlpha(0.92),
                        colorScheme.secondary.withCalmAlpha(0.22),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.secondary.withCalmAlpha(0.35)),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.secondary.withCalmAlpha(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.waving_hand_rounded,
                    color: handIcon,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BilingualLine(
                    translationKey: 'home.greeting',
                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    primaryStyle: textTheme.bodyMedium?.copyWith(
                          fontSize: 14.5,
                          color: colorScheme.onSurface.withCalmAlpha(0.78),
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.12,
                        ) ??
                        TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.12,
                          color: colorScheme.onSurface.withCalmAlpha(0.78),
                        ),
                    secondaryStyle: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      letterSpacing: 0.08,
                      color: colorScheme.onSurfaceVariant.withCalmAlpha(0.85),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: isRTL ? null : 0,
            right: isRTL ? 0 : null,
            top: 8,
            bottom: 8,
            width: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary,
                    colorScheme.tertiary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withCalmAlpha(0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Future<void> Function() onTap;
  final bool isRTL;
  final bool primaryTone;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Brightness brightness;
  final bool reduceMotion;

  const _HomeModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.isRTL,
    required this.primaryTone,
    required this.colorScheme,
    required this.textTheme,
    required this.brightness,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final chevron = isRTL ? Icons.chevron_left_rounded : Icons.chevron_right_rounded;
    const outlineW = 1.25;
    final outline = colorScheme.onSurface.withCalmAlpha(brightness == Brightness.dark ? 0.13 : 0.09);
    final grad = primaryTone
        ? [
            colorScheme.surface.withCalmAlpha(brightness == Brightness.dark ? 0.36 : 0.48),
            colorScheme.primaryContainer.withCalmAlpha(brightness == Brightness.dark ? 0.44 : 0.52),
            colorScheme.primary.withCalmAlpha(0.11),
          ]
        : [
            colorScheme.surface.withCalmAlpha(brightness == Brightness.dark ? 0.36 : 0.48),
            colorScheme.secondaryContainer.withCalmAlpha(brightness == Brightness.dark ? 0.42 : 0.5),
            colorScheme.secondary.withCalmAlpha(0.1),
          ];

    final iconGlyph = _vividRoleIcon(colorScheme, brightness, primaryAccent: primaryTone);
    final role = primaryTone ? colorScheme.primary : colorScheme.secondary;
    final roleSoft = primaryTone ? colorScheme.primaryContainer : colorScheme.secondaryContainer;
    final chevronColor = Color.lerp(colorScheme.onSurface, role, 0.42)!.withCalmAlpha(0.9);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: _GlassCardShell(
        radius: 22,
        reduceMotion: reduceMotion,
        colorScheme: colorScheme,
        brightness: brightness,
        gradientColors: grad,
        outlineColor: outline,
        outlineWidth: outlineW,
        child: InkWell(
          onTap: () => onTap(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 212),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
              child: Column(
                crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              roleSoft.withCalmAlpha(0.95),
                              role.withCalmAlpha(0.26),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: role.withCalmAlpha(0.38)),
                          boxShadow: [
                            BoxShadow(
                              color: role.withCalmAlpha(0.14),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: iconGlyph, size: 28),
                      ),
                      const Spacer(),
                      Icon(chevron, color: chevronColor, size: 26),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.2,
                      height: 1.25,
                    ),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencySectionDivider extends StatelessWidget {
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _EmergencySectionDivider({
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = colorScheme.outline.withCalmAlpha(0.32);
    return Row(
      children: [
        Expanded(child: Divider(height: 1, thickness: 1, color: lineColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.tertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Expanded(child: Divider(height: 1, thickness: 1, color: lineColor)),
      ],
    );
  }
}

class _EmergencyCallRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isRTL;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Brightness brightness;
  final bool reduceMotion;
  /// When true, wraps [EmergencyHeroPhoneChip] in [Hero] (home → modal flight).
  final bool heroPhoneChip;

  const _EmergencyCallRow({
    required this.title,
    required this.subtitle,
    required this.isRTL,
    required this.onPressed,
    required this.colorScheme,
    required this.textTheme,
    required this.brightness,
    required this.reduceMotion,
    this.heroPhoneChip = false,
  });

  @override
  Widget build(BuildContext context) {
    final chevron = isRTL ? Icons.chevron_left_rounded : Icons.chevron_right_rounded;
    final outline = colorScheme.onSurface.withCalmAlpha(brightness == Brightness.dark ? 0.14 : 0.1);
    final grad = [
      colorScheme.surface.withCalmAlpha(brightness == Brightness.dark ? 0.34 : 0.46),
      colorScheme.primaryContainer.withCalmAlpha(brightness == Brightness.dark ? 0.38 : 0.42),
      colorScheme.secondary.withCalmAlpha(0.1),
    ];
    final chevronColor =
        Color.lerp(colorScheme.onSurface, colorScheme.primary, 0.35)!.withCalmAlpha(0.88);

    final Widget chip = const EmergencyHeroPhoneChip();
    final Widget lead = heroPhoneChip
        ? Hero(
            tag: EmergencyHeroPhoneChip.heroTag,
            child: chip,
          )
        : chip;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: _GlassCardShell(
        radius: 20,
        reduceMotion: reduceMotion,
        colorScheme: colorScheme,
        brightness: brightness,
        gradientColors: grad,
        outlineColor: outline,
        outlineWidth: 1.2,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                lead,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.1,
                        ),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                Icon(chevron, color: chevronColor, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}