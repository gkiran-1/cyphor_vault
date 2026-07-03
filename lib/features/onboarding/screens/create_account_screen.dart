import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/utils/validators.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../widgets/password_strength_indicator.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _obscurePin = true;
  bool _loading = false;
  int _passwordStrength = 0;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    await ref.read(authStateProvider.notifier).createAccount(
          pin: _pinCtrl.text,
        );

    if (!mounted) return;
    final authState = ref.read(authStateProvider);
    if (authState.error != null) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.error!)),
      );
    } else {
      context.go(AppRoutes.setupBiometric);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set up your CipherBox account.',
                    style: TextStyle(
                        color: context.palette.textSecondary, fontSize: 14)),
                const SizedBox(height: 28),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Master password
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePass,
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Master Password',
                    helperText: 'Min 8 characters',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: context.palette.textSecondary),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy_outlined,
                              size: 20, color: context.palette.textSecondary),
                          tooltip: 'Copy',
                          onPressed: () async {
                            final text = _passwordCtrl.text;
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
                  onChanged: (v) => setState(
                      () => _passwordStrength = Validators.passwordStrength(v)),
                  validator: Validators.masterPassword,
                ),
                const SizedBox(height: 8),
                PasswordStrengthIndicator(strength: _passwordStrength),
                const SizedBox(height: 16),

                // Confirm password
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: context.palette.textSecondary),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy_outlined,
                              size: 20, color: context.palette.textSecondary),
                          tooltip: 'Copy',
                          onPressed: () async {
                            final text = _confirmCtrl.text;
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
                      Validators.confirmPassword(v, _passwordCtrl.text),
                ),
                const SizedBox(height: 24),

                Divider(color: context.palette.border),
                const SizedBox(height: 16),
                Text('Set a PIN (4–6 digits)',
                    style: TextStyle(
                        color: context.palette.textSecondary, fontSize: 13)),
                const SizedBox(height: 12),

                // PIN
                TextFormField(
                  controller: _pinCtrl,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    counterText: '',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                              _obscurePin
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: context.palette.textSecondary),
                          onPressed: () =>
                              setState(() => _obscurePin = !_obscurePin),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy_outlined,
                              size: 20, color: context.palette.textSecondary),
                          tooltip: 'Copy',
                          onPressed: () async {
                            final text = _pinCtrl.text;
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
                  validator: Validators.pin,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
