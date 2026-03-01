import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../auth/auth_service.dart';
import '../auth/biometric_service.dart';
import '../database/collections/user_profile.dart';
import '../encryption/key_manager.dart';

enum AuthStatus { unknown, unauthenticated, authenticated, locked }

class AuthState {
  final AuthStatus status;
  final UserProfile? profile;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.profile,
    this.error,
  });

  AuthState copyWith(
      {AuthStatus? status, UserProfile? profile, String? error}) {
    return AuthState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState()) {
    debugPrint('[AuthStateNotifier] Constructor called');
    initialize();
  }

  Future<void> initialize() async {
    debugPrint('[AuthStateNotifier] initialize called');
    final hasAccount = await AuthService.instance.hasAccount();
    debugPrint('[AuthStateNotifier] hasAccount: $hasAccount');
    if (!hasAccount) {
      debugPrint('[AuthStateNotifier] No account, setting unauthenticated');
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    final biometricAvailable = await BiometricService.instance.isAvailable();
    debugPrint('[AuthStateNotifier] Biometric available: $biometricAvailable');
    if (biometricAvailable) {
      final authenticated = await BiometricService.instance.authenticate(
        reason: 'Authenticate to unlock CipherBox',
      );
      debugPrint(
          '[AuthStateNotifier] Biometric authentication at startup: $authenticated');
      if (authenticated) {
        final profile = await AuthService.instance.getCurrentProfile();
        state =
            state.copyWith(status: AuthStatus.authenticated, profile: profile);
        await KeyManager.instance.unlockWithBiometric();
        debugPrint('[AuthStateNotifier] Vault unlocked during initialization');
        return;
      }
    }
    debugPrint('[AuthStateNotifier] Account exists, setting locked');
    state = state.copyWith(status: AuthStatus.locked);
  }

  Future<void> loginWithPIN(String pin) async {
    debugPrint('[AuthStateNotifier] loginWithPIN called');
    state = state.copyWith(error: null);
    try {
      final success = await AuthService.instance.loginWithPIN(pin);
      debugPrint('[AuthStateNotifier] loginWithPIN success: $success');
      if (success) {
        final profile = await AuthService.instance.getCurrentProfile();
        debugPrint(
            '[AuthStateNotifier] PIN login success, setting authenticated');
        state =
            state.copyWith(status: AuthStatus.authenticated, profile: profile);
        await KeyManager.instance.unlockWithPIN(pin);
        debugPrint('[AuthStateNotifier] Vault unlocked with PIN login');
      } else {
        debugPrint('[AuthStateNotifier] PIN login failed');
        state = state.copyWith(error: 'Incorrect PIN');
      }
    } catch (e) {
      debugPrint('[AuthStateNotifier] loginWithPIN error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loginWithBiometric() async {
    debugPrint('[AuthStateNotifier] loginWithBiometric called');
    state = state.copyWith(error: null);
    try {
      final authenticated = await BiometricService.instance.authenticate();
      debugPrint('[AuthStateNotifier] biometric authenticate: $authenticated');
      if (!authenticated) {
        debugPrint('[AuthStateNotifier] Biometric authentication failed');
        state = state.copyWith(error: 'Biometric authentication failed');
        return;
      }
      final success = await AuthService.instance.loginWithBiometric();
      debugPrint('[AuthStateNotifier] loginWithBiometric success: $success');
      if (success) {
        final profile = await AuthService.instance.getCurrentProfile();
        debugPrint(
            '[AuthStateNotifier] Biometric login success, setting authenticated');
        state =
            state.copyWith(status: AuthStatus.authenticated, profile: profile);
        await KeyManager.instance.unlockWithBiometric();
        debugPrint(
            '[AuthStateNotifier] Vault unlocked with biometric authentication');
      } else {
        debugPrint(
            '[AuthStateNotifier] Biometric login failed to unlock vault');
        state = state.copyWith(error: 'Failed to unlock vault');
      }
    } catch (e) {
      debugPrint('[AuthStateNotifier] loginWithBiometric error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// Creates a new vault and returns the recovery phrase.
  Future<String?> createAccount({required String pin}) async {
    state = state.copyWith(error: null);
    try {
      final recoveryPhrase = await AuthService.instance.createAccount(pin: pin);
      final profile = await AuthService.instance.getCurrentProfile();
      state =
          state.copyWith(status: AuthStatus.authenticated, profile: profile);
      return recoveryPhrase;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Reset PIN via recovery phrase. Returns true on success.
  Future<bool> resetPINWithRecovery({
    required String recoveryPhrase,
    required String newPIN,
  }) async {
    state = state.copyWith(error: null);
    try {
      final success = await AuthService.instance.resetPINWithRecovery(
        recoveryPhrase: recoveryPhrase,
        newPIN: newPIN,
      );
      if (success) {
        final profile = await AuthService.instance.getCurrentProfile();
        state =
            state.copyWith(status: AuthStatus.authenticated, profile: profile);
      } else {
        state = state.copyWith(error: 'Recovery phrase is incorrect');
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  void lock() {
    debugPrint('[AuthStateNotifier] lock called');
    AuthService.instance.lock();
    state = state.copyWith(status: AuthStatus.locked, profile: null);
  }

  void requireAuth() {
    debugPrint('[AuthStateNotifier] requireAuth called');
    state = state.copyWith(status: AuthStatus.locked);
  }

  Future<void> reloadProfile() async {
    final profile = await AuthService.instance.getCurrentProfile();
    state = state.copyWith(profile: profile);
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);

final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  return BiometricService.instance.isAvailable();
});
