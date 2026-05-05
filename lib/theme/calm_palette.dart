import 'package:flutter/material.dart';

/// Phase-specific colors: calm by default, warm not clinical.
/// Dark values match the design brief; light values are soft companions (no harsh white in flows).
class CalmPalette {
  CalmPalette._();

  // —— Dark (spec) ——
  static const Color darkCrisisBg = Color(0xFF0F1923);
  static const Color darkCrisisBgDeep = Color(0xFF0A1219);
  static const Color darkCalmBlue = Color(0xFF2D7EA8);
  static const Color darkMidBlue = Color(0xFF1D4E6B);

  static const Color darkForestBg = Color(0xFF0D1F1A);
  static const Color darkForestBgDeep = Color(0xFF081510);
  static const Color darkTealBreath = Color(0xFF5DCAA5);
  static const Color darkForestMid = Color(0xFF1D6B50);

  static const Color darkWarmDusk = Color(0xFF1A1610);
  static const Color darkWarmDuskDeep = Color(0xFF12100C);
  static const Color darkAmberWarmth = Color(0xFFC8A84A);
  static const Color darkWarmMid = Color(0xFF3A3020);

  // —— Light (adapted) ——
  static const Color lightCrisisBg = Color(0xFFE4EAEF);
  static const Color lightCrisisBgDeep = Color(0xFFD5DEE6);
  static const Color lightCalmBlue = Color(0xFF2A6F94);
  static const Color lightMidBlue = Color(0xFF7A9BAE);

  static const Color lightForestBg = Color(0xFFE8F0EC);
  static const Color lightForestBgDeep = Color(0xFFDDE8E2);
  static const Color lightTealBreath = Color(0xFF3A9A7A);
  static const Color lightForestMid = Color(0xFF5A9E7E);

  static const Color lightWarmDusk = Color(0xFFF3EEE4);
  static const Color lightWarmDuskDeep = Color(0xFFE8E0D4);
  static const Color lightAmberWarmth = Color(0xFFB8943D);
  static const Color lightWarmMid = Color(0xFFC9BDA8);

  // Home / settings shell
  static const Color darkShellTop = Color(0xFF152028);
  static const Color darkShellBottom = Color(0xFF0F1923);
  static const Color lightShellTop = Color(0xFFD8E4EA);
  static const Color lightShellBottom = Color(0xFFE8EEF2);

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static CalmPhase crisis(BuildContext context) {
    final d = _isDark(context);
    return CalmPhase(
      background: d ? darkCrisisBg : lightCrisisBg,
      backgroundDeep: d ? darkCrisisBgDeep : lightCrisisBgDeep,
      accent: d ? darkCalmBlue : lightCalmBlue,
      secondary: d ? darkMidBlue : lightMidBlue,
      textPrimary: d ? const Color(0xFFE8EEF2) : const Color(0xFF1A2832),
      textSecondary: d ? const Color(0xFFB8C5D0) : const Color(0xFF3D4F5C),
      surface: d ? Colors.white.withCalmAlpha(0.08) : Colors.white.withCalmAlpha(0.65),
      onAccent: Colors.white,
      ctaBackground: d ? darkCalmBlue : lightCalmBlue,
      ctaForeground: Colors.white,
    );
  }

  /// Grounding & reassurance: same slow forest mood as breathing.
  static CalmPhase regulation(BuildContext context) {
    final d = _isDark(context);
    return CalmPhase(
      background: d ? darkForestBg : lightForestBg,
      backgroundDeep: d ? darkForestBgDeep : lightForestBgDeep,
      accent: d ? darkTealBreath : lightTealBreath,
      secondary: d ? darkForestMid : lightForestMid,
      textPrimary: d ? const Color(0xFFE8F2ED) : const Color(0xFF152820),
      textSecondary: d ? const Color(0xFFA8C4B6) : const Color(0xFF2D4A3E),
      surface: d ? Colors.white.withCalmAlpha(0.07) : Colors.white.withCalmAlpha(0.55),
      onAccent: d ? const Color(0xFF0D1F1A) : Colors.white,
      ctaBackground: d ? darkTealBreath : lightTealBreath,
      ctaForeground: d ? const Color(0xFF0D1F1A) : Colors.white,
    );
  }

  static CalmPhase breathing(BuildContext context) => regulation(context);

  static CalmPhase recovery(BuildContext context) {
    final d = _isDark(context);
    return CalmPhase(
      background: d ? darkWarmDusk : lightWarmDusk,
      backgroundDeep: d ? darkWarmDuskDeep : lightWarmDuskDeep,
      accent: d ? darkAmberWarmth : lightAmberWarmth,
      secondary: d ? darkWarmMid : lightWarmMid,
      textPrimary: d ? const Color(0xFFEDE6D8) : const Color(0xFF2A2418),
      textSecondary: d ? const Color(0xFFC4B8A4) : const Color(0xFF5C5346),
      surface: d ? Colors.white.withCalmAlpha(0.06) : Colors.white.withCalmAlpha(0.7),
      onAccent: d ? const Color(0xFF1A1610) : const Color(0xFF2A2418),
      ctaBackground: d ? darkAmberWarmth : lightAmberWarmth,
      ctaForeground: d ? const Color(0xFF1A1610) : const Color(0xFF2A2418),
    );
  }

  /// Helper guidance: low-stimulus slate (supporting role).
  static CalmPhase helper(BuildContext context) => crisis(context);

  static LinearGradient homeGradient(BuildContext context) {
    final d = _isDark(context);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: d
          ? const [darkShellTop, darkShellBottom]
          : const [lightShellTop, lightShellBottom],
    );
  }

  static LinearGradient shellGradient(BuildContext context) => homeGradient(context);
}

class CalmPhase {
  final Color background;
  final Color? backgroundDeep;
  final Color accent;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color onAccent;
  final Color ctaBackground;
  final Color ctaForeground;

  const CalmPhase({
    required this.background,
    this.backgroundDeep,
    required this.accent,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.onAccent,
    required this.ctaBackground,
    required this.ctaForeground,
  });

  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: backgroundDeep != null ? [backgroundDeep!, background] : [background, background],
      );
}

/// Alpha-only color tweaks via [Color.withValues] (single place to adjust if Flutter changes APIs).
extension CalmColorAlpha on Color {
  Color withCalmAlpha(double opacity) => withValues(alpha: opacity);
}
