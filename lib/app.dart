import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/LanguageProvider.dart';
import 'providers/app_settings_provider.dart';
import 'providers/InterventionStateProvider.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => InterventionStateProvider()),
      ],
      child: Consumer2<LanguageProvider, AppSettingsProvider>(
        builder: (context, languageProvider, appSettings, child) {
          return MaterialApp(
            title: 'JayePanah',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appSettings.themeMode,
            locale: Locale(languageProvider.currentLanguage),
            supportedLocales: const [
              Locale('en'),
              Locale('ur'),
            ],
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
            builder: (context, child) {
              if (child == null) return const SizedBox.shrink();
              final mq = MediaQuery.of(context);
              final systemScale = mq.textScaler.scale(1.0);
              final extra = switch (appSettings.textSize) {
                'small' => 0.92,
                'large' => 1.12,
                _ => 1.0,
              };
              return MediaQuery(
                data: mq.copyWith(
                  textScaler: TextScaler.linear(systemScale * extra),
                ),
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
