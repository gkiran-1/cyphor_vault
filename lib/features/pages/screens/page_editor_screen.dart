import 'dart:convert';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/utils/constants.dart';
import '../../../shared/theme/app_palette.dart';
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
  late final EditorState _editorState;
  late final EditorScrollController _scrollController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      final pageDoc = PageDocument.fromJson(widget.existingData!);
      _titleCtrl = TextEditingController(text: pageDoc.title);
      _editorState = EditorState(
        document: Document.fromJson(pageDoc.document),
      );
    } else {
      _titleCtrl = TextEditingController();
      _editorState = EditorState.blank(withInitialText: true);
    }
    _scrollController = EditorScrollController(
      editorState: _editorState,
      shrinkWrap: false,
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _editorState.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  EditorStyle _buildEditorStyle() {
    return EditorStyle.mobile(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      cursorColor: context.palette.primary,
      dragHandleColor: context.palette.primary,
      selectionColor: context.palette.primary.withValues(alpha: 0.25),
      textStyleConfiguration: TextStyleConfiguration(
        text: TextStyle(
          color: context.palette.textPrimary,
          fontSize: 16,
          height: 1.6,
        ),
        bold: TextStyle(fontWeight: FontWeight.w700),
        italic: TextStyle(fontStyle: FontStyle.italic),
        underline: TextStyle(decoration: TextDecoration.underline),
        strikethrough: TextStyle(decoration: TextDecoration.lineThrough),
        code: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: context.palette.success,
          backgroundColor: context.palette.surfaceLight,
        ),
        href: TextStyle(color: context.palette.primary),
      ),
    );
  }

  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    return {
      ...standardBlockComponentBuilderMap,
      HeadingBlockKeys.type: HeadingBlockComponentBuilder(
        textStyleBuilder: (level) {
          final sizes = [28.0, 22.0, 18.0];
          return TextStyle(
            color: context.palette.textPrimary,
            fontSize: sizes.elementAtOrNull(level - 1) ?? 16.0,
            fontWeight: FontWeight.w700,
            height: 1.4,
          );
        },
      ),
      ParagraphBlockKeys.type: ParagraphBlockComponentBuilder(
        configuration: BlockComponentConfiguration(
          placeholderText: (node) => "Type '/' for commands…",
          textStyle: (node, {textSpan}) => TextStyle(
            color: context.palette.textPrimary,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
      QuoteBlockKeys.type: QuoteBlockComponentBuilder(
        configuration: BlockComponentConfiguration(
          textStyle: (node, {textSpan}) => TextStyle(
            color: context.palette.textSecondary,
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    };
  }

  Future<void> _pickAndInsertImage() async {
    // Save selection before async operations steal editor focus.
    final savedSelection = _editorState.selection;

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
          const SnackBar(
              content: Text('Image too large (max 5 MB).')),
        );
      }
      return;
    }

    // Restore selection so insertImageNode can place the image correctly.
    // If the saved selection is gone, fall back to the last node in the document.
    if (_editorState.selection == null) {
      if (savedSelection != null) {
        _editorState.selection = savedSelection;
      } else {
        final children = _editorState.document.root.children;
        if (children.isNotEmpty) {
          _editorState.selection = Selection.collapsed(
            Position(path: children.last.path, offset: 0),
          );
        }
      }
    }

    final b64 = base64Encode(bytes);
    await _editorState.insertImageNode(b64);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final title =
          _titleCtrl.text.trim().isEmpty ? 'Untitled' : _titleCtrl.text.trim();
      final docJson = _editorState.document.toJson();
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
    // Defined here to capture [_pickAndInsertImage] from this State.
    final imageToolbarItem = MobileToolbarItem.action(
      itemIconBuilder: (ctx, _, __) => Icon(
        Icons.image_outlined,
        color: MobileToolbarTheme.of(ctx).iconColor,
        size: 22,
      ),
      actionHandler: (ctx, editorState) => _pickAndInsertImage(),
    );

    return Scaffold(
      backgroundColor: context.palette.background,
      // IMPORTANT: must be false — MobileToolbarV2 handles keyboard insets itself.
      resizeToAvoidBottomInset: false,
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
          if (_saving)
            Padding(
              padding: EdgeInsets.all(16),
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
                      color: context.palette.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      // No SafeArea here — MobileToolbarV2 manages bottom insets / keyboard.
      body: MobileToolbarV2(
        backgroundColor: context.palette.surface,
        foregroundColor: context.palette.textSecondary,
        iconColor: context.palette.textPrimary,
        itemHighlightColor: context.palette.primary,
        primaryColor: context.palette.primary,
        onPrimaryColor: context.palette.background,
        outlineColor: context.palette.border,
        toolbarItems: [
          textDecorationMobileToolbarItemV2,
          buildTextAndBackgroundColorMobileToolbarItem(),
          blocksMobileToolbarItem,
          dividerMobileToolbarItem,
          imageToolbarItem,
        ],
        editorState: _editorState,
        child: Column(
          children: [
            Expanded(
              child: MobileFloatingToolbar(
                editorState: _editorState,
                editorScrollController: _scrollController,
                floatingToolbarHeight: 36,
                toolbarBuilder: (context, anchor, closeToolbar) {
                  return AdaptiveTextSelectionToolbar.editable(
                    clipboardStatus: ClipboardStatus.pasteable,
                    onCopy: () {
                      copyCommand.execute(_editorState);
                      closeToolbar();
                    },
                    onCut: () => cutCommand.execute(_editorState),
                    onPaste: () => pasteCommand.execute(_editorState),
                    onSelectAll: () => selectAllCommand.execute(_editorState),
                    onLiveTextInput: null,
                    onLookUp: null,
                    onSearchWeb: null,
                    onShare: null,
                    anchors:
                        TextSelectionToolbarAnchors(primaryAnchor: anchor),
                  );
                },
                child: AppFlowyEditor(
                  editorState: _editorState,
                  editorScrollController: _scrollController,
                  editorStyle: _buildEditorStyle(),
                  blockComponentBuilders: _buildBlockComponentBuilders(),
                  // Auto-focus on new pages so toolbar is immediately visible.
                  autoFocus: widget.existingId == null,
                  footer: const SizedBox(height: 80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
