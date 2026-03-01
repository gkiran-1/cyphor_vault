import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../utils/constants.dart';

class KeyDerivation {
  KeyDerivation._();
  static final KeyDerivation instance = KeyDerivation._();

  /// Derives a 512-bit key from [password] and [salt] using Argon2id.
  /// First 256 bits = auth hash portion.
  /// Last 256 bits = encryption key portion.
  Uint8List deriveKeyFromPassword(String password, Uint8List salt) {
    final passwordBytes = utf8.encode(password);

    final params = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      version: Argon2Parameters.ARGON2_VERSION_13,
      iterations: SecurityConstants.argon2Iterations,
      memoryPowerOf2: _log2(SecurityConstants.argon2MemoryKB),
      lanes: SecurityConstants.argon2Parallelism,
      desiredKeyLength: SecurityConstants.argon2KeyLength,
    );

    final generator = Argon2BytesGenerator()..init(params);
    return generator.process(passwordBytes);
  }

  /// Returns the auth hash portion (first 32 bytes) encoded as base64.
  String deriveAuthHash(String password, Uint8List salt) {
    final key = deriveKeyFromPassword(password, salt);
    return base64.encode(key.sublist(0, 32));
  }

  /// Returns the encryption key portion (last 32 bytes).
  Uint8List deriveEncryptionKey(String password, Uint8List salt) {
    final key = deriveKeyFromPassword(password, salt);
    return key.sublist(32, 64);
  }

  /// Returns the PIN-derived encryption key using PBKDF2-SHA256 (faster for PIN).
  Uint8List derivePINKey(String pin, Uint8List salt) {
    final pinBytes = utf8.encode(pin);
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, 100000, SecurityConstants.aesKeyLength));
    return pbkdf2.process(pinBytes);
  }

  /// Derives a 256-bit key from a recovery phrase using Argon2id.
  Uint8List deriveRecoveryKey(String recoveryPhrase, Uint8List salt) {
    final phraseBytes = utf8.encode(recoveryPhrase.replaceAll('-', '').toUpperCase());
    final params = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      version: Argon2Parameters.ARGON2_VERSION_13,
      iterations: 2,
      memoryPowerOf2: _log2(32768), // 32 MB — lighter than master params
      lanes: 2,
      desiredKeyLength: SecurityConstants.aesKeyLength,
    );
    final generator = Argon2BytesGenerator()..init(params);
    return generator.process(phraseBytes);
  }

  /// Derives a 32-byte auth hash from a recovery phrase using PBKDF2 (for verification only).
  String deriveRecoveryPhraseHash(String recoveryPhrase, Uint8List salt) {
    final phraseBytes = utf8.encode(recoveryPhrase.replaceAll('-', '').toUpperCase());
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, 100000, 32));
    return base64.encode(pbkdf2.process(phraseBytes));
  }

  /// Generates a random 256-bit salt.
  static Uint8List generateSalt() {
    final salt = Uint8List(32);
    final rng = SecureRandom('Fortuna');
    rng.seed(KeyParameter(Uint8List.fromList(
      List<int>.generate(32, (_) => DateTime.now().microsecondsSinceEpoch & 0xFF),
    )));
    for (int i = 0; i < 32; i++) {
      salt[i] = rng.nextUint8();
    }
    return salt;
  }

  int _log2(int value) {
    int log = 0;
    while (value > 1) {
      value >>= 1;
      log++;
    }
    return log;
  }
}
