import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/utils/constants.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../models/page_document.dart';

class PageEditorScreen extends ConsumerStatefulWidget {
  final int? existingId;
  final Map<String, dynamic>? existingData;

  const PageEditorScreen({super.key, this.existingId, this.existingData});

  @override
  ConsumerState<PageEditorScreen> createState() => _PageEditorScreenState();
}

class _PageEditorScreenState extends ConsumerState<PageEditorScreen> {
  late final TextEditingController _titleCtrl;
  late final QuillController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();

    if (widget.existingData != null) {
      final pageDoc = PageDocument.fromJson(widget.existingData!);
      _titleCtrl = TextEditingController(text: pageDoc.title);
      _controller = QuillController(
        document: pageDoc.toQuillDocument(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _titleCtrl = TextEditingController();
      _controller = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAndInsertImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: context.palette.surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_outlined,
                  color: context.palette.primary),
              title: Text('Gallery',
                  style: TextStyle(color: context.palette.textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined,
                  color: context.palette.primary),
              title: Text('Camera',
                  style: TextStyle(color: context.palette.textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final file = await picker.pickImage(
      source: source,
      imageQuality: SecurityConstants.imageCompressionQuality,
      maxWidth: 1200,
    );
    if (file == null || !mounted) return;

    final bytes = await file.readAsBytes();
    if (bytes.length > SecurityConstants.maxImageSizeBytes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image too large (max 5 MB).')),
        );
      }
      return;
    }

    final b64 = base64Encode(bytes);
    final imageUrl = 'data:image/png;base64,$b64';
    final index = _controller.selection.baseOffset;
    final length = _controller.selection.extentOffset - index;
    _controller.replaceText(
      index < 0 ? 0 : index,
      length < 0 ? 0 : length,
      BlockEmbed.image(imageUrl),
      null,
    );
  }

  Future<void> _delete() async {
    if (widget.existingId == null) return;
    final title =
        _titleCtrl.text.trim().isEmpty ? 'Untitled' : _titleCtrl.text.trim();
    final confirm = await showConfirmDialog(
      context,
      title: 'Delete Page',
      message: 'Delete "$title"? This cannot be undone.',
      confirmText: 'Delete',
      destructive: true,
    );
    if (confirm && mounted) {
      await IsarService.instance.deletePage(widget.existingId!);
      ref.invalidate(pagesProvider);
      ref.invalidate(vaultCountsProvider);
      if (mounted) {
        context.pop();
        // If we came from detail screen, pop that too
        if (context.canPop()) {
          context.pop();
        }
      }
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final title =
          _titleCtrl.text.trim().isEmpty ? 'Untitled' : _titleCtrl.text.trim();
      final docJson = _controller.document.toDelta().toJson();
      final pageDoc = PageDocument(title: title, document: docJson);
      await savePage(data: pageDoc.toJson(), existingId: widget.existingId);
      ref.invalidate(pagesProvider);
      ref.invalidate(vaultCountsProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.surface,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Discard',
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _titleCtrl,
          style: TextStyle(
              color: context.palette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Untitled',
            hintStyle: TextStyle(color: context.palette.textSecondary),
            border: InputBorder.none,
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          if (widget.existingId != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: context.palette.error),
              tooltip: 'Delete',
              onPressed: _delete,
            ),
          if (_saving)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: context.palette.primary)),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text('Save',
                  style: TextStyle(
                      color: context.palette.primary,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: Column(
        children: [
          QuillSimpleToolbar(
            controller: _controller,
            config: QuillSimpleToolbarConfig(
              showFontFamily: false,
              showFontSize: false,
              showSearchButton: false,
              showSubscript: false,
              showSuperscript: false,
              showAlignmentButtons: false,
              showDirection: false,
              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: Icon(Icons.image_outlined,
                      color: context.palette.textPrimary),
                  tooltip: 'Insert Image',
                  onPressed: _pickAndInsertImage,
                ),
              ],
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              focusNode: _focusNode,
              scrollController: _scrollController,
              config: QuillEditorConfig(
                placeholder: "Type '/' for commands…",
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                autoFocus: widget.existingId == null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
