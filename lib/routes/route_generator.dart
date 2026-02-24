import 'package:flutter/material.dart';
import '../screens/SplashScreen.dart';
import '../screens/OnboardingScreen.dart';
import '../screens/LanguageSelectionScreen.dart';
import '../screens/DisclaimerScreen.dart';
import '../screens/HomeScreen.dart';
import '../screens/EducationScreen.dart';
import '../screens/SelfRegulationScreen.dart';
import '../screens/HelperGuidanceScreen.dart';
import '../screens/SettingsScreen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.languageSelection:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
      case AppRoutes.disclaimer:
        return MaterialPageRoute(builder: (_) => const DisclaimerScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.education:
        return MaterialPageRoute(builder: (_) => const EducationScreen());
      case AppRoutes.selfRegulation:
        return MaterialPageRoute(builder: (_) => const SelfRegulationScreen());
      case AppRoutes.helperGuidance:
        return MaterialPageRoute(builder: (_) => const HelperGuidanceScreenWidget());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
