import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/backup_providers.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/theme/app_colors.dart';

class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastBackup = ref.watch(lastBackupProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          lastBackup.when(
            data: (log) => _StatusCard(log == null
                ? 'No backup yet'
                : 'Last backup: ${DateFormatter.formatRelative(log.backupDate)}'),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          _Card(children: [
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
              title: const Text('Back Up Now',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: const Text('Upload encrypted backup to Google Drive',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              onTap: () => _triggerBackup(context, ref),
            ),
            const Divider(color: AppColors.border, height: 1),
            ListTile(
              leading: const Icon(Icons.cloud_download_outlined, color: AppColors.primary),
              title: const Text('Restore from Drive',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: const Text('Restore your vault from a Google Drive backup',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              onTap: () => _showRestoreInfo(context),
            ),
          ]),
          const SizedBox(height: 16),
          _Card(children: [
            ListTile(
              leading: const Icon(Icons.save_alt_outlined, color: AppColors.textSecondary),
              title: const Text('Export to Device',
                  style: TextStyle(color: AppColors.textPrimary)),
              subtitle: const Text('Save .cipherbox file locally',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              onTap: () => _showComingSoon(context, 'Local export'),
            ),
            const Divider(color: AppColors.border, height: 1),
            ListTile(
              leading: const Icon(Icons.upload_file_outlined, color: AppColors.textSecondary),
              title: const Text('Import from File',
                  style: TextStyle(color: AppColors.textPrimary)),
              subtitle: const Text('Restore from a local .cipherbox file',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              onTap: () => _showComingSoon(context, 'File import'),
            ),
          ]),
          const SizedBox(height: 24),
          _BackupLogsSection(ref: ref),
        ],
      ),
    );
  }

  Future<void> _triggerBackup(BuildContext context, WidgetRef ref) async {
    ref.read(backupStatusProvider.notifier).setInProgress();
    try {
      // Google Drive backup implementation would go here
      // For now show a placeholder
      await Future.delayed(const Duration(seconds: 1));
      final log = await IsarService.instance.getLastSuccessfulBackup();
      ref.read(backupStatusProvider.notifier).setSuccess();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup feature requires Google Drive setup')));
      }
    } catch (e) {
      ref.read(backupStatusProvider.notifier).setFailed();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Backup failed: $e')));
      }
    }
  }

  void _showRestoreInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Restore', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'To restore, sign in to Google and select a .cipherbox backup. This feature requires Google Drive integration to be configured.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$feature — coming soon')));
  }
}

class _StatusCard extends StatelessWidget {
  final String message;
  const _StatusCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _BackupLogsSection extends StatelessWidget {
  final WidgetRef ref;
  const _BackupLogsSection({required this.ref});

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(backupLogsProvider);
    return logs.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Recent Backups',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            _Card(
              children: items.take(5).map((log) => ListTile(
                leading: Icon(
                  log.status == 'success' ? Icons.check_circle_outline : Icons.error_outline,
                  color: log.status == 'success' ? AppColors.success : AppColors.error,
                  size: 18,
                ),
                title: Text(DateFormatter.formatDateTime(log.backupDate),
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                subtitle: Text(
                  '${log.destination} · ${FileSizeFormatter.format(log.fileSize)} · ${log.itemCount} items',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              )).toList(),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
