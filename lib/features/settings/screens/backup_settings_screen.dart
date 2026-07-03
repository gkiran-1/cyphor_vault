import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/backup_providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/theme/app_palette.dart';

class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastBackup = ref.watch(lastBackupProvider);

    return Scaffold(
      backgroundColor: context.palette.background,
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
              leading: Icon(Icons.cloud_upload_outlined, color: context.palette.primary),
              title: Text('Back Up Now',
                  style: TextStyle(color: context.palette.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: Text('Upload encrypted backup to Google Drive',
                  style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
              onTap: () => _triggerBackup(context, ref),
            ),
            Divider(color: context.palette.border, height: 1),
            ListTile(
              leading: Icon(Icons.cloud_download_outlined, color: context.palette.primary),
              title: Text('Restore from Drive',
                  style: TextStyle(color: context.palette.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: Text('Restore your vault from a Google Drive backup',
                  style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
              onTap: () => _showRestoreInfo(context),
            ),
          ]),
          const SizedBox(height: 16),
          _Card(children: [
            ListTile(
              leading: Icon(Icons.save_alt_outlined, color: context.palette.textSecondary),
              title: Text('Export to Device',
                  style: TextStyle(color: context.palette.textPrimary)),
              subtitle: Text('Save .cipherbox file locally',
                  style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
              onTap: () => _showComingSoon(context, 'Local export'),
            ),
            Divider(color: context.palette.border, height: 1),
            ListTile(
              leading: Icon(Icons.upload_file_outlined, color: context.palette.textSecondary),
              title: Text('Import from File',
                  style: TextStyle(color: context.palette.textPrimary)),
              subtitle: Text('Restore from a local .cipherbox file',
                  style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
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
        backgroundColor: context.palette.surface,
        title: Text('Restore', style: TextStyle(color: context.palette.textPrimary)),
        content: Text(
          'To restore, sign in to Google and select a .cipherbox backup. This feature requires Google Drive integration to be configured.',
          style: TextStyle(color: context.palette.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: context.palette.primary)),
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
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: context.palette.primary, size: 18),
          const SizedBox(width: 10),
          Text(message, style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
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
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.palette.border),
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
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Recent Backups',
                  style: TextStyle(
                      color: context.palette.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            _Card(
              children: items.take(5).map((log) => ListTile(
                leading: Icon(
                  log.status == 'success' ? Icons.check_circle_outline : Icons.error_outline,
                  color: log.status == 'success' ? context.palette.success : context.palette.error,
                  size: 18,
                ),
                title: Text(DateFormatter.formatDateTime(log.backupDate),
                    style: TextStyle(color: context.palette.textPrimary, fontSize: 14)),
                subtitle: Text(
                  '${log.destination} · ${FileSizeFormatter.format(log.fileSize)} · ${log.itemCount} items',
                  style: TextStyle(color: context.palette.textSecondary, fontSize: 12),
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
