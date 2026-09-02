import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../../../shared/widgets/blurred_text.dart';

class PasswordDetailScreen extends StatelessWidget {
  final int id;
  final Map<String, dynamic> data;

  const PasswordDetailScreen({super.key, required this.id, required this.data});

  @override
  Widget build(BuildContext context) {
    final siteName = data['siteName'] as String? ?? 'Password';
    final url = data['url'] as String? ?? '';
    final username = data['username'] as String? ?? '';
    final password = data['password'] as String? ?? '';
    final notes = data['notes'] as String? ?? '';

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: Text(siteName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context
                .push(AppRoutes.addPassword, extra: {'id': id, 'data': data}),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DetailSection(
            children: [
              _DetailTile(label: 'Website URL', value: url, copyable: false),
              _DetailTile(label: 'Site Name', value: siteName, copyable: false),
            ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            children: [
              _DetailTile(
                  label: 'Username / Email', value: username, copyable: true),
              _SensitiveTile(label: 'Password', value: password),
            ],
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            _DetailSection(
              children: [
                _DetailTile(label: 'Notes', value: notes, copyable: false)
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final List<Widget> children;
  const _DetailSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: children
            .expand(
                (w) => [w, Divider(color: context.palette.border, height: 1)])
            .toList()
          ..removeLast(),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;

  const _DetailTile(
      {required this.label, required this.value, required this.copyable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: context.palette.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        color: context.palette.textPrimary, fontSize: 15)),
              ],
            ),
          ),
          if (copyable && value.isNotEmpty)
            IconButton(
              icon: Icon(Icons.copy_outlined,
                  size: 18, color: context.palette.textSecondary),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Copied!')));
              },
            ),
        ],
      ),
    );
  }
}

class _SensitiveTile extends StatelessWidget {
  final String label;
  final String value;

  const _SensitiveTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: context.palette.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          BlurredText(text: value, requireBiometric: true),
        ],
      ),
    );
  }
}
