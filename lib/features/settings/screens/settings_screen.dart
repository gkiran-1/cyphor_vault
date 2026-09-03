import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 40),
        children: [
          const _AppearanceSection(),
          _SectionCard(
            delay: 80,
            header: const _SectionHeader(label: 'ACCOUNT'),
            tiles: [
              _SettingsTile(
                icon: Icons.lock_reset_outlined,
                iconColor: context.palette.primary,
                title: 'Change PIN',
                subtitle: 'Update your vault unlock PIN',
                onTap: () => context.push(AppRoutes.changePin),
              ),
            ],
          ),
          _SectionCard(
            delay: 80,
            header: const _SectionHeader(label: 'SECURITY'),
            tiles: [
              _SettingsTile(
                icon: Icons.fingerprint,
                iconColor: context.palette.warning,
                title: 'Biometric & PIN',
                subtitle: 'Manage biometric authentication',
                onTap: () => context.push(AppRoutes.securitySettings),
              ),
            ],
          ),
          _SectionCard(
            delay: 160,
            header: const _SectionHeader(label: 'BACKUP & RESTORE'),
            tiles: [
              _SettingsTile(
                icon: Icons.backup_outlined,
                iconColor: context.palette.success,
                title: 'Vault Backup & Restore',
                subtitle: 'Export, import & restore encrypted backups',
                onTap: () => context.push(AppRoutes.backupSettings),
              ),
            ],
          ),
          _SectionCard(
            delay: 240,
            isDanger: true,
            header: const _SectionHeader(label: 'DANGER ZONE'),
            tiles: [
              _SettingsTile(
                icon: Icons.delete_forever_outlined,
                iconColor: context.palette.error,
                title: 'Delete All Data',
                titleColor: context.palette.error,
                subtitle: 'Permanently erase all vault data',
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
            ],
          ),
          const SizedBox(height: 24),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (ctx, snap) {
              final version = snap.data?.version ?? '';
              return Center(
                child: Text(
                  version.isNotEmpty ? 'CipherBox $version' : 'CipherBox',
                  style: TextStyle(
                      color: context.palette.textSecondary, fontSize: 12),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final p = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'APPEARANCE',
              style: TextStyle(
                color: p.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.border, width: 1),
            ),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto_outlined, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode_outlined, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode_outlined, size: 18),
                ),
              ],
              selected: {mode},
              showSelectedIcon: false,
              onSelectionChanged: (sel) =>
                  ref.read(themeModeProvider.notifier).setMode(sel.first),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(begin: 0.05, duration: 250.ms, curve: Curves.easeOut);
  }
}

class _SectionHeader {
  final String label;

  const _SectionHeader({required this.label});
}

class _SectionCard extends StatelessWidget {
  final _SectionHeader header;
  final List<_SettingsTile> tiles;
  final int delay;
  final bool isDanger;

  const _SectionCard({
    required this.header,
    required this.tiles,
    this.delay = 0,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              header.label,
              style: TextStyle(
                color: isDanger
                    ? context.palette.error.withValues(alpha: 0.9)
                    : context.palette.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDanger
                    ? context.palette.error.withValues(alpha: 0.25)
                    : context.palette.border,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                for (var i = 0; i < tiles.length; i++) ...[
                  tiles[i],
                  if (i < tiles.length - 1)
                    Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: context.palette.border,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: delay.ms)
        .fadeIn(duration: 250.ms)
        .slideY(begin: 0.05, duration: 250.ms, curve: Curves.easeOut);
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? context.palette.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(
                  color: context.palette.textSecondary, fontSize: 13))
          : null,
      trailing: onTap != null
          ? Icon(Icons.chevron_right_rounded,
              color: context.palette.textSecondary.withValues(alpha: 0.6), size: 20)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: onTap,
    );
  }
}
