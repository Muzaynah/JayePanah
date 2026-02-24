import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/LanguageProvider.dart';
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
        ChangeNotifierProvider(create: (_) => InterventionStateProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'JayePanah',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: Locale(languageProvider.currentLanguage),
            supportedLocales: const [
              Locale('en'),
              Locale('ur'),
            ],
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
