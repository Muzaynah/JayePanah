import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  AppSettingsProvider() {
    _load();
  }

  bool reduceMotion = false;
  String textSize = 'medium';
  /// Stored as: system | light | dark
  String themePreference = 'system';

  /// After disclaimer / first-run, false until prefs load (treated as not complete → bilingual).
  bool onboardingComplete = false;

  static const String _reduceMotionKey = 'jayepanah_reducemotion';
  static const String _textSizeKey = 'jayepanah_textsize';
  static const String _themePreferenceKey = 'jayepanah_theme_mode';
  static const String _onboardingCompleteKey = 'jayepanah_onboarding_complete';

  /// English + Urdu captions only during initial onboarding (before first home entry).
  bool get showBilingualCaptions => !onboardingComplete;

  ThemeMode get themeMode => switch (themePreference) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    reduceMotion = prefs.getBool(_reduceMotionKey) ?? false;
    textSize = prefs.getString(_textSizeKey) ?? 'medium';

    var mode = prefs.getString(_themePreferenceKey);
    if (mode == null || (mode != 'system' && mode != 'light' && mode != 'dark')) {
      final legacyDark = prefs.getBool('jayepanah_darkmode') ?? false;
      mode = legacyDark ? 'dark' : 'system';
      await prefs.setString(_themePreferenceKey, mode);
    }
    themePreference = mode;

    onboardingComplete = prefs.getBool(_onboardingCompleteKey) ?? false;

    notifyListeners();
  }

  Future<void> reload() => _load();

  Future<void> setReduceMotion(bool value) async {
    reduceMotion = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reduceMotionKey, value);
    notifyListeners();
  }

  Future<void> setTextSize(String value) async {
    if (value != 'small' && value != 'medium' && value != 'large') return;
    textSize = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_textSizeKey, value);
    notifyListeners();
  }

  Future<void> setThemePreference(String value) async {
    if (value != 'system' && value != 'light' && value != 'dark') return;
    themePreference = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, value);
    await prefs.remove('jayepanah_darkmode');
    notifyListeners();
  }

  /// Call when the user finishes the disclaimer (prefs flag should already be saved).
  void markInitialOnboardingComplete() {
    onboardingComplete = true;
    notifyListeners();
  }
}
