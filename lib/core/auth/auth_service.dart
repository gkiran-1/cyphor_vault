import 'dart:convert';
import '../database/isar_service.dart';
import '../database/collections/user_profile.dart';
import '../encryption/crypto_service.dart';
import '../encryption/key_derivation.dart';
import '../encryption/key_manager.dart';
import '../utils/constants.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool get isLoggedIn => KeyManager.instance.isUnlocked;

  Future<bool> hasAccount() async {
    final profile = await IsarService.instance.getUserProfile();
    return profile != null;
  }

  /// Create a new vault protected by [pin].
  /// Returns the recovery phrase — must be shown to user exactly once.
  Future<String> createAccount({required String pin}) async {
    final now = DateTime.now();
    final profile = UserProfile()
      ..pinHash = ''
      ..pinSalt = ''
      ..wrappedKEK = ''
      ..kekIV = ''
      ..wrappedKEKByRecovery = ''
      ..recoveryKekIV = ''
      ..recoveryPhraseHash = ''
      ..biometricEnabled = false
      ..autoBackupEnabled = false
      ..autoBackupFrequency = AppConstants.backupWeekly
      ..createdAt = now
      ..updatedAt = now;

    await IsarService.instance.saveUserProfile(profile);

    final recoveryPhrase = await KeyManager.instance.initializeKeys(
      pin: pin,
      profile: profile,
    );

    await IsarService.instance.saveUserProfile(profile);
    return recoveryPhrase;
  }

  /// Verify PIN against stored hash or key unwrap.
  Future<bool> verifyPIN(String pin) async {
    final profile = await IsarService.instance.getUserProfile();
    if (profile == null) return false;
    final pinSalt = await KeyManager.instance.getPinSalt() ??
        (profile.pinSalt.isNotEmpty ? base64.decode(profile.pinSalt) : null);
    if (pinSalt == null) return false;

    final derive = KeyDerivation.instance;
    final key = derive.derivePINKey(pin, pinSalt);
    if (profile.pinHash.isNotEmpty) {
      return base64.encode(key) == profile.pinHash;
    }
    try {
      final crypto = CryptoService.instance;
      final kekIV = base64.decode(profile.kekIV);
      crypto.unwrapKey(profile.wrappedKEK, key, kekIV);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loginWithPIN(String pin) async {
    final profile = await IsarService.instance.getUserProfile();
    if (profile == null) return false;
    try {
      await KeyManager.instance.unlockWithPIN(pin);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loginWithBiometric() async {
    try {
      await KeyManager.instance.unlockWithBiometric();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Reset PIN using recovery phrase. Returns true if recovery phrase is valid.
  Future<bool> resetPINWithRecovery({
    required String recoveryPhrase,
    required String newPIN,
  }) async {
    return KeyManager.instance.resetPINWithRecovery(
      recoveryPhrase: recoveryPhrase,
      newPIN: newPIN,
    );
  }

  void lock() => KeyManager.instance.lock();

  Future<UserProfile?> getCurrentProfile() =>
      IsarService.instance.getUserProfile();

  Future<void> deleteAccount() async {
    await KeyManager.instance.disableBiometric();
    KeyManager.instance.lock();
    await IsarService.instance.deleteAllData();
  }
}
