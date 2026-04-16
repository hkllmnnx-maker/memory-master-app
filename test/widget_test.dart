import 'package:flutter_test/flutter_test.dart';
import 'package:memory_master/main.dart';
import 'package:memory_master/providers/settings_provider.dart';
import 'package:memory_master/services/storage_service.dart';

void main() {
  setUpAll(() async {
    // Initialize storage before widget tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await StorageService.init();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    final settings = SettingsProvider();
    await settings.init();
    await tester.pumpWidget(MemoryMasterApp(settingsProvider: settings));
    // Splash screen shows app title
    expect(find.text('ذاكرة الحفظ'), findsWidgets);
  });
}
