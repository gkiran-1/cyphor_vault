import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'collections/user_profile.dart';
import 'collections/document_entry.dart';
import 'collections/note_entry.dart';
import 'collections/password_entry.dart';
import 'collections/backup_log.dart';

class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  Isar get db {
    if (_isar == null || !_isar!.isOpen) {
      throw StateError('Isar not initialized. Call open() first.');
    }
    return _isar!;
  }

  Future<void> open() async {
    if (_isar != null && _isar!.isOpen) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        UserProfileSchema,
        DocumentEntrySchema,
        NoteEntrySchema,
        PasswordEntrySchema,
        BackupLogSchema,
      ],
      directory: dir.path,
      name: 'cipherbox',
    );
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  // ── UserProfile ────────────────────────────────────────────────────────────

  Future<UserProfile?> getUserProfile() async {
    return db.userProfiles.where().findFirst();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await db.writeTxn(() async {
      await db.userProfiles.put(profile);
    });
  }

  Future<void> deleteUserProfile() async {
    await db.writeTxn(() async {
      await db.userProfiles.clear();
    });
  }

  // ── DocumentEntry ──────────────────────────────────────────────────────────

  Future<List<DocumentEntry>> getAllDocuments() async {
    return db.documentEntrys.where().sortByCreatedAtDesc().findAll();
  }

  Future<DocumentEntry?> getDocumentByUuid(String uuid) async {
    return db.documentEntrys.filter().uuidEqualTo(uuid).findFirst();
  }

  Future<void> saveDocument(DocumentEntry entry) async {
    await db.writeTxn(() async {
      await db.documentEntrys.put(entry);
    });
  }

  Future<void> deleteDocument(int id) async {
    await db.writeTxn(() async {
      await db.documentEntrys.delete(id);
    });
  }

  Future<int> getDocumentCount() async {
    return db.documentEntrys.count();
  }

  // ── NoteEntry ──────────────────────────────────────────────────────────────

  Future<List<NoteEntry>> getAllNotes() async {
    return db.noteEntrys.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> saveNote(NoteEntry entry) async {
    await db.writeTxn(() async {
      await db.noteEntrys.put(entry);
    });
  }

  Future<void> deleteNote(int id) async {
    await db.writeTxn(() async {
      await db.noteEntrys.delete(id);
    });
  }

  Future<int> getNoteCount() async {
    return db.noteEntrys.count();
  }

  // ── PasswordEntry ──────────────────────────────────────────────────────────

  Future<List<PasswordEntry>> getAllPasswords() async {
    return db.passwordEntrys.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> savePassword(PasswordEntry entry) async {
    await db.writeTxn(() async {
      await db.passwordEntrys.put(entry);
    });
  }

  Future<void> deletePassword(int id) async {
    await db.writeTxn(() async {
      await db.passwordEntrys.delete(id);
    });
  }

  Future<int> getPasswordCount() async {
    return db.passwordEntrys.count();
  }

  // ── BackupLog ──────────────────────────────────────────────────────────────

  Future<List<BackupLog>> getBackupLogs({int limit = 20}) async {
    return db.backupLogs.where().sortByBackupDateDesc().limit(limit).findAll();
  }

  Future<BackupLog?> getLastSuccessfulBackup() async {
    return db.backupLogs.filter().statusEqualTo('success').sortByBackupDateDesc().findFirst();
  }

  Future<void> saveBackupLog(BackupLog log) async {
    await db.writeTxn(() async {
      await db.backupLogs.put(log);
    });
  }

  // ── Bulk operations ────────────────────────────────────────────────────────

  Future<void> deleteAllData() async {
    await db.writeTxn(() async {
      await db.documentEntrys.clear();
      await db.noteEntrys.clear();
      await db.passwordEntrys.clear();
      await db.backupLogs.clear();
      await db.userProfiles.clear();
    });
  }

  Future<Map<String, int>> getItemCounts() async {
    return {
      'documents': await getDocumentCount(),
      'notes': await getNoteCount(),
      'passwords': await getPasswordCount(),
    };
  }
}
