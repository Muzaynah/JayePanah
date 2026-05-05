import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jayepanah/providers/LanguageProvider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  const criticalKeys = <String>[
    'emergency.call_failed',
    'home.resume.title',
    'home.resume.helper.title',
    'education.section10',
    'self.reassurance.6',
    'flow.home',
    'settings.store.privacy',
    'settings.reset.dialog.title',
  ];

  test('critical keys resolve for English', () async {
    final provider = LanguageProvider();
    await provider.setLanguage('en');
    for (final key in criticalKeys) {
      final value = provider.t(key);
      expect(value, isNot(equals(key)), reason: 'Missing EN key: $key');
      expect(value.isNotEmpty, isTrue);
    }
  });

  test('critical keys resolve for Urdu', () async {
    final provider = LanguageProvider();
    await provider.setLanguage('ur');
    for (final key in criticalKeys) {
      final value = provider.t(key);
      expect(value, isNot(equals(key)), reason: 'Missing UR key: $key');
      expect(value.isNotEmpty, isTrue);
    }
  });
}
