import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: ListView(
        children: [
          _SectionHeader('ACCOUNT'),
          _SettingsTile(
            icon: Icons.lock_reset_outlined,
            title: 'Change PIN',
            subtitle: 'Update your vault unlock PIN',
            onTap: () => context.go(AppRoutes.changePin),
          ),

          _SectionHeader('SECURITY'),
          _SettingsTile(
            icon: Icons.fingerprint,
            title: 'Biometric & PIN',
            onTap: () => context.go(AppRoutes.securitySettings),
          ),

          _SectionHeader('BACKUP'),
          _SettingsTile(
            icon: Icons.cloud_outlined,
            title: 'Google Drive Backup',
            onTap: () => context.go(AppRoutes.backupSettings),
          ),

          _SectionHeader('DANGER ZONE'),
          _SettingsTile(
            icon: Icons.delete_forever_outlined,
            title: 'Delete All Data',
            titleColor: AppColors.error,
            onTap: () async {
              final confirm = await showConfirmDialog(
                context,
                title: 'Delete All Data',
                message:
                    'This will permanently delete all your vault data and cannot be undone. Are you absolutely sure?',
                confirmText: 'Delete Everything',
                destructive: true,
              );
              if (confirm && context.mounted) {
                await AuthService.instance.deleteAccount();
                ref.read(authStateProvider.notifier).initialize();
              }
            },
          ),

          const SizedBox(height: 24),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (ctx, snap) {
              final version = snap.data?.version ?? '';
              return Center(
                child: Text(
                  'CipherBox $version',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textSecondary, size: 22),
      title: Text(title,
          style: TextStyle(
              color: titleColor ?? AppColors.textPrimary, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))
          : null,
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18)
          : null,
      onTap: onTap,
    );
  }
}
