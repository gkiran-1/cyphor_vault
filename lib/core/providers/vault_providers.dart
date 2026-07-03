import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../database/isar_service.dart';
import '../database/collections/document_entry.dart';
import '../database/collections/note_entry.dart';
import '../database/collections/password_entry.dart';
import '../database/collections/page_entry.dart';
import '../encryption/crypto_service.dart';
import '../encryption/key_manager.dart';
import '../storage/encrypted_image_store.dart';

// ── Counts ──────────────────────────────────────────────────────────────────

final vaultCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  return IsarService.instance.getItemCounts();
});

// ── Documents ────────────────────────────────────────────────────────────────

const _imgMigrationKey = 'cipherbox_img_migrated_v1';
const _migrationStorage = FlutterSecureStorage();

/// One-time migration: moves images stored inline as base64 inside the document
/// blob onto separate encrypted files, replacing them with small refs. This is
/// what makes the documents list fast — the blob no longer carries image bytes.
Future<void> _migrateDocumentImagesIfNeeded(Uint8List kek) async {
  if (await _migrationStorage.read(key: _imgMigrationKey) == '1') return;
  final entries = await IsarService.instance.getAllDocuments();
  for (final e in entries) {
    try {
      final data = CryptoService.instance.decryptVaultItem(
        encryptedData: e.encryptedData,
        dataIV: e.dataIV,
        encryptedItemKey: e.encryptedItemKey,
        itemKeyIV: e.itemKeyIV,
        kek: kek,
      );
      var changed = false;
      for (final key in ['imageFront', 'imageBack']) {
        final b64 = data['${key}Base64'];
        if (b64 is String && b64.isNotEmpty) {
          final refMap = await EncryptedImageStore.instance
              .save(base64.decode(b64), kek);
          data['${key}Ref'] = refMap;
          data.remove('${key}Base64');
          changed = true;
        }
      }
      if (changed) {
        final enc = CryptoService.instance.encryptVaultItem(data, kek);
        e
          ..encryptedData = enc['encryptedData']!
          ..dataIV = enc['dataIV']!
          ..encryptedItemKey = enc['encryptedItemKey']!
          ..itemKeyIV = enc['itemKeyIV']!
          ..updatedAt = DateTime.now();
        await IsarService.instance.saveDocument(e);
      }
    } catch (_) {
      // Skip documents that fail to decrypt/migrate; they remain readable
      // via the legacy base64 fallback path.
    }
  }
  await _migrationStorage.write(key: _imgMigrationKey, value: '1');
}

final documentsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) return [];
  await _migrateDocumentImagesIfNeeded(kek);
  final entries = await IsarService.instance.getAllDocuments();
  return entries.map((e) {
    try {
      final data = CryptoService.instance.decryptVaultItem(
        encryptedData: e.encryptedData,
        dataIV: e.dataIV,
        encryptedItemKey: e.encryptedItemKey,
        itemKeyIV: e.itemKeyIV,
        kek: kek,
      );
      return {'id': e.id, 'uuid': e.uuid, 'type': e.documentType, 'data': data};
    } catch (_) {
      return <String, dynamic>{};
    }
  }).where((m) => m.isNotEmpty).toList();
});

Future<void> saveDocument({
  required String documentType,
  required Map<String, dynamic> data,
  int? existingId,
}) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) throw StateError('Vault is locked');

  final encrypted = CryptoService.instance.encryptVaultItem(data, kek);
  final now = DateTime.now();
  final entry = DocumentEntry()
    ..uuid = existingId != null ? '' : const Uuid().v4()
    ..documentType = documentType
    ..encryptedData = encrypted['encryptedData']!
    ..dataIV = encrypted['dataIV']!
    ..encryptedItemKey = encrypted['encryptedItemKey']!
    ..itemKeyIV = encrypted['itemKeyIV']!
    ..createdAt = now
    ..updatedAt = now;

  if (existingId != null) {
    final existing = await IsarService.instance.getAllDocuments()
        .then((l) => l.firstWhere((e) => e.id == existingId));
    entry
      ..id = existingId
      ..uuid = existing.uuid
      ..createdAt = existing.createdAt;
  }

  await IsarService.instance.saveDocument(entry);
}

Future<Map<String, dynamic>> decryptDocument(DocumentEntry entry) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) throw StateError('Vault is locked');
  return CryptoService.instance.decryptVaultItem(
    encryptedData: entry.encryptedData,
    dataIV: entry.dataIV,
    encryptedItemKey: entry.encryptedItemKey,
    itemKeyIV: entry.itemKeyIV,
    kek: kek,
  );
}

// ── Notes ────────────────────────────────────────────────────────────────────

final notesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) return [];
  final entries = await IsarService.instance.getAllNotes();
  return entries.map((e) {
    try {
      final data = CryptoService.instance.decryptVaultItem(
        encryptedData: e.encryptedData,
        dataIV: e.dataIV,
        encryptedItemKey: e.encryptedItemKey,
        itemKeyIV: e.itemKeyIV,
        kek: kek,
      );
      return {'id': e.id, 'uuid': e.uuid, 'data': data};
    } catch (_) {
      return <String, dynamic>{};
    }
  }).where((m) => m.isNotEmpty).toList();
});

Future<void> saveNote({
  required Map<String, dynamic> data,
  int? existingId,
}) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) throw StateError('Vault is locked');

  final encrypted = CryptoService.instance.encryptVaultItem(data, kek);
  final now = DateTime.now();
  final entry = NoteEntry()
    ..uuid = const Uuid().v4()
    ..encryptedData = encrypted['encryptedData']!
    ..dataIV = encrypted['dataIV']!
    ..encryptedItemKey = encrypted['encryptedItemKey']!
    ..itemKeyIV = encrypted['itemKeyIV']!
    ..createdAt = now
    ..updatedAt = now;

  if (existingId != null) {
    final existing = await IsarService.instance.getAllNotes()
        .then((l) => l.firstWhere((e) => e.id == existingId));
    entry
      ..id = existingId
      ..uuid = existing.uuid
      ..createdAt = existing.createdAt;
  }

  await IsarService.instance.saveNote(entry);
}

// ── Passwords ────────────────────────────────────────────────────────────────

final passwordsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) return [];
  final entries = await IsarService.instance.getAllPasswords();
  return entries.map((e) {
    try {
      final data = CryptoService.instance.decryptVaultItem(
        encryptedData: e.encryptedData,
        dataIV: e.dataIV,
        encryptedItemKey: e.encryptedItemKey,
        itemKeyIV: e.itemKeyIV,
        kek: kek,
      );
      return {'id': e.id, 'uuid': e.uuid, 'data': data};
    } catch (_) {
      return <String, dynamic>{};
    }
  }).where((m) => m.isNotEmpty).toList();
});

Future<void> savePassword({
  required Map<String, dynamic> data,
  int? existingId,
}) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) throw StateError('Vault is locked');

  final encrypted = CryptoService.instance.encryptVaultItem(data, kek);
  final now = DateTime.now();
  final entry = PasswordEntry()
    ..uuid = const Uuid().v4()
    ..encryptedData = encrypted['encryptedData']!
    ..dataIV = encrypted['dataIV']!
    ..encryptedItemKey = encrypted['encryptedItemKey']!
    ..itemKeyIV = encrypted['itemKeyIV']!
    ..createdAt = now
    ..updatedAt = now;

  if (existingId != null) {
    final existing = await IsarService.instance.getAllPasswords()
        .then((l) => l.firstWhere((e) => e.id == existingId));
    entry
      ..id = existingId
      ..uuid = existing.uuid
      ..createdAt = existing.createdAt;
  }

  await IsarService.instance.savePassword(entry);
}

// ── Pages ─────────────────────────────────────────────────────────────────────

final pagesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) return [];
  final entries = await IsarService.instance.getAllPages();
  return entries.map((e) {
    try {
      final data = CryptoService.instance.decryptVaultItem(
        encryptedData: e.encryptedData,
        dataIV: e.dataIV,
        encryptedItemKey: e.encryptedItemKey,
        itemKeyIV: e.itemKeyIV,
        kek: kek,
      );
      return {'id': e.id, 'uuid': e.uuid, 'data': data};
    } catch (_) {
      return <String, dynamic>{};
    }
  }).where((m) => m.isNotEmpty).toList();
});

Future<void> savePage({
  required Map<String, dynamic> data,
  int? existingId,
}) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) throw StateError('Vault is locked');

  final encrypted = CryptoService.instance.encryptVaultItem(data, kek);
  final now = DateTime.now();
  final entry = PageEntry()
    ..uuid = const Uuid().v4()
    ..encryptedData = encrypted['encryptedData']!
    ..dataIV = encrypted['dataIV']!
    ..encryptedItemKey = encrypted['encryptedItemKey']!
    ..itemKeyIV = encrypted['itemKeyIV']!
    ..createdAt = now
    ..updatedAt = now;

  if (existingId != null) {
    final existing = await IsarService.instance.getAllPages()
        .then((l) => l.firstWhere((e) => e.id == existingId));
    entry
      ..id = existingId
      ..uuid = existing.uuid
      ..createdAt = existing.createdAt;
  }

  await IsarService.instance.savePage(entry);
}
