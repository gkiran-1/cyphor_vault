import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/isar_service.dart';
import '../database/collections/backup_log.dart';

final backupLogsProvider = FutureProvider<List<BackupLog>>((ref) async {
  return IsarService.instance.getBackupLogs();
});

final lastBackupProvider = FutureProvider<BackupLog?>((ref) async {
  return IsarService.instance.getLastSuccessfulBackup();
});

enum BackupStatus { idle, inProgress, success, failed }

class BackupStateNotifier extends StateNotifier<BackupStatus> {
  BackupStateNotifier() : super(BackupStatus.idle);

  void setInProgress() => state = BackupStatus.inProgress;
  void setSuccess() => state = BackupStatus.success;
  void setFailed() => state = BackupStatus.failed;
  void reset() => state = BackupStatus.idle;
}

final backupStatusProvider =
    StateNotifierProvider<BackupStateNotifier, BackupStatus>(
  (ref) => BackupStateNotifier(),
);
