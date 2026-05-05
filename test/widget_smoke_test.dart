import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jayepanah/providers/LanguageProvider.dart';
import 'package:jayepanah/providers/app_settings_provider.dart';
import 'package:jayepanah/providers/InterventionStateProvider.dart';
import 'package:jayepanah/screens/EducationScreen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Education screen builds with global providers', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
          ChangeNotifierProvider(create: (_) => InterventionStateProvider()),
        ],
        child: const MaterialApp(
          home: EducationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EducationScreen), findsOneWidget);
  });
}
