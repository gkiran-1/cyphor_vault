import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/vault_card.dart';
import '../widgets/backup_status_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(vaultCountsProvider);
    final profile = ref.watch(authStateProvider).profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CipherBox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(vaultCountsProvider),
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            const BackupStatusBanner(),
            const SizedBox(height: 8),
            counts.when(
              data: (c) => Column(
                children: [
                  VaultCard(
                    icon: Icons.folder_outlined,
                    title: 'Documents',
                    subtitle: '${c['documents'] ?? 0} items',
                    color: const Color(0xFF4CAF50),
                    onTap: () => context.go(AppRoutes.documents),
                  ),
                  VaultCard(
                    icon: Icons.sticky_note_2_outlined,
                    title: 'Notes',
                    subtitle: '${c['notes'] ?? 0} items',
                    color: const Color(0xFFFF9800),
                    onTap: () => context.go(AppRoutes.notes),
                  ),
                  VaultCard(
                    icon: Icons.key_outlined,
                    title: 'Passwords',
                    subtitle: '${c['passwords'] ?? 0} items',
                    color: AppColors.primary,
                    onTap: () => context.go(AppRoutes.passwords),
                  ),
                ],
              ),
              loading: () => const Center(
                  child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(color: AppColors.primary))),
              error: (e, _) => Center(
                  child: Text('Error loading data',
                      style: const TextStyle(color: AppColors.error))),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_outlined, color: AppColors.primary),
                title: const Text('Add Document',
                    style: TextStyle(color: AppColors.textPrimary)),
                onTap: () { Navigator.pop(ctx); context.go(AppRoutes.addDocument); },
              ),
              ListTile(
                leading: const Icon(Icons.sticky_note_2_outlined, color: AppColors.primary),
                title: const Text('Add Note',
                    style: TextStyle(color: AppColors.textPrimary)),
                onTap: () { Navigator.pop(ctx); context.go(AppRoutes.addNote); },
              ),
              ListTile(
                leading: const Icon(Icons.key_outlined, color: AppColors.primary),
                title: const Text('Add Password',
                    style: TextStyle(color: AppColors.textPrimary)),
                onTap: () { Navigator.pop(ctx); context.go(AppRoutes.addPassword); },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
