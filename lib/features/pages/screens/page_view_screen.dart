import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../models/page_document.dart';

class PageViewScreen extends ConsumerStatefulWidget {
  final int id;
  final Map<String, dynamic> data;

  const PageViewScreen({super.key, required this.id, required this.data});

  @override
  ConsumerState<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends ConsumerState<PageViewScreen> {
  late QuillController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    final pageDoc = PageDocument.fromJson(_currentData);
    _controller = QuillController(
      document: pageDoc.toQuillDocument(),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyNewData(Map<String, dynamic> newData) {
    _currentData = newData;
    final pageDoc = PageDocument.fromJson(newData);
    _controller.document = pageDoc.toQuillDocument();
  }

  @override
  Widget build(BuildContext context) {
    // Watch pagesProvider to reactively reflect any edits immediately.
    final pagesAsync = ref.watch(pagesProvider);
    final freshItem = pagesAsync.asData?.value
        .cast<Map<String, dynamic>?>()
        .firstWhere((e) => e?['id'] == widget.id, orElse: () => null);

    if (freshItem != null && freshItem['data'] is Map<String, dynamic>) {
      final freshData = freshItem['data'] as Map<String, dynamic>;
      if (_currentData != freshData) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _applyNewData(freshData);
            });
          }
        });
      }
    }

    final pageDoc = PageDocument.fromJson(_currentData);
    final title = pageDoc.title;
    final emoji = pageDoc.coverEmoji;

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            if (emoji != null) ...[
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.palette.textPrimary),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: context.palette.primary),
            tooltip: 'Edit',
            onPressed: () async {
              await context.push(
                AppRoutes.editPage,
                extra: {'id': widget.id, 'data': _currentData},
              );
              ref.invalidate(pagesProvider);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: context.palette.error),
            tooltip: 'Delete',
            onPressed: () async {
              final confirm = await showConfirmDialog(
                context,
                title: 'Delete Page',
                message: 'Delete "$title"? This cannot be undone.',
                confirmText: 'Delete',
                destructive: true,
              );
              if (confirm && context.mounted) {
                await IsarService.instance.deletePage(widget.id);
                ref.invalidate(pagesProvider);
                ref.invalidate(vaultCountsProvider);
                if (context.mounted) context.pop();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: QuillEditor.basic(
          controller: _controller,
          focusNode: _focusNode,
          scrollController: _scrollController,
          config: const QuillEditorConfig(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ),
      ),
    );
  }
}
