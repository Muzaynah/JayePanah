import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // LIGHT MODE — Warm, soft, natural
  static const Color lightBase = Color(0xFFF6F3EC);
  static const Color lightGradientStart = Color(0xFFF2EFE4);
  static const Color lightGradientEnd = Color(0xFFE9E5DC);
  static const Color lightTextPrimary = Color(0xFF29251E);
  static const Color lightTextSecondary = Color(0xFF5E5A50);

  // DARK MODE — Deep night sky feeling
  static const Color darkBase = Color(0xFF111714);
  static const Color darkGradientStart = Color(0xFF111714);
  static const Color darkGradientEnd = Color(0xFF0A100E);
  static const Color darkTextPrimary = Color(0xFFF0ECE2);
  static const Color darkTextSecondary = Color(0xFF8A9488);

  // Legacy colors (keeping for backward compatibility)
  static const Color backgroundBase = Color(0xFFF5F2E9);
  static const Color backgroundSurface = Color(0xFFF0EBE1);

  static const Color glassSage = Color(0xFF7A9D78);
  static const Color glassLavender = Color(0xFF8E78B0);
  static const Color glassPeach = Color(0xFFDFAE92);
  static const Color glassMist = Color(0xFFC8D7CE);

  static const Color textPrimary = Color(0xFF2C2A24);
  static const Color textSecondary = Color(0xFF5F5B53);
  static const Color textOnGlass = Color(0xFF34322D);

  static const Color accentSage = Color(0xFF4F7A56);
  static const Color accentLavender = Color(0xFF6651A5);
  static const Color accentDanger = Color(0xFFCF3D40);

  // Spacing scale
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border radius scale
  static const double radiusSM = 12.0;
  static const double radiusMD = 18.0;
  static const double radiusLG = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusPill = 100.0;

  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 700);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: DesignSystem.accentSage,
        onPrimary: Colors.white,
        secondary: DesignSystem.accentLavender,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: DesignSystem.textPrimary,
        error: const Color(0xFFD4635F),
        onError: Colors.white,
        outline: DesignSystem.textSecondary,
        outlineVariant: DesignSystem.textSecondary.withOpacity(0.34),
        surfaceContainer: DesignSystem.backgroundSurface,
        surfaceContainerHigh: DesignSystem.glassMist.withOpacity(0.30),
      ),
      scaffoldBackgroundColor: DesignSystem.lightBase,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: DesignSystem.accentSage,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.dmSerifDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.accentSage,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.15),
              ),
            ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.accentSage,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.15),
              ),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignSystem.accentSage,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(
            color: DesignSystem.accentSage.withOpacity(0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: DesignSystem.textPrimary,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: DesignSystem.textPrimary,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: DesignSystem.textPrimary,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: DesignSystem.textPrimary,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DesignSystem.textPrimary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: DesignSystem.textSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const surfaceDark = Color(0xFF0F0F0F);
    const onSurfaceDark = Color(0xFFE8E8E8);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: DesignSystem.accentSage,
        onPrimary: Colors.white,
        secondary: DesignSystem.accentLavender,
        onSecondary: Colors.white,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        error: const Color(0xFFD4635F),
        onError: Colors.white,
        outline: DesignSystem.textSecondary,
        outlineVariant: DesignSystem.textSecondary.withOpacity(0.3),
        surfaceContainer: const Color(0xFF1A1A1A),
        surfaceContainerHigh: const Color(0xFF2A2A2A),
      ),
      scaffoldBackgroundColor: surfaceDark,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: DesignSystem.accentSage,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.dmSerifDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.accentSage,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.15),
              ),
            ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.accentSage,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.15),
              ),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignSystem.accentSage,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(
            color: DesignSystem.accentSage.withOpacity(0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: onSurfaceDark,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: onSurfaceDark,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onSurfaceDark,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurfaceDark,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurfaceDark,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurfaceDark.withOpacity(0.7),
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    );
  }
}
