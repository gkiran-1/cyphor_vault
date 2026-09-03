import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyphor_vault/core/backup/backup_service.dart';
import 'package:cyphor_vault/core/encryption/crypto_service.dart';
import 'package:cyphor_vault/core/encryption/key_derivation.dart';

void main() {
  group('Backup & Restore Cryptographic Tests', () {
    test('Encrypts and decrypts backup using PIN and Recovery Key', () async {
      final crypto = CryptoService.instance;
      final derive = KeyDerivation.instance;

      final testPin = '123456';
      final testPhrase = 'ABCD-EFGH-JKLM-NPQR-STUV-WXYZ-2345-6789';

      // 1. Simulate active master KEK and profile wrapping
      final kek = crypto.generateRandomKey();
      final pinSalt = KeyDerivation.generateSalt();
      final pinKey = derive.derivePINKey(testPin, pinSalt);
      final pinIV = crypto.generateIV();
      final wrappedByPIN = crypto.wrapKey(kek, pinKey, pinIV);
      final pinHash = base64.encode(pinKey);

      final recoverySalt = KeyDerivation.generateSalt();
      final cleanPhrase = testPhrase.replaceAll('-', '').toUpperCase();
      final recoveryKey = derive.deriveRecoveryKey(cleanPhrase, recoverySalt);
      final recoveryIV = crypto.generateIV();
      final wrappedByRecovery = crypto.wrapKey(kek, recoveryKey, recoveryIV);
      final recoveryHash = derive.deriveRecoveryPhraseHash(cleanPhrase, recoverySalt);

      // 2. Build mock vault data payload
      final mockData = {
        'version': 1,
        'profile': {
          'pinHash': pinHash,
          'pinSalt': base64.encode(pinSalt),
          'wrappedKEK': wrappedByPIN.ciphertext,
          'kekIV': wrappedByPIN.iv,
          'wrappedKEKByRecovery': wrappedByRecovery.ciphertext,
          'recoveryKekIV': wrappedByRecovery.iv,
          'recoveryPhraseHash': recoveryHash,
          'biometricEnabled': false,
          'autoBackupEnabled': false,
          'autoBackupFrequency': 'weekly',
        },
        'salts': {
          'pinSalt': base64.encode(pinSalt),
          'recoverySalt': base64.encode(recoverySalt),
        },
        'documents': [
          {
            'uuid': 'doc-1',
            'documentType': 'id_card',
            'encryptedData': 'enc-doc-data',
            'encryptedItemKey': 'enc-item-key',
            'itemKeyIV': 'item-iv',
            'dataIV': 'data-iv',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        ],
        'notes': [
          {
            'uuid': 'note-1',
            'encryptedData': 'enc-note-data',
            'encryptedItemKey': 'enc-note-key',
            'itemKeyIV': 'note-item-iv',
            'dataIV': 'note-data-iv',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        ],
        'passwords': [
          {
            'uuid': 'pass-1',
            'encryptedData': 'enc-pass-data',
            'encryptedItemKey': 'enc-pass-key',
            'itemKeyIV': 'pass-item-iv',
            'dataIV': 'pass-data-iv',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        ],
        'pages': [
          {
            'uuid': 'page-1',
            'encryptedData': 'enc-page-data',
            'encryptedItemKey': 'enc-page-key',
            'itemKeyIV': 'page-item-iv',
            'dataIV': 'page-data-iv',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        ],
        'images': {
          'doc-image-1.enc': base64.encode(Uint8List.fromList([1, 2, 3, 4, 5])),
        },
      };

      // 3. Encrypt payload with KEK
      final payloadIV = crypto.generateIV();
      final encryptedPayload = crypto.encrypt(jsonEncode(mockData), kek, payloadIV);

      // 4. Construct container
      final container = {
        'format': 'cipherbox',
        'version': 1,
        'app': 'CyphorVault',
        'createdAt': DateTime.now().toIso8601String(),
        'itemCounts': {
          'documents': 1,
          'notes': 1,
          'passwords': 1,
          'pages': 1,
        },
        'auth': {
          'pinSalt': base64.encode(pinSalt),
          'pinHash': pinHash,
          'wrappedKEK': wrappedByPIN.ciphertext,
          'kekIV': wrappedByPIN.iv,
          'recoverySalt': base64.encode(recoverySalt),
          'recoveryPhraseHash': recoveryHash,
          'wrappedKEKByRecovery': wrappedByRecovery.ciphertext,
          'recoveryKekIV': wrappedByRecovery.iv,
        },
        'payloadIV': encryptedPayload.iv,
        'payload': encryptedPayload.ciphertext,
      };

      final tempDir = Directory.systemTemp.createTempSync('backup_test');
      final file = File('${tempDir.path}/test_backup.cipherbox');
      await file.writeAsString(jsonEncode(container));

      // 5. Test reading header
      final header = await BackupService.instance.readBackupHeader(file);
      expect(header.version, 1);
      expect(header.itemCounts['documents'], 1);
      expect(header.itemCounts['notes'], 1);
      expect(header.itemCounts['passwords'], 1);
      expect(header.itemCounts['pages'], 1);
      expect(header.totalItems, 4);
      expect(header.hasPin, true);
      expect(header.hasRecoveryKey, true);

      // 6. Test PIN unwrapping & payload decryption
      final authMap = container['auth'] as Map<String, dynamic>;
      final pSalt = base64.decode(authMap['pinSalt']);
      final derivedPinKey = derive.derivePINKey(testPin, pSalt);
      final unwrappedKekWithPin = crypto.unwrapKey(
        authMap['wrappedKEK'],
        derivedPinKey,
        base64.decode(authMap['kekIV']),
      );
      expect(unwrappedKekWithPin, kek);

      final decryptedWithPin = crypto.decrypt(
        container['payload'] as String,
        unwrappedKekWithPin,
        base64.decode(container['payloadIV'] as String),
      );
      final parsedWithPin = jsonDecode(decryptedWithPin) as Map<String, dynamic>;
      expect(parsedWithPin['documents'].length, 1);
      expect(parsedWithPin['passwords'].length, 1);
      expect(parsedWithPin['notes'].length, 1);
      expect(parsedWithPin['pages'].length, 1);
      expect(parsedWithPin['images']['doc-image-1.enc'], isNotNull);

      // 7. Test Recovery Key unwrapping & payload decryption
      final rSalt = base64.decode(authMap['recoverySalt']);
      final derivedRecKey = derive.deriveRecoveryKey(cleanPhrase, rSalt);
      final unwrappedKekWithRecovery = crypto.unwrapKey(
        authMap['wrappedKEKByRecovery'],
        derivedRecKey,
        base64.decode(authMap['recoveryKekIV']),
      );
      expect(unwrappedKekWithRecovery, kek);

      final decryptedWithRecovery = crypto.decrypt(
        container['payload'] as String,
        unwrappedKekWithRecovery,
        base64.decode(container['payloadIV'] as String),
      );
      final parsedWithRecovery = jsonDecode(decryptedWithRecovery) as Map<String, dynamic>;
      expect(parsedWithRecovery['documents'].length, 1);

      // 8. Test wrong PIN failure
      final wrongPinKey = derive.derivePINKey('000000', pSalt);
      expect(base64.encode(wrongPinKey), isNot(pinHash));
      expect(
        () => crypto.unwrapKey(
          authMap['wrappedKEK'],
          wrongPinKey,
          base64.decode(authMap['kekIV']),
        ),
        throwsA(isA<AuthenticationException>()),
      );

      // 9. Test wrong Recovery Key failure
      final wrongRecKey = derive.deriveRecoveryKey('WRONG-PHRASE-1234-5678-9012-3456-7890-ABCD', rSalt);
      expect(
        () => crypto.unwrapKey(
          authMap['wrappedKEKByRecovery'],
          wrongRecKey,
          base64.decode(authMap['recoveryKekIV']),
        ),
        throwsA(isA<AuthenticationException>()),
      );

      // Cleanup
      tempDir.deleteSync(recursive: true);
    });

    test('computeContentHash generates deterministic SHA-256 and detects updates', () {
      final itemA1 = {
        'title': 'Original Note',
        'content': 'Meeting notes content',
        'category': 'note',
      };
      // Same content with keys in different order
      final itemA2 = {
        'category': 'note',
        'title': 'Original Note',
        'content': 'Meeting notes content',
      };
      // Same content with transient metadata
      final itemA3 = {
        'title': 'Original Note',
        'content': 'Meeting notes content',
        'category': 'note',
        'updatedAt': '2026-09-03T10:00:00Z',
        'uuid': 'some-uuid-123',
        'id': 42,
      };

      final hashA1 = BackupService.computeContentHash(itemA1);
      final hashA2 = BackupService.computeContentHash(itemA2);
      final hashA3 = BackupService.computeContentHash(itemA3);

      expect(hashA1, hashA2, reason: 'Key order should not affect content hash');
      expect(hashA1, hashA3, reason: 'Transient fields should not affect content hash');

      // Renamed title -> hash must change
      final itemRenamed = {
        'title': 'Renamed Note',
        'content': 'Meeting notes content',
        'category': 'note',
      };
      final hashRenamed = BackupService.computeContentHash(itemRenamed);
      expect(hashRenamed, isNot(hashA1), reason: 'Renaming title must produce a different hash');

      // Modified body -> hash must change
      final itemEdited = {
        'title': 'Original Note',
        'content': 'Updated meeting notes content',
        'category': 'note',
      };
      final hashEdited = BackupService.computeContentHash(itemEdited);
      expect(hashEdited, isNot(hashA1), reason: 'Editing content must produce a different hash');
    });
  });
}
