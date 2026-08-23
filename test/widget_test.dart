// Basic smoke test for CipherBox app.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyphor_vault/app.dart';
import 'package:cyphor_vault/core/providers/auth_providers.dart';

class MockAuthStateNotifier extends AuthStateNotifier {
  MockAuthStateNotifier();

  @override
  Future<void> initialize() async {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => MockAuthStateNotifier()),
        ],
        child: const CipherBoxApp(),
      ),
    );
    // Just verify the app can build its first frame
    expect(find.byType(CipherBoxApp), findsOneWidget);
    // Let splash screen animations finish so their tickers/timers are cleaned up
    await tester.pump(const Duration(seconds: 2));
  });
}
