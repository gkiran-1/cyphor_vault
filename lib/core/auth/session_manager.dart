import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../encryption/key_manager.dart';
import '../providers/auth_providers.dart';

class SessionManager extends WidgetsBindingObserver {
  final WidgetRef ref;

  SessionManager(this.ref);

  void register() {
    WidgetsBinding.instance.addObserver(this);
  }

  void unregister() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _lockVault();
        break;
      case AppLifecycleState.resumed:
        _onResume();
        break;
      default:
        break;
    }
  }

  void _lockVault() {
    KeyManager.instance.lock();
    ref.read(authStateProvider.notifier).lock();
  }

  void _onResume() {
    if (!KeyManager.instance.isUnlocked) {
      ref.read(authStateProvider.notifier).requireAuth();
    }
  }
}
