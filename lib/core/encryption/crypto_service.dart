import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../utils/constants.dart';

class EncryptedPayload {
  final String ciphertext; // base64(ciphertext + GCM tag)
  final String iv; // base64

  const EncryptedPayload({required this.ciphertext, required this.iv});

  Map<String, String> toMap() => {'ciphertext': ciphertext, 'iv': iv};
}

class AuthenticationException implements Exception {
  final String message;
  const AuthenticationException(this.message);
  @override
  String toString() => 'AuthenticationException: $message';
}

class CryptoService {
  CryptoService._();
  static final CryptoService instance = CryptoService._();

  final _random = Random.secure();

  /// Generate a cryptographically secure 256-bit key
  Uint8List generateRandomKey() {
    return _generateRandomBytes(SecurityConstants.aesKeyLength);
  }

  /// Generate a random 96-bit IV for GCM
  Uint8List generateIV() {
    return _generateRandomBytes(SecurityConstants.gcmIVLength);
  }

  Uint8List _generateRandomBytes(int length) {
    final bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256);
    }
    return bytes;
  }

  /// Encrypt plaintext string with AES-256-GCM.
  /// Returns EncryptedPayload with base64-encoded ciphertext+tag and IV.
  EncryptedPayload encrypt(String plaintext, Uint8List key, Uint8List iv) {
    final plaintextBytes = utf8.encode(plaintext);
    final cipher = GCMBlockCipher(AESEngine());
    final params = AEADParameters(
      KeyParameter(key),
      SecurityConstants.gcmTagLength * 8,
      iv,
      Uint8List(0),
    );
    cipher.init(true, params);

    final output = Uint8List(cipher.getOutputSize(plaintextBytes.length));
    var len = cipher.processBytes(plaintextBytes, 0, plaintextBytes.length, output, 0);
    len += cipher.doFinal(output, len);

    return EncryptedPayload(
      ciphertext: base64.encode(output.sublist(0, len)),
      iv: base64.encode(iv),
    );
  }

  /// Decrypt AES-256-GCM ciphertext. Throws [AuthenticationException] if tampered.
  String decrypt(String ciphertextBase64, Uint8List key, Uint8List iv) {
    try {
      final ciphertextBytes = base64.decode(ciphertextBase64);
      final cipher = GCMBlockCipher(AESEngine());
      final params = AEADParameters(
        KeyParameter(key),
        SecurityConstants.gcmTagLength * 8,
        iv,
        Uint8List(0),
      );
      cipher.init(false, params);

      final output = Uint8List(cipher.getOutputSize(ciphertextBytes.length));
      var len = cipher.processBytes(ciphertextBytes, 0, ciphertextBytes.length, output, 0);
      len += cipher.doFinal(output, len);

      return utf8.decode(output.sublist(0, len));
    } on InvalidCipherTextException catch (e) {
      throw AuthenticationException('Decryption failed: ${e.message}');
    } catch (e) {
      throw AuthenticationException('Decryption failed: $e');
    }
  }

  /// Encrypt raw bytes with AES-256-GCM. Returns ciphertext+tag bytes.
  Uint8List encryptBytes(Uint8List data, Uint8List key, Uint8List iv) {
    final cipher = GCMBlockCipher(AESEngine());
    final params = AEADParameters(
      KeyParameter(key),
      SecurityConstants.gcmTagLength * 8,
      iv,
      Uint8List(0),
    );
    cipher.init(true, params);
    final output = Uint8List(cipher.getOutputSize(data.length));
    var len = cipher.processBytes(data, 0, data.length, output, 0);
    len += cipher.doFinal(output, len);
    return output.sublist(0, len);
  }

  /// Decrypt raw AES-256-GCM bytes. Throws [AuthenticationException] if tampered.
  Uint8List decryptBytes(Uint8List ciphertext, Uint8List key, Uint8List iv) {
    try {
      final cipher = GCMBlockCipher(AESEngine());
      final params = AEADParameters(
        KeyParameter(key),
        SecurityConstants.gcmTagLength * 8,
        iv,
        Uint8List(0),
      );
      cipher.init(false, params);
      final output = Uint8List(cipher.getOutputSize(ciphertext.length));
      var len = cipher.processBytes(ciphertext, 0, ciphertext.length, output, 0);
      len += cipher.doFinal(output, len);
      return output.sublist(0, len);
    } on InvalidCipherTextException catch (e) {
      throw AuthenticationException('Image decryption failed: ${e.message}');
    } catch (e) {
      throw AuthenticationException('Image decryption failed: $e');
    }
  }

  /// Wrap (encrypt) an item key with the KEK.
  EncryptedPayload wrapKey(Uint8List itemKey, Uint8List kek, Uint8List iv) {
    return encrypt(base64.encode(itemKey), kek, iv);
  }

  /// Unwrap (decrypt) an item key using the KEK.
  Uint8List unwrapKey(String wrappedKey, Uint8List kek, Uint8List iv) {
    final decoded = decrypt(wrappedKey, kek, iv);
    return base64.decode(decoded);
  }

  /// Encrypt a vault item's data map and return stored fields.
  Map<String, String> encryptVaultItem(Map<String, dynamic> data, Uint8List kek) {
    final itemKey = generateRandomKey();
    final dataIV = generateIV();
    final keyIV = generateIV();

    final jsonStr = jsonEncode(data);
    final encryptedData = encrypt(jsonStr, itemKey, dataIV);
    final encryptedItemKey = wrapKey(itemKey, kek, keyIV);

    return {
      'encryptedData': encryptedData.ciphertext,
      'dataIV': encryptedData.iv,
      'encryptedItemKey': encryptedItemKey.ciphertext,
      'itemKeyIV': encryptedItemKey.iv,
    };
  }

  /// Decrypt a vault item's data map.
  Map<String, dynamic> decryptVaultItem({
    required String encryptedData,
    required String dataIV,
    required String encryptedItemKey,
    required String itemKeyIV,
    required Uint8List kek,
  }) {
    final itemKey = unwrapKey(encryptedItemKey, kek, base64.decode(itemKeyIV));
    final jsonStr = decrypt(encryptedData, itemKey, base64.decode(dataIV));
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }
}
