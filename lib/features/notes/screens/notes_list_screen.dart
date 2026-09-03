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

class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: const Text('Notes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.addNote),
          ),
        ],
      ),
      body: notes.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.sticky_note_2_outlined,
              title: 'No notes yet',
              subtitle: 'Tap + to add your first note or link',
              action: ElevatedButton(
                onPressed: () => context.push(AppRoutes.addNote),
                child: const Text('Add Note'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final data = item['data'] as Map<String, dynamic>;
              return _NoteTile(
                id: item['id'] as int,
                data: data,
                onDeleted: () => ref.refresh(notesProvider),
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

class _NoteTile extends StatelessWidget {
  final int id;
  final Map<String, dynamic> data;
  final VoidCallback onDeleted;

  const _NoteTile({required this.id, required this.data, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? 'Untitled';
    final content = data['content'] as String? ?? '';
    final category = data['category'] as String? ?? 'note';
    final isLink = category == 'important_link';

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirm = await showConfirmDialog(context,
                  title: 'Delete Note',
                  message: 'Delete "$title"? This cannot be undone.',
                  confirmText: 'Delete',
                  destructive: true);
              if (confirm) {
                await IsarService.instance.deleteNote(id);
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
          onTap: () => context.push(AppRoutes.noteDetail, extra: {'id': id, 'data': data}),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (isLink ? context.palette.primary : context.palette.accentNotes)
                        .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    isLink ? Icons.link_rounded : Icons.sticky_note_2_outlined,
                    color: isLink ? context.palette.primary : context.palette.accentNotes,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: context.palette.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                      if (content.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          content.length > 60 ? '${content.substring(0, 60)}…' : content,
                          style: TextStyle(color: context.palette.textSecondary, fontSize: 13),
                        ),
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
