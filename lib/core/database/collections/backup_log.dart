import 'package:isar/isar.dart';

part 'backup_log.g.dart';

@collection
class BackupLog {
  Id id = Isar.autoIncrement;

  late DateTime backupDate;
  late String destination; // "google_drive" or "local"
  late int fileSize; // in bytes
  late int itemCount;
  late String status; // "success", "failed", "in_progress"
  String? errorMessage;
  String? driveFileId;
}
