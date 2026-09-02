import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
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
import '../utils/constants.dart';

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
      return {
        'id': e.id,
        'uuid': e.uuid,
        'type': e.documentType,
        'data': data,
        'createdAt': e.createdAt,
        'updatedAt': e.updatedAt,
      };
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
      return {
        'id': e.id,
        'uuid': e.uuid,
        'data': data,
        'createdAt': e.createdAt,
        'updatedAt': e.updatedAt,
      };
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
      return {
        'id': e.id,
        'uuid': e.uuid,
        'data': data,
        'createdAt': e.createdAt,
        'updatedAt': e.updatedAt,
      };
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
      return {
        'id': e.id,
        'uuid': e.uuid,
        'data': data,
        'createdAt': e.createdAt,
        'updatedAt': e.updatedAt,
      };
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

// ── Unified Vault Item Summary & Search ───────────────────────────────────────

enum VaultItemType {
  document,
  note,
  password,
  page;

  String get displayName {
    switch (this) {
      case VaultItemType.document:
        return 'Document';
      case VaultItemType.note:
        return 'Note';
      case VaultItemType.password:
        return 'Password';
      case VaultItemType.page:
        return 'Page';
    }
  }
}

class VaultItemSummary {
  final int id;
  final String uuid;
  final VaultItemType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String? documentType;
  final Map<String, dynamic> data;

  const VaultItemSummary({
    required this.id,
    required this.uuid,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.updatedAt,
    required this.createdAt,
    this.documentType,
    required this.data,
  });
}

final allVaultItemsProvider = FutureProvider<List<VaultItemSummary>>((ref) async {
  final kek = KeyManager.instance.currentKEK;
  if (kek == null) return [];

  final docs = await ref.watch(documentsProvider.future);
  final notes = await ref.watch(notesProvider.future);
  final passwords = await ref.watch(passwordsProvider.future);
  final pages = await ref.watch(pagesProvider.future);

  final List<VaultItemSummary> items = [];

  for (final item in docs) {
    final data = (item['data'] as Map<String, dynamic>?) ?? {};
    final docType = item['type'] as String? ?? '';
    final id = item['id'] as int;
    final uuid = item['uuid'] as String? ?? '';
    final updatedAt = (item['updatedAt'] as DateTime?) ?? (item['createdAt'] as DateTime?) ?? DateTime.now();
    final createdAt = (item['createdAt'] as DateTime?) ?? updatedAt;

    String title = 'Document';
    IconData icon = Icons.folder_outlined;
    switch (docType) {
      case AppConstants.docAadhaar:
        title = 'Aadhaar Card';
        icon = Icons.badge_outlined;
        break;
      case AppConstants.docPAN:
        title = 'PAN Card';
        icon = Icons.credit_card_outlined;
        break;
      case AppConstants.docDebitCard:
        title = (data['bankName'] as String?)?.isNotEmpty == true ? '${data['bankName']} Debit' : 'Debit Card';
        icon = Icons.payment_outlined;
        break;
      case AppConstants.docCreditCard:
        title = (data['bankName'] as String?)?.isNotEmpty == true ? '${data['bankName']} Credit' : 'Credit Card';
        icon = Icons.payment_outlined;
        break;
      default:
        title = (data['title'] as String?)?.isNotEmpty == true ? data['title'] : 'Document';
        icon = Icons.folder_outlined;
    }

    final subtitle = (data['holderName'] as String?) ??
        (data['cardholderName'] as String?) ??
        (data['bankName'] as String?) ??
        '';

    items.add(VaultItemSummary(
      id: id,
      uuid: uuid,
      type: VaultItemType.document,
      title: title,
      subtitle: subtitle,
      icon: icon,
      updatedAt: updatedAt,
      createdAt: createdAt,
      documentType: docType,
      data: data,
    ));
  }

  for (final item in notes) {
    final data = (item['data'] as Map<String, dynamic>?) ?? {};
    final id = item['id'] as int;
    final uuid = item['uuid'] as String? ?? '';
    final updatedAt = (item['updatedAt'] as DateTime?) ?? (item['createdAt'] as DateTime?) ?? DateTime.now();
    final createdAt = (item['createdAt'] as DateTime?) ?? updatedAt;

    final rawTitle = (data['title'] as String?)?.trim() ?? '';
    final title = rawTitle.isNotEmpty ? rawTitle : 'Untitled Note';
    final content = (data['content'] as String? ?? data['text'] as String? ?? '').trim();
    String subtitle = '';
    if (content.isNotEmpty) {
      final clean = content.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();
      subtitle = clean.length > 50 ? '${clean.substring(0, 50)}...' : clean;
    }

    items.add(VaultItemSummary(
      id: id,
      uuid: uuid,
      type: VaultItemType.note,
      title: title,
      subtitle: subtitle,
      icon: Icons.sticky_note_2_outlined,
      updatedAt: updatedAt,
      createdAt: createdAt,
      data: data,
    ));
  }

  for (final item in passwords) {
    final data = (item['data'] as Map<String, dynamic>?) ?? {};
    final id = item['id'] as int;
    final uuid = item['uuid'] as String? ?? '';
    final updatedAt = (item['updatedAt'] as DateTime?) ?? (item['createdAt'] as DateTime?) ?? DateTime.now();
    final createdAt = (item['createdAt'] as DateTime?) ?? updatedAt;

    final siteName = (data['siteName'] as String?)?.trim() ?? '';
    final rawTitle = (data['title'] as String?)?.trim() ?? '';
    final url = (data['url'] as String?)?.trim() ?? '';

    final title = siteName.isNotEmpty
        ? siteName
        : rawTitle.isNotEmpty
            ? rawTitle
            : url.isNotEmpty
                ? url
                : 'Password';
    final subtitle = (data['username'] as String?) ?? (data['email'] as String?) ?? '';

    items.add(VaultItemSummary(
      id: id,
      uuid: uuid,
      type: VaultItemType.password,
      title: title,
      subtitle: subtitle,
      icon: Icons.key_outlined,
      updatedAt: updatedAt,
      createdAt: createdAt,
      data: data,
    ));
  }

  for (final item in pages) {
    final data = (item['data'] as Map<String, dynamic>?) ?? {};
    final id = item['id'] as int;
    final uuid = item['uuid'] as String? ?? '';
    final updatedAt = (item['updatedAt'] as DateTime?) ?? (item['createdAt'] as DateTime?) ?? DateTime.now();
    final createdAt = (item['createdAt'] as DateTime?) ?? updatedAt;

    final rawTitle = (data['title'] as String?)?.trim() ?? '';
    final title = rawTitle.isNotEmpty ? rawTitle : 'Untitled Page';

    items.add(VaultItemSummary(
      id: id,
      uuid: uuid,
      type: VaultItemType.page,
      title: title,
      subtitle: 'Markdown Page',
      icon: Icons.article_outlined,
      updatedAt: updatedAt,
      createdAt: createdAt,
      data: data,
    ));
  }

  items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return items;
});
