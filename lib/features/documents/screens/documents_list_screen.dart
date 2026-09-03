import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/storage/encrypted_image_store.dart';
import '../../../core/utils/constants.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state.dart';

class DocumentsListScreen extends ConsumerWidget {
  const DocumentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(documentsProvider);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: const Text('Documents'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.addDocument),
          ),
        ],
      ),
      body: docs.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.folder_outlined,
              title: 'No documents yet',
              subtitle: 'Tap + to add Aadhaar, PAN, or cards',
              action: ElevatedButton(
                onPressed: () => context.push(AppRoutes.addDocument),
                child: const Text('Add Document'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final data = item['data'] as Map<String, dynamic>;
              final type = item['type'] as String;
              return _DocumentTile(
                id: item['id'] as int,
                type: type,
                data: data,
                onDeleted: () => ref.refresh(documentsProvider),
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

class _DocumentTile extends StatelessWidget {
  final int id;
  final String type;
  final Map<String, dynamic> data;
  final VoidCallback onDeleted;

  const _DocumentTile({required this.id, required this.type, required this.data, required this.onDeleted});

  IconData get _icon {
    switch (type) {
      case AppConstants.docAadhaar: return Icons.badge_outlined;
      case AppConstants.docPAN: return Icons.credit_card_outlined;
      case AppConstants.docDebitCard:
      case AppConstants.docCreditCard: return Icons.payment_outlined;
      default: return Icons.folder_outlined;
    }
  }

  String get _typeLabel {
    switch (type) {
      case AppConstants.docAadhaar: return 'Aadhaar Card';
      case AppConstants.docPAN: return 'PAN Card';
      case AppConstants.docDebitCard: return 'Debit Card';
      case AppConstants.docCreditCard: return 'Credit Card';
      default: return 'Document';
    }
  }

  String get _subtitle {
    final name = data['holderName'] as String? ?? data['cardholderName'] as String? ?? '';
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirm = await showConfirmDialog(context,
                  title: 'Delete Document',
                  message: 'Delete this $_typeLabel? This cannot be undone.',
                  confirmText: 'Delete',
                  destructive: true);
              if (confirm) {
                await IsarService.instance.deleteDocument(id);
                for (final k in ['imageFrontRef', 'imageBackRef']) {
                  final r = data[k];
                  if (r is Map) {
                    await EncryptedImageStore.instance
                        .delete(Map<String, dynamic>.from(r));
                  }
                }
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
          onTap: () => context.push(AppRoutes.documentDetail,
              extra: {'id': id, 'type': type, 'data': data}),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.palette.accentDocuments.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(_icon, color: context.palette.accentDocuments, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_typeLabel,
                          style: TextStyle(
                              color: context.palette.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                      if (_subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(_subtitle,
                            style: TextStyle(
                                color: context.palette.textSecondary, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: context.palette.textSecondary.withValues(alpha: 0.6), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
