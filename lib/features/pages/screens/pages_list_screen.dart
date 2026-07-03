import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state.dart';

class PagesListScreen extends ConsumerWidget {
  const PagesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(pagesProvider);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: const Text('Pages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.addPage),
          ),
        ],
      ),
      body: pages.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.article_outlined,
              title: 'No pages yet',
              subtitle: 'Tap + to create your first rich page',
              action: ElevatedButton(
                onPressed: () => context.push(AppRoutes.addPage),
                child: const Text('New Page'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final data = item['data'] as Map<String, dynamic>;
              return _PageTile(
                id: item['id'] as int,
                data: data,
                onDeleted: () => ref.refresh(pagesProvider),
              )
                  .animate(delay: (i * 50).ms)
                  .fadeIn(duration: 250.ms)
                  .slideX(begin: -0.04, duration: 250.ms, curve: Curves.easeOut);
            },
          );
        },
        loading: () => Center(
            child: CircularProgressIndicator(color: context.palette.primary)),
        error: (e, _) =>
            Center(child: Text('$e', style: TextStyle(color: context.palette.error))),
      ),
    );
  }
}

class _PageTile extends StatelessWidget {
  final int id;
  final Map<String, dynamic> data;
  final VoidCallback onDeleted;

  const _PageTile({required this.id, required this.data, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? 'Untitled';
    final emoji = data['coverEmoji'] as String?;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirm = await showConfirmDialog(context,
                  title: 'Delete Page',
                  message: 'Delete "$title"? This cannot be undone.',
                  confirmText: 'Delete',
                  destructive: true);
              if (confirm) {
                await IsarService.instance.deletePage(id);
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
          onTap: () => context.push(AppRoutes.pageDetail, extra: {'id': id, 'data': data}),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (emoji != null)
                  Text(emoji, style: const TextStyle(fontSize: 22))
                else
                  const Icon(Icons.article_outlined,
                      color: Color(0xFF9C27B0), size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: context.palette.textPrimary,
                              fontWeight: FontWeight.w600)),
                      Text('Rich page',
                          style: TextStyle(
                              color: context.palette.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: context.palette.textSecondary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
