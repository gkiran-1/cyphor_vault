import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/constants.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';

class NoteDetailScreen extends StatelessWidget {
  final int id;
  final Map<String, dynamic> data;

  const NoteDetailScreen({super.key, required this.id, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? 'Note';
    final content = data['content'] as String? ?? '';
    final category = data['category'] as String? ?? AppConstants.noteGeneral;
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
            onPressed: () =>
                context.push(AppRoutes.addNote, extra: {'id': id, 'data': data}),
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
                  color: isLink ? context.palette.primary : const Color(0xFFFF9800),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.palette.border),
              ),
              child: SelectableText(
                content,
                style: TextStyle(
                    color: context.palette.textPrimary, fontSize: 15, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
