import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class AddEditNoteScreen extends ConsumerStatefulWidget {
  final int? existingId;
  final Map<String, dynamic>? existingData;

  const AddEditNoteScreen({super.key, this.existingId, this.existingData});

  @override
  ConsumerState<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends ConsumerState<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl =
      TextEditingController(text: widget.existingData?['title'] ?? '');
  late final _contentCtrl =
      TextEditingController(text: widget.existingData?['content'] ?? '');
  late String _category =
      widget.existingData?['category'] ?? AppConstants.noteGeneral;
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (widget.existingId == null) return;
    final title =
        _titleCtrl.text.trim().isEmpty ? 'Note' : _titleCtrl.text.trim();
    final confirm = await showConfirmDialog(
      context,
      title: 'Delete Note',
      message: 'Delete "$title"? This cannot be undone.',
      confirmText: 'Delete',
      destructive: true,
    );
    if (confirm && mounted) {
      await IsarService.instance.deleteNote(widget.existingId!);
      ref.invalidate(notesProvider);
      ref.invalidate(vaultCountsProvider);
      if (mounted) {
        context.pop();
        if (context.canPop()) {
          context.pop();
        }
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await saveNote(
        data: {
          'title': _titleCtrl.text.trim(),
          'content': _contentCtrl.text.trim(),
          'category': _category,
        },
        existingId: widget.existingId,
      );
      ref.invalidate(notesProvider);
      ref.invalidate(vaultCountsProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingId != null;
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Note' : 'Add Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isEdit)
            IconButton(
              icon: Icon(Icons.delete_outline, color: context.palette.error),
              tooltip: 'Delete',
              onPressed: _delete,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category',
                    style: TextStyle(
                        color: context.palette.textSecondary, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _CategoryChip(
                      label: 'Note',
                      icon: Icons.sticky_note_2_outlined,
                      selected: _category == AppConstants.noteGeneral,
                      onTap: () =>
                          setState(() => _category = AppConstants.noteGeneral),
                    ),
                    const SizedBox(width: 10),
                    _CategoryChip(
                      label: 'Important Link',
                      icon: Icons.link_rounded,
                      selected: _category == AppConstants.noteImportantLink,
                      onTap: () => setState(
                          () => _category = AppConstants.noteImportantLink),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleCtrl,
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => Validators.required(v, fieldName: 'Title'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _contentCtrl,
                  maxLines: 8,
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: InputDecoration(
                    labelText: _category == AppConstants.noteImportantLink
                        ? 'URL / Content'
                        : 'Content',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) =>
                      Validators.required(v, fieldName: 'Content'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? context.palette.primary.withValues(alpha: 0.15)
              : context.palette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? context.palette.primary : context.palette.border),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: selected ? context.palette.primary : context.palette.textSecondary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color:
                        selected ? context.palette.primary : context.palette.textSecondary,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
