import 'package:flutter/material.dart';

/// Phase-specific colors: soft, calming, not clinical.
/// Light mode: Warm, soft lavender/cream. Dark mode: Deep navy/indigo.
class CalmPalette {
  CalmPalette._();

  // —— Dark Mode (soft & deep) ——
  static const Color darkCrisisBg = Color(0xFF0F1219);
  static const Color darkCrisisBgDeep = Color(0xFF0A0E15);
  static const Color darkCalmBlue = Color(0xFF6FA3CC);
  static const Color darkMidBlue = Color(0xFF4A6F9E);

  static const Color darkStabilizeBg = Color(0xFF12101D);
  static const Color darkStabilizeBgDeep = Color(0xFF0D0A14);
  static const Color darkVioletAccent = Color(0xFF9B7FD4);
  static const Color darkVioletMid = Color(0xFF6B5A9E);

  static const Color darkForestBg = Color(0xFF0D1D1A);
  static const Color darkForestBgDeep = Color(0xFF081310);
  static const Color darkTealBreath = Color(0xFF6FD9B5);
  static const Color darkForestMid = Color(0xFF4A8A6B);

  static const Color darkWarmDusk = Color(0xFF1A1410);
  static const Color darkWarmDuskDeep = Color(0xFF120E0A);
  static const Color darkAmberWarmth = Color(0xFFD4B857);
  static const Color darkWarmMid = Color(0xFF4A3F28);

  // —— Light Mode (soft & warm) ——
  static const Color lightCrisisBg = Color(0xFFEAEDF5);
  static const Color lightCrisisBgDeep = Color(0xFFDCE1ED);
  static const Color lightCalmBlue = Color(0xFF4B82B5);
  static const Color lightMidBlue = Color(0xFF8FACC0);

  static const Color lightStabilizeBg = Color(0xFFF5F0FC);
  static const Color lightStabilizeBgDeep = Color(0xFFEDE4F6);
  static const Color lightVioletAccent = Color(0xFF8B6FBF);
  static const Color lightVioletMid = Color(0xFFC4B5D9);

  static const Color lightForestBg = Color(0xFFEEF5F0);
  static const Color lightForestBgDeep = Color(0xFFE0EDEA);
  static const Color lightTealBreath = Color(0xFF4FA87D);
  static const Color lightForestMid = Color(0xFF7CB59D);

  static const Color lightWarmDusk = Color(0xFFFAF6EE);
  static const Color lightWarmDuskDeep = Color(0xFFF0EAE0);
  static const Color lightAmberWarmth = Color(0xFFD4A85A);
  static const Color lightWarmMid = Color(0xFFE8DCC8);

  // Home / settings shell
  static const Color darkShellTop = Color(0xFF0F1319);
  static const Color darkShellBottom = Color(0xFF0A0E14);
  static const Color lightShellTop = Color(0xFFF5EEF8);
  static const Color lightShellBottom = Color(0xFFF9F6FC);

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static CalmPhase crisis(BuildContext context) {
    final d = _isDark(context);
    return CalmPhase(
      background: d ? darkCrisisBg : lightCrisisBg,
      backgroundDeep: d ? darkCrisisBgDeep : lightCrisisBgDeep,
      accent: d ? darkCalmBlue : lightCalmBlue,
      secondary: d ? darkMidBlue : lightMidBlue,
      textPrimary: d ? const Color(0xFFEDF1F6) : const Color(0xFF1B2A3A),
      textSecondary: d ? const Color(0xFFC0CDD8) : const Color(0xFF425969),
      surface: d ? Colors.white.withValues(alpha:0.08) : Colors.white.withValues(alpha:0.7),
      onAccent: Colors.white,
      ctaBackground: d ? darkCalmBlue : lightCalmBlue,
      ctaForeground: Colors.white,
    );
  }

  static CalmPhase stabilization(BuildContext context) {
    final d = _isDark(context);
    return CalmPhase(
      background: d ? darkStabilizeBg : lightStabilizeBg,
      backgroundDeep: d ? darkStabilizeBgDeep : lightStabilizeBgDeep,
      accent: d ? darkVioletAccent : lightVioletAccent,
      secondary: d ? darkVioletMid : lightVioletMid,
      textPrimary: d ? const Color(0xFFF0E8FC) : const Color(0xFF2A1F3F),
      textSecondary: d ? const Color(0xFFC8BBDC) : const Color(0xFF584F7A),
      surface: d ? Colors.white.withValues(alpha:0.07) : Colors.white.withValues(alpha:0.75),
      onAccent: Colors.white,
      ctaBackground: d ? darkVioletAccent : lightVioletAccent,
      ctaForeground: d ? const Color(0xFF12101D) : Colors.white,
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
      surface: d ? Colors.white.withValues(alpha:0.07) : Colors.white.withValues(alpha:0.55),
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
      surface: d ? Colors.white.withValues(alpha:0.06) : Colors.white.withValues(alpha:0.7),
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
  Color withCalmAlpha(double alpha) => withValues(alpha: alpha);
}
