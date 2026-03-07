// Basic smoke test for CipherBox app.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyphor_vault/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CipherBoxApp()),
    );
    // Just verify the app can build its first frame
    expect(find.byType(CipherBoxApp), findsOneWidget);
  });
}
