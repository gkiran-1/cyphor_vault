import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/password_generator.dart';
import '../../../shared/theme/app_palette.dart';

class AddEditPasswordScreen extends ConsumerStatefulWidget {
  final int? existingId;
  final Map<String, dynamic>? existingData;

  const AddEditPasswordScreen({super.key, this.existingId, this.existingData});

  @override
  ConsumerState<AddEditPasswordScreen> createState() =>
      _AddEditPasswordScreenState();
}

class _AddEditPasswordScreenState extends ConsumerState<AddEditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _urlCtrl =
      TextEditingController(text: widget.existingData?['url'] ?? '');
  late final _siteCtrl =
      TextEditingController(text: widget.existingData?['siteName'] ?? '');
  late final _userCtrl =
      TextEditingController(text: widget.existingData?['username'] ?? '');
  late final _passCtrl =
      TextEditingController(text: widget.existingData?['password'] ?? '');
  late final _notesCtrl =
      TextEditingController(text: widget.existingData?['notes'] ?? '');
  bool _obscure = true;
  bool _loading = false;
  bool _showGenerator = false;
  int _genLength = 16;
  bool _genUpper = true,
      _genLower = true,
      _genNumbers = true,
      _genSymbols = true;
  String _generated = '';

  @override
  void dispose() {
    _urlCtrl.dispose();
    _siteCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _generate() {
    setState(() {
      _generated = PasswordGenerator.generate(
        length: _genLength,
        includeUppercase: _genUpper,
        includeLowercase: _genLower,
        includeNumbers: _genNumbers,
        includeSymbols: _genSymbols,
      );
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await savePassword(
        data: {
          'url': _urlCtrl.text.trim(),
          'siteName': _siteCtrl.text.trim(),
          'username': _userCtrl.text.trim(),
          'password': _passCtrl.text,
          'notes': _notesCtrl.text.trim(),
        },
        existingId: widget.existingId,
      );
      ref.invalidate(passwordsProvider);
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
        title: Text(isEdit ? 'Edit Password' : 'Add Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(_urlCtrl, 'Website URL',
                    validator: Validators.url, keyboard: TextInputType.url),
                const SizedBox(height: 14),
                _field(_siteCtrl, 'Site Name',
                    validator: (v) =>
                        Validators.required(v, fieldName: 'Site name')),
                const SizedBox(height: 14),
                _field(_userCtrl, 'Username / Email',
                    keyboard: TextInputType.emailAddress),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: context.palette.textSecondary),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy_outlined,
                              size: 20, color: context.palette.textSecondary),
                          tooltip: 'Copy',
                          onPressed: () async {
                            final text = _passCtrl.text;
                            if (text.isNotEmpty) {
                              await Clipboard.setData(
                                  ClipboardData(text: text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied!')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  validator: (v) =>
                      Validators.required(v, fieldName: 'Password'),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _showGenerator = !_showGenerator);
                    if (_showGenerator) _generate();
                  },
                  icon: const Icon(Icons.casino_outlined, size: 18),
                  label: const Text('Generate Password'),
                  style:
                      TextButton.styleFrom(foregroundColor: context.palette.primary),
                ),
                if (_showGenerator) _buildGenerator(),
                const SizedBox(height: 14),
                _field(_notesCtrl, 'Notes (optional)', maxLines: 3),
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

  Widget _field(TextEditingController ctrl, String label,
      {String? Function(String?)? validator,
      TextInputType? keyboard,
      int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: TextStyle(color: context.palette.textPrimary),
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }

  Widget _buildGenerator() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Length:',
                  style: TextStyle(color: context.palette.textSecondary)),
              Expanded(
                child: Slider(
                  value: _genLength.toDouble(),
                  min: 8,
                  max: 32,
                  divisions: 24,
                  activeColor: context.palette.primary,
                  onChanged: (v) {
                    setState(() => _genLength = v.round());
                    _generate();
                  },
                ),
              ),
              Text('$_genLength',
                  style: TextStyle(color: context.palette.textPrimary)),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              _chip('A–Z', _genUpper, (v) {
                _genUpper = v;
                _generate();
              }),
              _chip('a–z', _genLower, (v) {
                _genLower = v;
                _generate();
              }),
              _chip('0–9', _genNumbers, (v) {
                _genNumbers = v;
                _generate();
              }),
              _chip('!@#', _genSymbols, (v) {
                _genSymbols = v;
                _generate();
              }),
            ],
          ),
          const SizedBox(height: 12),
          if (_generated.isNotEmpty) ...[
            Text(_generated,
                style: TextStyle(
                    color: context.palette.primary,
                    fontFamily: 'monospace',
                    fontSize: 15)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _passCtrl.text = _generated;
                  setState(() => _showGenerator = false);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.palette.primary,
                  side: BorderSide(color: context.palette.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Use This Password'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, void Function(bool) onChanged) {
    return FilterChip(
      label: Text(label,
          style: TextStyle(
              color: selected ? context.palette.primary : context.palette.textSecondary,
              fontSize: 12)),
      selected: selected,
      onSelected: (v) {
        setState(() => onChanged(v));
      },
      selectedColor: context.palette.primary.withValues(alpha: 0.15),
      checkmarkColor: context.palette.primary,
      backgroundColor: context.palette.surfaceLight,
      side: BorderSide(color: selected ? context.palette.primary : context.palette.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
