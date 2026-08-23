import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../models/page_document.dart';

class PageViewScreen extends StatefulWidget {
  final int id;
  final Map<String, dynamic> data;

  const PageViewScreen({super.key, required this.id, required this.data});

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  late final EditorState _editorState;
  late final EditorScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final pageDoc = PageDocument.fromJson(widget.data);
    _editorState = EditorState(
      document: Document.fromJson(pageDoc.document),
    );
    _scrollController = EditorScrollController(
      editorState: _editorState,
      shrinkWrap: false,
    );
  }

  @override
  void dispose() {
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
        bold: const TextStyle(fontWeight: FontWeight.w700),
        italic: const TextStyle(fontStyle: FontStyle.italic),
        underline: const TextStyle(decoration: TextDecoration.underline),
        strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
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

  @override
  Widget build(BuildContext context) {
    final pageDoc = PageDocument.fromJson(widget.data);
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
            onPressed: () => context.push(
              AppRoutes.editPage,
              extra: {'id': widget.id, 'data': widget.data},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AppFlowyEditor(
          editorState: _editorState,
          editorScrollController: _scrollController,
          editorStyle: _buildEditorStyle(),
          blockComponentBuilders: _buildBlockComponentBuilders(),
          editable: false,
          footer: const SizedBox(height: 80),
        ),
      ),
    );
  }
}
