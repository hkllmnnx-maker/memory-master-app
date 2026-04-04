import 'package:flutter_test/flutter_test.dart';
import 'package:memory_master/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MemoryMasterApp());
    expect(find.text('ذاكرة الحفظ'), findsOneWidget);
  });
}
