import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../database/collections/backup_log.dart';
import '../database/collections/document_entry.dart';
import '../database/collections/note_entry.dart';
import '../database/collections/page_entry.dart';
import '../database/collections/password_entry.dart';
import '../database/collections/user_profile.dart';
import '../database/isar_service.dart';
import '../encryption/crypto_service.dart';
import '../encryption/key_derivation.dart';
import '../encryption/key_manager.dart';
import '../storage/encrypted_image_store.dart';

class BackupHeaderInfo {
  final int version;
  final DateTime createdAt;
  final Map<String, int> itemCounts;
  final int fileSize;
  final bool hasPin;
  final bool hasRecoveryKey;

  const BackupHeaderInfo({
    required this.version,
    required this.createdAt,
    required this.itemCounts,
    required this.fileSize,
    required this.hasPin,
    required this.hasRecoveryKey,
  });

  int get totalItems =>
      (itemCounts['documents'] ?? 0) +
      (itemCounts['passwords'] ?? 0) +
      (itemCounts['notes'] ?? 0) +
      (itemCounts['pages'] ?? 0);
}

class BackupResult {
  final File file;
  final BackupLog log;
  final int totalItems;

  const BackupResult({
    required this.file,
    required this.log,
    required this.totalItems,
  });
}

class RestoreResult {
  final int documentCount;
  final int noteCount;
  final int passwordCount;
  final int pageCount;
  final int imageCount;

  const RestoreResult({
    required this.documentCount,
    required this.noteCount,
    required this.passwordCount,
    required this.pageCount,
    required this.imageCount,
  });

  int get totalItems => documentCount + noteCount + passwordCount + pageCount;
}

enum ImportConflictResolution {
  keepBoth,
  overwrite,
  skip,
}

class MergeResult {
  final int documentCount;
  final int noteCount;
  final int passwordCount;
  final int pageCount;
  final int imageCount;
  final int updatedCount;
  final int skippedCount;

  const MergeResult({
    required this.documentCount,
    required this.noteCount,
    required this.passwordCount,
    required this.pageCount,
    required this.imageCount,
    this.updatedCount = 0,
    this.skippedCount = 0,
  });

  int get totalItems => documentCount + noteCount + passwordCount + pageCount;
}

class BackupService {
  BackupService._();
  static final BackupService instance = BackupService._();

  /// Reads directory where encrypted document images are stored.
  Future<Directory> _getImagesDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/doc_images');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Creates a single encrypted .cipherbox backup file of all vault data.
  Future<File> createBackupFile() async {
    final kek = KeyManager.instance.currentKEK;
    if (kek == null) {
      throw StateError('Vault is locked. Unlock the vault to create a backup.');
    }

    final isar = IsarService.instance;
    final profile = await isar.getUserProfile();
    if (profile == null) {
      throw StateError('No user profile found.');
    }

    final pinSalt = await KeyManager.instance.getPinSalt() ??
        (profile.pinSalt.isNotEmpty ? base64.decode(profile.pinSalt) : null);
    final recoverySalt = await KeyManager.instance.getRecoverySalt();

    if (pinSalt == null) {
      throw StateError('PIN salt not found.');
    }

    // Read all collections
    final documents = await isar.getAllDocuments();
    final notes = await isar.getAllNotes();
    final passwords = await isar.getAllPasswords();
    final pages = await isar.getAllPages();

    // Read all encrypted image files in doc_images
    final imagesDir = await _getImagesDir();
    final imagesMap = <String, String>{};
    if (await imagesDir.exists()) {
      final imageEntities = imagesDir.listSync();
      for (final entity in imageEntities) {
        if (entity is File && entity.path.endsWith('.enc')) {
          final fileName = entity.uri.pathSegments.last;
          final bytes = await entity.readAsBytes();
          imagesMap[fileName] = base64.encode(bytes);
        }
      }
    }

    // Build the inner unencrypted payload map
    final now = DateTime.now().toUtc();
    final payloadMap = {
      'version': 1,
      'createdAt': now.toIso8601String(),
      'profile': {
        'pinHash': profile.pinHash,
        'pinSalt': profile.pinSalt,
        'wrappedKEK': profile.wrappedKEK,
        'kekIV': profile.kekIV,
        'wrappedKEKByRecovery': profile.wrappedKEKByRecovery,
        'recoveryKekIV': profile.recoveryKekIV,
        'recoveryPhraseHash': profile.recoveryPhraseHash,
        'biometricEnabled': profile.biometricEnabled,
        'autoBackupEnabled': profile.autoBackupEnabled,
        'autoBackupFrequency': profile.autoBackupFrequency,
        'createdAt': profile.createdAt.toIso8601String(),
        'updatedAt': profile.updatedAt.toIso8601String(),
      },
      'salts': {
        'pinSalt': base64.encode(pinSalt),
        'recoverySalt': recoverySalt != null ? base64.encode(recoverySalt) : '',
      },
      'documents': documents
          .map((e) => {
                'uuid': e.uuid,
                'documentType': e.documentType,
                'encryptedData': e.encryptedData,
                'encryptedItemKey': e.encryptedItemKey,
                'itemKeyIV': e.itemKeyIV,
                'dataIV': e.dataIV,
                'createdAt': e.createdAt.toIso8601String(),
                'updatedAt': e.updatedAt.toIso8601String(),
              })
          .toList(),
      'notes': notes
          .map((e) => {
                'uuid': e.uuid,
                'encryptedData': e.encryptedData,
                'encryptedItemKey': e.encryptedItemKey,
                'itemKeyIV': e.itemKeyIV,
                'dataIV': e.dataIV,
                'createdAt': e.createdAt.toIso8601String(),
                'updatedAt': e.updatedAt.toIso8601String(),
              })
          .toList(),
      'passwords': passwords
          .map((e) => {
                'uuid': e.uuid,
                'encryptedData': e.encryptedData,
                'encryptedItemKey': e.encryptedItemKey,
                'itemKeyIV': e.itemKeyIV,
                'dataIV': e.dataIV,
                'createdAt': e.createdAt.toIso8601String(),
                'updatedAt': e.updatedAt.toIso8601String(),
              })
          .toList(),
      'pages': pages
          .map((e) => {
                'uuid': e.uuid,
                'encryptedData': e.encryptedData,
                'encryptedItemKey': e.encryptedItemKey,
                'itemKeyIV': e.itemKeyIV,
                'dataIV': e.dataIV,
                'createdAt': e.createdAt.toIso8601String(),
                'updatedAt': e.updatedAt.toIso8601String(),
              })
          .toList(),
      'images': imagesMap,
    };

    final payloadJson = jsonEncode(payloadMap);
    final payloadIV = CryptoService.instance.generateIV();
    final encryptedPayload = CryptoService.instance.encrypt(
      payloadJson,
      kek,
      payloadIV,
    );

    // Build the outer container
    final containerMap = {
      'format': 'cipherbox',
      'version': 1,
      'app': 'CyphorVault',
      'createdAt': now.toIso8601String(),
      'itemCounts': {
        'documents': documents.length,
        'notes': notes.length,
        'passwords': passwords.length,
        'pages': pages.length,
      },
      'auth': {
        'pinSalt': base64.encode(pinSalt),
        'pinHash': profile.pinHash,
        'wrappedKEK': profile.wrappedKEK,
        'kekIV': profile.kekIV,
        'recoverySalt':
            recoverySalt != null ? base64.encode(recoverySalt) : '',
        'recoveryPhraseHash': profile.recoveryPhraseHash,
        'wrappedKEKByRecovery': profile.wrappedKEKByRecovery,
        'recoveryKekIV': profile.recoveryKekIV,
      },
      'payloadIV': encryptedPayload.iv,
      'payload': encryptedPayload.ciphertext,
    };

    final tempDir = await getTemporaryDirectory();
    final timestamp = now.toIso8601String().replaceAll(':', '-').split('.').first;
    final filePath = '${tempDir.path}/CyphorVault_Backup_$timestamp.cipherbox';
    final file = File(filePath);
    await file.writeAsString(jsonEncode(containerMap), flush: true);

    return file;
  }

  /// Gets the public Downloads directory or a sensible fallback directory.
  Future<Directory> getPublicDownloadsDirectory() async {
    if (Platform.isAndroid) {
      final androidDownloads = Directory('/storage/emulated/0/Download');
      if (androidDownloads.existsSync()) {
        return androidDownloads;
      }
    }
    final dir = await getDownloadsDirectory();
    if (dir != null && dir.existsSync()) {
      return dir;
    }
    return await getApplicationDocumentsDirectory();
  }

  /// Exports backup by saving to Downloads or a user-selected folder.
  Future<BackupResult> exportBackup({
    String? targetDirectoryPath,
  }) async {
    final tempFile = await createBackupFile();
    final fileName = tempFile.path.split('/').last;

    Directory targetDir;
    String destinationLabel = 'Downloads';

    if (targetDirectoryPath != null && targetDirectoryPath.trim().isNotEmpty) {
      targetDir = Directory(targetDirectoryPath.trim());
      if (!targetDir.existsSync()) {
        await targetDir.create(recursive: true);
      }
      destinationLabel = 'Custom Folder';
    } else {
      targetDir = await getPublicDownloadsDirectory();
      if (!targetDir.existsSync()) {
        await targetDir.create(recursive: true);
      }
    }

    final destPath = '${targetDir.path}/$fileName';
    final savedFile = await tempFile.copy(destPath);
    final fileSize = await savedFile.length();

    // Read item counts for log
    final counts = await IsarService.instance.getItemCounts();
    final totalItems = counts.values.fold<int>(0, (a, b) => a + b);

    final now = DateTime.now();
    final log = BackupLog()
      ..backupDate = now
      ..fileSize = fileSize
      ..itemCount = totalItems
      ..status = 'success'
      ..destination = destinationLabel;

    await IsarService.instance.saveBackupLog(log);

    // Update last backup date on user profile
    final profile = await IsarService.instance.getUserProfile();
    if (profile != null) {
      profile.lastBackupDate = now;
      profile.updatedAt = now;
      await IsarService.instance.saveUserProfile(profile);
    }

    return BackupResult(file: savedFile, log: log, totalItems: totalItems);
  }

  /// Reads the unencrypted header info from a .cipherbox backup file.
  Future<BackupHeaderInfo> readBackupHeader(File file) async {
    final content = await file.readAsString();
    final dynamic json = jsonDecode(content);

    if (json is! Map<String, dynamic> || json['format'] != 'cipherbox') {
      throw const FormatException('Selected file is not a valid Cyphor Vault backup (.cipherbox).');
    }

    final version = json['version'] as int? ?? 1;
    final createdAtStr = json['createdAt'] as String? ?? '';
    final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
    final countsRaw = json['itemCounts'] as Map<String, dynamic>? ?? {};
    final counts = {
      'documents': (countsRaw['documents'] as num?)?.toInt() ?? 0,
      'passwords': (countsRaw['passwords'] as num?)?.toInt() ?? 0,
      'notes': (countsRaw['notes'] as num?)?.toInt() ?? 0,
      'pages': (countsRaw['pages'] as num?)?.toInt() ?? 0,
    };

    final auth = json['auth'] as Map<String, dynamic>? ?? {};
    final hasPin = (auth['wrappedKEK'] as String?)?.isNotEmpty == true &&
        (auth['pinSalt'] as String?)?.isNotEmpty == true;
    final hasRecoveryKey =
        (auth['wrappedKEKByRecovery'] as String?)?.isNotEmpty == true &&
            (auth['recoverySalt'] as String?)?.isNotEmpty == true;

    final fileSize = await file.length();

    return BackupHeaderInfo(
      version: version,
      createdAt: createdAt,
      itemCounts: counts,
      fileSize: fileSize,
      hasPin: hasPin,
      hasRecoveryKey: hasRecoveryKey,
    );
  }

  /// Restores the entire vault from a .cipherbox backup file using either PIN or Recovery Key.
  Future<RestoreResult> restoreFromBackup({
    required File file,
    String? pin,
    String? recoveryPhrase,
  }) async {
    if ((pin == null || pin.isEmpty) &&
        (recoveryPhrase == null || recoveryPhrase.isEmpty)) {
      throw ArgumentError('You must provide either the PIN or the Recovery Key.');
    }

    final content = await file.readAsString();
    final dynamic json = jsonDecode(content);

    if (json is! Map<String, dynamic> || json['format'] != 'cipherbox') {
      throw const FormatException('Invalid backup file format.');
    }

    final auth = json['auth'] as Map<String, dynamic>?;
    if (auth == null) {
      throw const FormatException('Backup security metadata missing.');
    }

    final payloadIVStr = json['payloadIV'] as String?;
    final payloadCiphertext = json['payload'] as String?;
    if (payloadIVStr == null || payloadCiphertext == null) {
      throw const FormatException('Backup payload is corrupted or missing.');
    }

    final crypto = CryptoService.instance;
    final derive = KeyDerivation.instance;
    Uint8List? kek;
    Uint8List? restoredPinSalt;
    Uint8List? restoredRecoverySalt;

    // Try PIN unlock if PIN is provided
    if (pin != null && pin.isNotEmpty) {
      final pinSaltStr = auth['pinSalt'] as String?;
      final wrappedKEK = auth['wrappedKEK'] as String?;
      final kekIVStr = auth['kekIV'] as String?;

      if (pinSaltStr == null || wrappedKEK == null || kekIVStr == null) {
        throw const FormatException('PIN authentication data missing from backup.');
      }

      final pinSalt = base64.decode(pinSaltStr);
      final pinKey = derive.derivePINKey(pin, pinSalt);

      try {
        final kekIV = base64.decode(kekIVStr);
        kek = crypto.unwrapKey(wrappedKEK, pinKey, kekIV);
        restoredPinSalt = pinSalt;
      } catch (_) {
        throw const AuthenticationException('Incorrect PIN for this backup.');
      }
    }

    // Try Recovery Key unlock if PIN was not provided or failed
    if (kek == null && recoveryPhrase != null && recoveryPhrase.isNotEmpty) {
      final recoverySaltStr = auth['recoverySalt'] as String?;
      final wrappedKEKByRecovery = auth['wrappedKEKByRecovery'] as String?;
      final recoveryKekIVStr = auth['recoveryKekIV'] as String?;

      if (recoverySaltStr == null ||
          wrappedKEKByRecovery == null ||
          recoveryKekIVStr == null) {
        throw const FormatException('Recovery key authentication data missing from backup.');
      }

      final cleanPhrase =
          recoveryPhrase.trim().replaceAll('-', '').toUpperCase();
      final recoverySalt = base64.decode(recoverySaltStr);

      try {
        final recoveryKey = derive.deriveRecoveryKey(cleanPhrase, recoverySalt);
        final recoveryKekIV = base64.decode(recoveryKekIVStr);
        kek = crypto.unwrapKey(wrappedKEKByRecovery, recoveryKey, recoveryKekIV);
        restoredRecoverySalt = recoverySalt;
      } catch (_) {
        throw const AuthenticationException('Invalid Recovery Key for this backup.');
      }
    }

    if (kek == null) {
      throw const AuthenticationException('Authentication failed. Please check your credentials.');
    }

    // Decrypt the main payload
    String decryptedPayloadJson;
    try {
      final payloadIV = base64.decode(payloadIVStr);
      decryptedPayloadJson = crypto.decrypt(payloadCiphertext, kek, payloadIV);
    } catch (e) {
      throw AuthenticationException('Decryption failed. The backup file may be corrupted: $e');
    }

    final dynamic payloadData = jsonDecode(decryptedPayloadJson);
    if (payloadData is! Map<String, dynamic>) {
      throw const FormatException('Malformed payload in backup.');
    }

    final isar = IsarService.instance;

    // Clear existing data before restoring
    await isar.deleteAllData();

    // Restore profile
    final profileData = payloadData['profile'] as Map<String, dynamic>?;
    if (profileData != null) {
      final profile = UserProfile()
        ..pinHash = profileData['pinHash'] as String? ?? ''
        ..pinSalt = profileData['pinSalt'] as String? ?? ''
        ..wrappedKEK = profileData['wrappedKEK'] as String? ?? ''
        ..kekIV = profileData['kekIV'] as String? ?? ''
        ..wrappedKEKByRecovery = profileData['wrappedKEKByRecovery'] as String? ?? ''
        ..recoveryKekIV = profileData['recoveryKekIV'] as String? ?? ''
        ..recoveryPhraseHash = profileData['recoveryPhraseHash'] as String? ?? ''
        ..biometricEnabled = false // Reset biometric until user re-enables on device
        ..autoBackupEnabled = profileData['autoBackupEnabled'] as bool? ?? false
        ..autoBackupFrequency = profileData['autoBackupFrequency'] as String? ?? 'weekly'
        ..lastBackupDate = DateTime.now()
        ..createdAt = DateTime.tryParse(profileData['createdAt'] as String? ?? '') ?? DateTime.now()
        ..updatedAt = DateTime.now();

      await isar.saveUserProfile(profile);
    }

    // Restore salts
    final saltsData = payloadData['salts'] as Map<String, dynamic>?;
    if (saltsData != null) {
      final pSaltB64 = saltsData['pinSalt'] as String?;
      final rSaltB64 = saltsData['recoverySalt'] as String?;

      final pSalt = pSaltB64 != null && pSaltB64.isNotEmpty
          ? base64.decode(pSaltB64)
          : (restoredPinSalt ?? (profileData != null ? base64.decode(profileData['pinSalt']) : null));

      final rSalt = rSaltB64 != null && rSaltB64.isNotEmpty
          ? base64.decode(rSaltB64)
          : restoredRecoverySalt;

      if (pSalt != null) {
        await KeyManager.instance.saveSalts(
          pinSalt: pSalt,
          recoverySalt: rSalt ?? Uint8List(0),
        );
      }
    }

    // Restore Documents
    final documentsList = payloadData['documents'] as List<dynamic>? ?? [];
    for (final item in documentsList) {
      if (item is Map<String, dynamic>) {
        final doc = DocumentEntry()
          ..uuid = item['uuid'] as String? ?? ''
          ..documentType = item['documentType'] as String? ?? 'other'
          ..encryptedData = item['encryptedData'] as String? ?? ''
          ..encryptedItemKey = item['encryptedItemKey'] as String? ?? ''
          ..itemKeyIV = item['itemKeyIV'] as String? ?? ''
          ..dataIV = item['dataIV'] as String? ?? ''
          ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.tryParse(item['updatedAt'] as String? ?? '') ?? DateTime.now();
        await isar.saveDocument(doc);
      }
    }

    // Restore Notes
    final notesList = payloadData['notes'] as List<dynamic>? ?? [];
    for (final item in notesList) {
      if (item is Map<String, dynamic>) {
        final note = NoteEntry()
          ..uuid = item['uuid'] as String? ?? ''
          ..encryptedData = item['encryptedData'] as String? ?? ''
          ..encryptedItemKey = item['encryptedItemKey'] as String? ?? ''
          ..itemKeyIV = item['itemKeyIV'] as String? ?? ''
          ..dataIV = item['dataIV'] as String? ?? ''
          ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.tryParse(item['updatedAt'] as String? ?? '') ?? DateTime.now();
        await isar.saveNote(note);
      }
    }

    // Restore Passwords
    final passwordsList = payloadData['passwords'] as List<dynamic>? ?? [];
    for (final item in passwordsList) {
      if (item is Map<String, dynamic>) {
        final pass = PasswordEntry()
          ..uuid = item['uuid'] as String? ?? ''
          ..encryptedData = item['encryptedData'] as String? ?? ''
          ..encryptedItemKey = item['encryptedItemKey'] as String? ?? ''
          ..itemKeyIV = item['itemKeyIV'] as String? ?? ''
          ..dataIV = item['dataIV'] as String? ?? ''
          ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.tryParse(item['updatedAt'] as String? ?? '') ?? DateTime.now();
        await isar.savePassword(pass);
      }
    }

    // Restore Pages
    final pagesList = payloadData['pages'] as List<dynamic>? ?? [];
    for (final item in pagesList) {
      if (item is Map<String, dynamic>) {
        final page = PageEntry()
          ..uuid = item['uuid'] as String? ?? ''
          ..encryptedData = item['encryptedData'] as String? ?? ''
          ..encryptedItemKey = item['encryptedItemKey'] as String? ?? ''
          ..itemKeyIV = item['itemKeyIV'] as String? ?? ''
          ..dataIV = item['dataIV'] as String? ?? ''
          ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.tryParse(item['updatedAt'] as String? ?? '') ?? DateTime.now();
        await isar.savePage(page);
      }
    }

    // Restore encrypted image files
    final imagesMap = payloadData['images'] as Map<String, dynamic>? ?? {};
    final imagesDir = await _getImagesDir();
    for (final entry in imagesMap.entries) {
      final fileName = entry.key;
      final b64 = entry.value as String?;
      if (b64 != null && b64.isNotEmpty) {
        final bytes = base64.decode(b64);
        final imgFile = File('${imagesDir.path}/$fileName');
        await imgFile.writeAsBytes(bytes, flush: true);
      }
    }

    // Set KeyManager unlocked KEK
    KeyManager.instance.setUnlockedKEK(kek);

    // Save restore log
    final fileSize = await file.length();
    final totalItems = documentsList.length + notesList.length + passwordsList.length + pagesList.length;
    final log = BackupLog()
      ..backupDate = DateTime.now()
      ..fileSize = fileSize
      ..itemCount = totalItems
      ..status = 'success'
      ..destination = 'Local Import';
    await isar.saveBackupLog(log);

    return RestoreResult(
      documentCount: documentsList.length,
      noteCount: notesList.length,
      passwordCount: passwordsList.length,
      pageCount: pagesList.length,
      imageCount: imagesMap.length,
    );
  }

  /// Imports and merges vault data from a .cipherbox backup without resetting current data.
  Future<MergeResult> mergeFromBackup({
    required File file,
    String? pin,
    String? recoveryPhrase,
    ImportConflictResolution conflictResolution = ImportConflictResolution.keepBoth,
  }) async {
    final activeKek = KeyManager.instance.currentKEK;
    if (activeKek == null) {
      throw StateError('Vault must be unlocked to import and merge backup data.');
    }

    if ((pin == null || pin.isEmpty) &&
        (recoveryPhrase == null || recoveryPhrase.isEmpty)) {
      throw ArgumentError('You must provide either the PIN or the Recovery Key.');
    }

    final content = await file.readAsString();
    final dynamic json = jsonDecode(content);

    if (json is! Map<String, dynamic> || json['format'] != 'cipherbox') {
      throw const FormatException('Invalid backup file format.');
    }

    final auth = json['auth'] as Map<String, dynamic>?;
    if (auth == null) {
      throw const FormatException('Backup security metadata missing.');
    }

    final payloadIVStr = json['payloadIV'] as String?;
    final payloadCiphertext = json['payload'] as String?;
    if (payloadIVStr == null || payloadCiphertext == null) {
      throw const FormatException('Backup payload is corrupted or missing.');
    }

    final crypto = CryptoService.instance;
    final derive = KeyDerivation.instance;
    Uint8List? backupKek;

    // 1. Authenticate with PIN or Recovery Key to get backupKek
    if (pin != null && pin.isNotEmpty) {
      final pinSaltStr = auth['pinSalt'] as String?;
      final wrappedKEK = auth['wrappedKEK'] as String?;
      final kekIVStr = auth['kekIV'] as String?;

      if (pinSaltStr == null || wrappedKEK == null || kekIVStr == null) {
        throw const FormatException('PIN authentication data missing from backup.');
      }

      final pinSalt = base64.decode(pinSaltStr);
      final pinKey = derive.derivePINKey(pin, pinSalt);

      try {
        final kekIV = base64.decode(kekIVStr);
        backupKek = crypto.unwrapKey(wrappedKEK, pinKey, kekIV);
      } catch (_) {
        throw const AuthenticationException('Incorrect PIN for this backup.');
      }
    }

    if (backupKek == null && recoveryPhrase != null && recoveryPhrase.isNotEmpty) {
      final recoverySaltStr = auth['recoverySalt'] as String?;
      final wrappedKEKByRecovery = auth['wrappedKEKByRecovery'] as String?;
      final recoveryKekIVStr = auth['recoveryKekIV'] as String?;

      if (recoverySaltStr == null ||
          wrappedKEKByRecovery == null ||
          recoveryKekIVStr == null) {
        throw const FormatException('Recovery key authentication data missing from backup.');
      }

      final cleanPhrase =
          recoveryPhrase.trim().replaceAll('-', '').toUpperCase();
      final recoverySalt = base64.decode(recoverySaltStr);

      try {
        final recoveryKey = derive.deriveRecoveryKey(cleanPhrase, recoverySalt);
        final recoveryKekIV = base64.decode(recoveryKekIVStr);
        backupKek = crypto.unwrapKey(wrappedKEKByRecovery, recoveryKey, recoveryKekIV);
      } catch (_) {
        throw const AuthenticationException('Invalid Recovery Key for this backup.');
      }
    }

    if (backupKek == null) {
      throw const AuthenticationException('Authentication failed. Please check your credentials.');
    }

    // 2. Decrypt main payload using backupKek
    final payloadIV = base64.decode(payloadIVStr);
    final decryptedPayloadJson = crypto.decrypt(payloadCiphertext, backupKek, payloadIV);
    final payloadData = jsonDecode(decryptedPayloadJson) as Map<String, dynamic>;

    // 3. Write image files from backup to disk
    final imagesMap = payloadData['images'] as Map<String, dynamic>? ?? {};
    final imagesDir = await _getImagesDir();
    for (final entry in imagesMap.entries) {
      final fileName = entry.key;
      final b64 = entry.value as String?;
      if (b64 != null && b64.isNotEmpty) {
        final bytes = base64.decode(b64);
        final imgFile = File('${imagesDir.path}/$fileName');
        if (!await imgFile.exists()) {
          await imgFile.writeAsBytes(bytes, flush: true);
        }
      }
    }

    final isar = IsarService.instance;
    final existingDocs = await isar.getAllDocuments();
    final existingNotes = await isar.getAllNotes();
    final existingPasswords = await isar.getAllPasswords();
    final existingPages = await isar.getAllPages();

    // Index existing items by UUID and decrypted title/name
    final existingDocMap = <String, DocumentEntry>{};
    final existingDocTitleMap = <String, DocumentEntry>{};
    for (final doc in existingDocs) {
      existingDocMap[doc.uuid] = doc;
      try {
        final d = crypto.decryptVaultItem(
          encryptedData: doc.encryptedData,
          dataIV: doc.dataIV,
          encryptedItemKey: doc.encryptedItemKey,
          itemKeyIV: doc.itemKeyIV,
          kek: activeKek,
        );
        final title = (d['name'] as String? ?? d['title'] as String? ?? '').trim().toLowerCase();
        if (title.isNotEmpty) existingDocTitleMap[title] = doc;
      } catch (_) {}
    }

    final existingNoteMap = <String, NoteEntry>{};
    final existingNoteTitleMap = <String, NoteEntry>{};
    for (final note in existingNotes) {
      existingNoteMap[note.uuid] = note;
      try {
        final d = crypto.decryptVaultItem(
          encryptedData: note.encryptedData,
          dataIV: note.dataIV,
          encryptedItemKey: note.encryptedItemKey,
          itemKeyIV: note.itemKeyIV,
          kek: activeKek,
        );
        final title = (d['title'] as String? ?? '').trim().toLowerCase();
        if (title.isNotEmpty) existingNoteTitleMap[title] = note;
      } catch (_) {}
    }

    final existingPassMap = <String, PasswordEntry>{};
    final existingPassTitleMap = <String, PasswordEntry>{};
    for (final pass in existingPasswords) {
      existingPassMap[pass.uuid] = pass;
      try {
        final d = crypto.decryptVaultItem(
          encryptedData: pass.encryptedData,
          dataIV: pass.dataIV,
          encryptedItemKey: pass.encryptedItemKey,
          itemKeyIV: pass.itemKeyIV,
          kek: activeKek,
        );
        final title = (d['title'] as String? ?? d['service'] as String? ?? '').trim().toLowerCase();
        if (title.isNotEmpty) existingPassTitleMap[title] = pass;
      } catch (_) {}
    }

    final existingPageMap = <String, PageEntry>{};
    final existingPageTitleMap = <String, PageEntry>{};
    for (final page in existingPages) {
      existingPageMap[page.uuid] = page;
      try {
        final d = crypto.decryptVaultItem(
          encryptedData: page.encryptedData,
          dataIV: page.dataIV,
          encryptedItemKey: page.encryptedItemKey,
          itemKeyIV: page.itemKeyIV,
          kek: activeKek,
        );
        final title = (d['title'] as String? ?? '').trim().toLowerCase();
        if (title.isNotEmpty) existingPageTitleMap[title] = page;
      } catch (_) {}
    }

    int importedDocs = 0;
    int importedNotes = 0;
    int importedPasswords = 0;
    int importedPages = 0;
    int updatedCount = 0;
    int skippedCount = 0;

    // 4. Merge Documents
    final documentsList = payloadData['documents'] as List<dynamic>? ?? [];
    for (final item in documentsList) {
      if (item is Map<String, dynamic>) {
        try {
          final data = crypto.decryptVaultItem(
            encryptedData: item['encryptedData'] as String,
            dataIV: item['dataIV'] as String,
            encryptedItemKey: item['encryptedItemKey'] as String,
            itemKeyIV: item['itemKeyIV'] as String,
            kek: backupKek,
          );

          final rawTitle = (data['name'] as String? ?? data['title'] as String? ?? '').trim();
          final lowerTitle = rawTitle.toLowerCase();
          final incomingUuid = item['uuid'] as String? ?? const Uuid().v4();

          final existingByUuid = existingDocMap[incomingUuid];
          final existingByTitle = lowerTitle.isNotEmpty ? existingDocTitleMap[lowerTitle] : null;
          final hasConflict = existingByUuid != null || existingByTitle != null;

          if (hasConflict && conflictResolution == ImportConflictResolution.skip) {
            skippedCount++;
            continue;
          }

          // Re-wrap any encrypted images with activeKek
          for (final key in ['imageFrontRef', 'imageBackRef']) {
            final ref = data[key];
            if (ref is Map) {
              try {
                final imgBytes = await EncryptedImageStore.instance.load(
                  Map<String, dynamic>.from(ref),
                  backupKek,
                );
                final newRef = await EncryptedImageStore.instance.save(imgBytes, activeKek);
                data[key] = newRef;
              } catch (_) {}
            }
          }

          if (hasConflict && conflictResolution == ImportConflictResolution.overwrite) {
            final target = existingByUuid ?? existingByTitle!;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = DocumentEntry()
              ..id = target.id
              ..uuid = target.uuid
              ..documentType = item['documentType'] as String? ?? target.documentType
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = target.createdAt
              ..updatedAt = DateTime.now();

            await isar.saveDocument(entry);
            updatedCount++;
            importedDocs++;
          } else {
            // keepBoth or no conflict
            if (hasConflict && conflictResolution == ImportConflictResolution.keepBoth) {
              final titleKey = data.containsKey('name') ? 'name' : 'title';
              data[titleKey] = rawTitle.isNotEmpty ? '$rawTitle (Imported)' : 'Document (Imported)';
            }

            final newUuid = hasConflict ? const Uuid().v4() : incomingUuid;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = DocumentEntry()
              ..uuid = newUuid
              ..documentType = item['documentType'] as String? ?? 'other'
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
              ..updatedAt = DateTime.now();

            await isar.saveDocument(entry);
            importedDocs++;
          }
        } catch (_) {}
      }
    }

    // 5. Merge Notes
    final notesList = payloadData['notes'] as List<dynamic>? ?? [];
    for (final item in notesList) {
      if (item is Map<String, dynamic>) {
        try {
          final data = crypto.decryptVaultItem(
            encryptedData: item['encryptedData'] as String,
            dataIV: item['dataIV'] as String,
            encryptedItemKey: item['encryptedItemKey'] as String,
            itemKeyIV: item['itemKeyIV'] as String,
            kek: backupKek,
          );

          final rawTitle = (data['title'] as String? ?? '').trim();
          final lowerTitle = rawTitle.toLowerCase();
          final incomingUuid = item['uuid'] as String? ?? const Uuid().v4();

          final existingByUuid = existingNoteMap[incomingUuid];
          final existingByTitle = lowerTitle.isNotEmpty ? existingNoteTitleMap[lowerTitle] : null;
          final hasConflict = existingByUuid != null || existingByTitle != null;

          if (hasConflict && conflictResolution == ImportConflictResolution.skip) {
            skippedCount++;
            continue;
          }

          if (hasConflict && conflictResolution == ImportConflictResolution.overwrite) {
            final target = existingByUuid ?? existingByTitle!;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = NoteEntry()
              ..id = target.id
              ..uuid = target.uuid
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = target.createdAt
              ..updatedAt = DateTime.now();

            await isar.saveNote(entry);
            updatedCount++;
            importedNotes++;
          } else {
            if (hasConflict && conflictResolution == ImportConflictResolution.keepBoth) {
              data['title'] = rawTitle.isNotEmpty ? '$rawTitle (Imported)' : 'Untitled (Imported)';
            }

            final newUuid = hasConflict ? const Uuid().v4() : incomingUuid;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = NoteEntry()
              ..uuid = newUuid
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
              ..updatedAt = DateTime.now();

            await isar.saveNote(entry);
            importedNotes++;
          }
        } catch (_) {}
      }
    }

    // 6. Merge Passwords
    final passwordsList = payloadData['passwords'] as List<dynamic>? ?? [];
    for (final item in passwordsList) {
      if (item is Map<String, dynamic>) {
        try {
          final data = crypto.decryptVaultItem(
            encryptedData: item['encryptedData'] as String,
            dataIV: item['dataIV'] as String,
            encryptedItemKey: item['encryptedItemKey'] as String,
            itemKeyIV: item['itemKeyIV'] as String,
            kek: backupKek,
          );

          final rawTitle = (data['title'] as String? ?? data['service'] as String? ?? '').trim();
          final lowerTitle = rawTitle.toLowerCase();
          final incomingUuid = item['uuid'] as String? ?? const Uuid().v4();

          final existingByUuid = existingPassMap[incomingUuid];
          final existingByTitle = lowerTitle.isNotEmpty ? existingPassTitleMap[lowerTitle] : null;
          final hasConflict = existingByUuid != null || existingByTitle != null;

          if (hasConflict && conflictResolution == ImportConflictResolution.skip) {
            skippedCount++;
            continue;
          }

          if (hasConflict && conflictResolution == ImportConflictResolution.overwrite) {
            final target = existingByUuid ?? existingByTitle!;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = PasswordEntry()
              ..id = target.id
              ..uuid = target.uuid
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = target.createdAt
              ..updatedAt = DateTime.now();

            await isar.savePassword(entry);
            updatedCount++;
            importedPasswords++;
          } else {
            if (hasConflict && conflictResolution == ImportConflictResolution.keepBoth) {
              final titleKey = data.containsKey('title') ? 'title' : 'service';
              data[titleKey] = rawTitle.isNotEmpty ? '$rawTitle (Imported)' : 'Password (Imported)';
            }

            final newUuid = hasConflict ? const Uuid().v4() : incomingUuid;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = PasswordEntry()
              ..uuid = newUuid
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
              ..updatedAt = DateTime.now();

            await isar.savePassword(entry);
            importedPasswords++;
          }
        } catch (_) {}
      }
    }

    // 7. Merge Pages
    final pagesList = payloadData['pages'] as List<dynamic>? ?? [];
    for (final item in pagesList) {
      if (item is Map<String, dynamic>) {
        try {
          final data = crypto.decryptVaultItem(
            encryptedData: item['encryptedData'] as String,
            dataIV: item['dataIV'] as String,
            encryptedItemKey: item['encryptedItemKey'] as String,
            itemKeyIV: item['itemKeyIV'] as String,
            kek: backupKek,
          );

          final rawTitle = (data['title'] as String? ?? '').trim();
          final lowerTitle = rawTitle.toLowerCase();
          final incomingUuid = item['uuid'] as String? ?? const Uuid().v4();

          final existingByUuid = existingPageMap[incomingUuid];
          final existingByTitle = lowerTitle.isNotEmpty ? existingPageTitleMap[lowerTitle] : null;
          final hasConflict = existingByUuid != null || existingByTitle != null;

          if (hasConflict && conflictResolution == ImportConflictResolution.skip) {
            skippedCount++;
            continue;
          }

          if (hasConflict && conflictResolution == ImportConflictResolution.overwrite) {
            final target = existingByUuid ?? existingByTitle!;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = PageEntry()
              ..id = target.id
              ..uuid = target.uuid
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = target.createdAt
              ..updatedAt = DateTime.now();

            await isar.savePage(entry);
            updatedCount++;
            importedPages++;
          } else {
            if (hasConflict && conflictResolution == ImportConflictResolution.keepBoth) {
              data['title'] = rawTitle.isNotEmpty ? '$rawTitle (Imported)' : 'Untitled (Imported)';
            }

            final newUuid = hasConflict ? const Uuid().v4() : incomingUuid;
            final enc = crypto.encryptVaultItem(data, activeKek);
            final entry = PageEntry()
              ..uuid = newUuid
              ..encryptedData = enc['encryptedData']!
              ..encryptedItemKey = enc['encryptedItemKey']!
              ..itemKeyIV = enc['itemKeyIV']!
              ..dataIV = enc['dataIV']!
              ..createdAt = DateTime.tryParse(item['createdAt'] as String? ?? '') ?? DateTime.now()
              ..updatedAt = DateTime.now();

            await isar.savePage(entry);
            importedPages++;
          }
        } catch (_) {}
      }
    }

    final totalMerged = importedDocs + importedNotes + importedPasswords + importedPages;

    final log = BackupLog()
      ..backupDate = DateTime.now()
      ..fileSize = await file.length()
      ..itemCount = totalMerged
      ..status = 'success'
      ..destination = 'Merged Import';
    await isar.saveBackupLog(log);

    return MergeResult(
      documentCount: importedDocs,
      noteCount: importedNotes,
      passwordCount: importedPasswords,
      pageCount: importedPages,
      imageCount: imagesMap.length,
      updatedCount: updatedCount,
      skippedCount: skippedCount,
    );
  }
}
