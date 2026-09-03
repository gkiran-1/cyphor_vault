import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/utils/constants.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final int id;
  final Map<String, dynamic> data;

  const NoteDetailScreen({super.key, required this.id, required this.data});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    // Watch notesProvider so edits are reflected immediately
    final notesAsync = ref.watch(notesProvider);
    final freshItem = notesAsync.asData?.value
        .cast<Map<String, dynamic>?>()
        .firstWhere((e) => e?['id'] == widget.id, orElse: () => null);

    if (freshItem != null && freshItem['data'] is Map<String, dynamic>) {
      _currentData = freshItem['data'] as Map<String, dynamic>;
    }

    final title = _currentData['title'] as String? ?? 'Note';
    final content = _currentData['content'] as String? ?? '';
    final category =
        _currentData['category'] as String? ?? AppConstants.noteGeneral;
    final isLink = category == AppConstants.noteImportantLink;

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () async {
              await context.push(
                AppRoutes.addNote,
                extra: {'id': widget.id, 'data': _currentData},
              );
              ref.invalidate(notesProvider);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: context.palette.error),
            tooltip: 'Delete',
            onPressed: () async {
              final confirm = await showConfirmDialog(
                context,
                title: 'Delete Note',
                message: 'Delete "$title"? This cannot be undone.',
                confirmText: 'Delete',
                destructive: true,
              );
              if (confirm && context.mounted) {
                await IsarService.instance.deleteNote(widget.id);
                ref.invalidate(notesProvider);
                ref.invalidate(vaultCountsProvider);
                if (context.mounted) context.pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isLink ? Icons.link_rounded : Icons.sticky_note_2_outlined,
                  color: isLink
                      ? context.palette.primary
                      : context.palette.accentNotes,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isLink ? 'Important Link' : 'Note',
                  style: TextStyle(
                      color: context.palette.textSecondary, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.palette.border),
              ),
              child: SelectableText(
                content,
                style: TextStyle(
                    color: context.palette.textPrimary,
                    fontSize: 15,
                    height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
