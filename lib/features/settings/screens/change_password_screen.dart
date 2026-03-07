import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/encryption/key_manager.dart';
import '../../../core/utils/validators.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureOld = true, _obscureNew = true, _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final valid = await AuthService.instance.verifyPIN(_oldCtrl.text);
      if (!valid) {
        setState(() {
          _error = 'Current PIN is incorrect';
          _loading = false;
        });
        return;
      }

      await KeyManager.instance.changePIN(_newCtrl.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')));
        context.go(AppRoutes.settings);
      }
    } catch (e) {
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Change Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your master password protects all vault data. After changing it, all existing encrypted data remains accessible.',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5),
                ),
                const SizedBox(height: 32),
                _passField(_oldCtrl, 'Current Password', _obscureOld,
                    () => setState(() => _obscureOld = !_obscureOld),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null),
                const SizedBox(height: 16),
                _passField(_newCtrl, 'New Password', _obscureNew,
                    () => setState(() => _obscureNew = !_obscureNew),
                    validator: Validators.masterPassword),
                const SizedBox(height: 16),
                _passField(
                    _confirmCtrl,
                    'Confirm New Password',
                    _obscureConfirm,
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (v) =>
                        Validators.confirmPassword(v, _newCtrl.text)),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: const TextStyle(
                          color: AppColors.error, fontSize: 13)),
                ],
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passField(
    TextEditingController ctrl,
    String label,
    bool obscure,
    VoidCallback toggle, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary),
              onPressed: toggle,
            ),
            IconButton(
              icon: const Icon(Icons.copy_outlined,
                  size: 20, color: AppColors.textSecondary),
              tooltip: 'Copy',
              onPressed: () async {
                final text = ctrl.text;
                if (text.isNotEmpty) {
                  await Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      validator: validator,
    );
  }
}
