import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/isar_service.dart';
import '../database/collections/document_entry.dart';
import '../database/collections/note_entry.dart';
import '../database/collections/password_entry.dart';
import '../encryption/crypto_service.dart';
import '../encryption/key_manager.dart';

// ── Counts ──────────────────────────────────────────────────────────────────

final vaultCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  return IsarService.instance.getItemCounts();
});

// ── Documents ────────────────────────────────────────────────────────────────

final documentsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) return [];
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
