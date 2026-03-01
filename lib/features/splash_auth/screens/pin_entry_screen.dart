import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/auth/pin_service.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';

class PinEntryScreen extends ConsumerStatefulWidget {
  const PinEntryScreen({super.key});

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onPINComplete(String pin) async {
    if (_loading) return;
    setState(() { _loading = true; _error = null; });

    final pinService = PINService.instance;

    if (pinService.isLocked) {
      setState(() { _error = 'Too many attempts. Use recovery phrase to reset.'; _loading = false; });
      return;
    }

    final success = await pinService.verifyPIN(pin);
    if (!mounted) return;

    if (success) {
      setState(() => _loading = false);
    } else {
      final remaining = PINService.maxAttempts - pinService.failedAttempts;
      _controller.clear();
      setState(() {
        _error = pinService.isLocked
            ? 'Too many failed attempts.'
            : 'Incorrect PIN. $remaining attempt${remaining == 1 ? '' : 's'} remaining.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinService = PINService.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 56),
              const SizedBox(height: 24),
              const Text(
                'Enter PIN',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your PIN to unlock CipherBox',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _controller,
                obscureText: true,
                obscuringCharacter: '●',
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                enabled: !pinService.isLocked && !_loading,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 52,
                  fieldWidth: 44,
                  activeFillColor: AppColors.surfaceLight,
                  inactiveFillColor: AppColors.surface,
                  selectedFillColor: AppColors.surfaceLight,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.border,
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
                onChanged: (_) => setState(() => _error = null),
                onCompleted: _onPINComplete,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13),
                    textAlign: TextAlign.center),
              ],
              if (_loading) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
              ],
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => context.go(AppRoutes.recoveryEntry),
                child: const Text('Forgot PIN? Recover vault',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
