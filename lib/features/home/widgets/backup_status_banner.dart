import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/backup_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';

class BackupStatusBanner extends ConsumerWidget {
  const BackupStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastBackup = ref.watch(lastBackupProvider);

    return lastBackup.when(
      data: (log) {
        if (log == null) {
          return _Banner(
            color: context.palette.error,
            icon: Icons.cloud_off_outlined,
            message: 'No backup yet. Tap to set up backup.',
            onTap: () => context.push(AppRoutes.backupSettings),
          );
        }

        final daysSince = DateTime.now().difference(log.backupDate).inDays;

        if (daysSince < 3) return const SizedBox.shrink();

        final color = daysSince < 10
            ? context.palette.warning
            : context.palette.error;

        return _Banner(
          color: color,
          icon: Icons.cloud_outlined,
          message: 'Last backup: ${daysSince == 1 ? '1 day' : '$daysSince days'} ago. Backup now →',
          onTap: () => context.push(AppRoutes.backupSettings),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _Banner extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String message;
  final VoidCallback onTap;

  const _Banner({
    required this.color,
    required this.icon,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
