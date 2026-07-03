import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/biometric_service.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state.dart';

class PasswordsListScreen extends ConsumerWidget {
  const PasswordsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwords = ref.watch(passwordsProvider);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: const Text('Passwords'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.addPassword),
          ),
        ],
      ),
      body: passwords.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.key_outlined,
              title: 'No passwords yet',
              subtitle: 'Tap + to add your first password',
              action: ElevatedButton(
                onPressed: () => context.push(AppRoutes.addPassword),
                child: const Text('Add Password'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final data = item['data'] as Map<String, dynamic>;
              return _PasswordTile(
                id: item['id'] as int,
                data: data,
                onDeleted: () => ref.refresh(passwordsProvider),
              )
                  .animate(delay: (i * 50).ms)
                  .fadeIn(duration: 250.ms)
                  .slideX(begin: -0.04, duration: 250.ms, curve: Curves.easeOut);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: context.palette.primary)),
        error: (e, _) => Center(child: Text('$e', style: TextStyle(color: context.palette.error))),
      ),
    );
  }
}

class _PasswordTile extends StatelessWidget {
  final int id;
  final Map<String, dynamic> data;
  final VoidCallback onDeleted;

  const _PasswordTile({required this.id, required this.data, required this.onDeleted});

  Future<void> _copyPassword(BuildContext context) async {
    final ok = await BiometricService.instance.authenticateForReveal();
    if (!ok) return;
    final password = data['password'] as String? ?? '';
    await Clipboard.setData(ClipboardData(text: password));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password copied! Clears in 30 seconds.')),
      );
    }
    Future.delayed(const Duration(seconds: 30), () => Clipboard.setData(const ClipboardData(text: '')));
  }

  @override
  Widget build(BuildContext context) {
    final siteName = data['siteName'] as String? ?? data['url'] as String? ?? 'Unknown';
    final username = data['username'] as String? ?? '';

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirm = await showConfirmDialog(context,
                  title: 'Delete Password',
                  message: 'Delete "$siteName"? This cannot be undone.',
                  confirmText: 'Delete',
                  destructive: true);
              if (confirm) {
                await IsarService.instance.deletePassword(id);
                onDeleted();
              }
            },
            backgroundColor: context.palette.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        child: InkWell(
          onTap: () => context.push(AppRoutes.passwordDetail, extra: {'id': id, 'data': data}),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.palette.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Icon(Icons.language_outlined, color: context.palette.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(siteName,
                          style: TextStyle(
                              color: context.palette.textPrimary, fontWeight: FontWeight.w600)),
                      if (username.isNotEmpty)
                        Text(username,
                            style: TextStyle(
                                color: context.palette.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                Text('••••••••', style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.copy_outlined, size: 18, color: context.palette.textSecondary),
                  onPressed: () => _copyPassword(context),
                  tooltip: 'Copy password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
