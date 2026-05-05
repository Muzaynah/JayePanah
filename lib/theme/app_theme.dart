import 'package:flutter/material.dart';
import 'calm_palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const surface = Color(0xFFF7F4EE);
    const onSurface = Color(0xFF2A2418);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: CalmPalette.lightCalmBlue,
        onPrimary: Colors.white,
        secondary: CalmPalette.lightMidBlue,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: onSurface,
        error: const Color(0xFF5C5346),
        onError: Colors.white,
        outline: CalmPalette.lightWarmMid,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: CalmPalette.lightCalmBlue,
        foregroundColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, height: 1.2),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, height: 1.25),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.3),
        bodyLarge: TextStyle(fontSize: 18, height: 1.5),
        bodyMedium: TextStyle(fontSize: 16, height: 1.5),
        labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }

  static ThemeData get darkTheme {
    const surface = Color(0xFF121A22);
    const onSurface = Color(0xFFE4E9EE);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: CalmPalette.darkCalmBlue,
        onPrimary: Colors.white,
        secondary: CalmPalette.darkMidBlue,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: onSurface,
        error: const Color(0xFF8A7A68),
        onError: Colors.white,
        outline: CalmPalette.darkMidBlue,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: CalmPalette.darkCrisisBg,
        foregroundColor: Color(0xFFE8EEF2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, height: 1.2),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, height: 1.25),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1.3),
        bodyLarge: TextStyle(fontSize: 18, height: 1.5),
        bodyMedium: TextStyle(fontSize: 16, height: 1.5),
        labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}
