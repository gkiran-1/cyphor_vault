import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/isar_service.dart';
import '../database/collections/user_profile.dart';
import '../utils/constants.dart';
import 'crypto_service.dart';
import 'key_derivation.dart';

class KeyManager {
  KeyManager._();
  static final KeyManager instance = KeyManager._();

  Uint8List? _currentKEK;

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  Uint8List? get currentKEK => _currentKEK;
  bool get isUnlocked => _currentKEK != null;

  /// Sets the active KEK directly (e.g. after restoring from an encrypted backup).
  void setUnlockedKEK(Uint8List kek) {
    _currentKEK = kek;
  }

  /// Saves salts to secure storage.
  Future<void> saveSalts({
    required Uint8List pinSalt,
    required Uint8List recoverySalt,
  }) async {
    await _storage.write(
      key: SecurityConstants.pinSaltKey,
      value: base64.encode(pinSalt),
    );
    await _storage.write(
      key: SecurityConstants.recoverySaltKey,
      value: base64.encode(recoverySalt),
    );
  }

  /// Retrieves the active PIN salt.
  Future<Uint8List?> getPinSalt() async {
    final s = await _storage.read(key: SecurityConstants.pinSaltKey);
    if (s != null) return base64.decode(s);
    final profile = await IsarService.instance.getUserProfile();
    if (profile != null && profile.pinSalt.isNotEmpty) {
      return base64.decode(profile.pinSalt);
    }
    return null;
  }

  /// Retrieves the active recovery salt.
  Future<Uint8List?> getRecoverySalt() async {
    final s = await _storage.read(key: SecurityConstants.recoverySaltKey);
    if (s != null) return base64.decode(s);
    return null;
  }

  /// Generates a human-readable recovery phrase (8 groups of 4 chars from safe charset).
  static String generateRecoveryPhrase() {
    const charset = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    final groups = List.generate(8, (_) =>
      List.generate(4, (_) => charset[rng.nextInt(charset.length)]).join());
    return groups.join('-');
  }

  /// Initialize KEK at account creation.
  /// PIN is the primary key; recovery phrase is the fallback.
  /// Returns the generated recovery phrase — display once to user.
  Future<String> initializeKeys({
    required String pin,
    required UserProfile profile,
  }) async {
    final crypto = CryptoService.instance;
    final derive = KeyDerivation.instance;

    // Generate master KEK
    final kek = crypto.generateRandomKey();

    // --- PIN wrapping (primary) ---
    final pinSaltBytes = KeyDerivation.generateSalt();
    final pinKey = derive.derivePINKey(pin, pinSaltBytes);
    final pinKekIV = crypto.generateIV();
    final wrappedByPIN = crypto.wrapKey(kek, pinKey, pinKekIV);

    // Store PIN salt in secure storage
    await _storage.write(
      key: SecurityConstants.pinSaltKey,
      value: base64.encode(pinSaltBytes),
    );

    // --- Recovery phrase wrapping (fallback) ---
    final recoveryPhrase = generateRecoveryPhrase();
    final recoverySaltBytes = KeyDerivation.generateSalt();
    final recoveryKey = derive.deriveRecoveryKey(recoveryPhrase, recoverySaltBytes);
    final recoveryKekIV = crypto.generateIV();
    final wrappedByRecovery = crypto.wrapKey(kek, recoveryKey, recoveryKekIV);
    final recoveryPhraseHash =
        derive.deriveRecoveryPhraseHash(recoveryPhrase, recoverySaltBytes);

    // Store recovery salt in secure storage
    await _storage.write(
      key: SecurityConstants.recoverySaltKey,
      value: base64.encode(recoverySaltBytes),
    );

    // Update profile
    profile.pinSalt = base64.encode(pinSaltBytes);
    profile.pinHash = base64.encode(pinKey);
    profile.wrappedKEK = wrappedByPIN.ciphertext;
    profile.kekIV = wrappedByPIN.iv;
    profile.wrappedKEKByRecovery = wrappedByRecovery.ciphertext;
    profile.recoveryKekIV = wrappedByRecovery.iv;
    profile.recoveryPhraseHash = recoveryPhraseHash;

    // Store KEK for biometric use
    await _storeKEKForBiometric(kek);

    _currentKEK = kek;
    return recoveryPhrase;
  }

  /// Unlock vault with PIN.
  Future<void> unlockWithPIN(String pin) async {
    final profile = await IsarService.instance.getUserProfile();
    if (profile == null) throw StateError('No user profile found');

    final derive = KeyDerivation.instance;
    final crypto = CryptoService.instance;

    var pinSaltB64 = await _storage.read(key: SecurityConstants.pinSaltKey);
    if (pinSaltB64 == null && profile.pinSalt.isNotEmpty) {
      pinSaltB64 = profile.pinSalt;
      await _storage.write(
        key: SecurityConstants.pinSaltKey,
        value: pinSaltB64,
      );
    }
    if (pinSaltB64 == null) throw StateError('PIN salt not found');

    final pinSalt = base64.decode(pinSaltB64);
    final pinKey = derive.derivePINKey(pin, pinSalt);
    final kekIV = base64.decode(profile.kekIV);

    _currentKEK = crypto.unwrapKey(profile.wrappedKEK, pinKey, kekIV);
  }

  /// Unlock vault with biometric (KEK stored in secure storage).
  Future<void> unlockWithBiometric() async {
    final kekB64 = await _storage.read(key: SecurityConstants.kekKey);
    if (kekB64 == null) throw StateError('Biometric key not found');
    _currentKEK = base64.decode(kekB64);
  }

  /// Reset PIN using recovery phrase.
  /// Returns true if recovery phrase is valid.
  Future<bool> resetPINWithRecovery({
    required String recoveryPhrase,
    required String newPIN,
  }) async {
    final profile = await IsarService.instance.getUserProfile();
    if (profile == null) throw StateError('No user profile found');

    final derive = KeyDerivation.instance;
    final crypto = CryptoService.instance;

    // Load recovery salt
    final recoverySaltB64 =
        await _storage.read(key: SecurityConstants.recoverySaltKey);
    if (recoverySaltB64 == null) throw StateError('Recovery salt not found');
    final recoverySalt = base64.decode(recoverySaltB64);

    // Verify recovery phrase hash
    final providedHash =
        derive.deriveRecoveryPhraseHash(recoveryPhrase, recoverySalt);
    if (providedHash != profile.recoveryPhraseHash) return false;

    // Unwrap KEK using recovery key
    final recoveryKey = derive.deriveRecoveryKey(recoveryPhrase, recoverySalt);
    final recoveryKekIV = base64.decode(profile.recoveryKekIV);
    final kek = crypto.unwrapKey(
        profile.wrappedKEKByRecovery, recoveryKey, recoveryKekIV);

    // Re-wrap KEK with new PIN
    final pinSaltBytes = KeyDerivation.generateSalt();
    final pinKey = derive.derivePINKey(newPIN, pinSaltBytes);
    final pinKekIV = crypto.generateIV();
    final wrappedByPIN = crypto.wrapKey(kek, pinKey, pinKekIV);

    await _storage.write(
      key: SecurityConstants.pinSaltKey,
      value: base64.encode(pinSaltBytes),
    );

    profile.pinSalt = base64.encode(pinSaltBytes);
    profile.pinHash = base64.encode(pinKey);
    profile.wrappedKEK = wrappedByPIN.ciphertext;
    profile.kekIV = wrappedByPIN.iv;
    profile.updatedAt = DateTime.now();

    await IsarService.instance.saveUserProfile(profile);

    _currentKEK = kek;
    await _storeKEKForBiometric(kek);
    return true;
  }

  /// Change PIN when vault is already unlocked.
  Future<void> changePIN(String newPIN) async {
    if (_currentKEK == null) throw StateError('Vault is locked');

    final profile = await IsarService.instance.getUserProfile();
    if (profile == null) throw StateError('No user profile found');

    final derive = KeyDerivation.instance;
    final crypto = CryptoService.instance;

    final pinSaltBytes = KeyDerivation.generateSalt();
    final pinKey = derive.derivePINKey(newPIN, pinSaltBytes);
    final pinKekIV = crypto.generateIV();
    final wrappedByPIN = crypto.wrapKey(_currentKEK!, pinKey, pinKekIV);

    await _storage.write(
      key: SecurityConstants.pinSaltKey,
      value: base64.encode(pinSaltBytes),
    );

    profile.pinSalt = base64.encode(pinSaltBytes);
    profile.pinHash = base64.encode(pinKey);
    profile.wrappedKEK = wrappedByPIN.ciphertext;
    profile.kekIV = wrappedByPIN.iv;
    profile.updatedAt = DateTime.now();

    await IsarService.instance.saveUserProfile(profile);
  }

  Future<void> enableBiometric() async {
    if (_currentKEK == null) throw StateError('Vault is locked');
    await _storeKEKForBiometric(_currentKEK!);
  }

  Future<void> disableBiometric() async {
    await _storage.delete(key: SecurityConstants.kekKey);
  }

  Future<void> _storeKEKForBiometric(Uint8List kek) async {
    await _storage.write(
      key: SecurityConstants.kekKey,
      value: base64.encode(kek),
    );
  }

  /// Lock the vault — clears KEK from memory.
  void lock() {
    _currentKEK = null;
  }
}
