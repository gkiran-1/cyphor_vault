import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/auth/pin_service.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';

class PinEntryScreen extends ConsumerStatefulWidget {
  const PinEntryScreen({super.key});

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late final AnimationController _shakeController;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _onPINComplete(String pin) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final pinService = PINService.instance;

    if (pinService.isLocked) {
      setState(() {
        _error = 'Too many attempts. Use recovery phrase to reset.';
        _loading = false;
      });
      _shakeController.forward(from: 0);
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
      _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinService = PINService.instance;

    return PopScope(
      canPop: false,
      child: Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(Icons.lock_outline_rounded,
                      color: context.palette.primary, size: 56)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 500.ms,
                      curve: Curves.easeOutBack),
              const SizedBox(height: 24),
              Text(
                'Enter PIN',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                'Enter your PIN to unlock CipherBox',
                style:
                    TextStyle(color: context.palette.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
              const SizedBox(height: 48),
              Animate(
                autoPlay: false,
                controller: _shakeController,
                onComplete: (c) => c.reset(),
                effects: const [ShakeEffect(hz: 4, offset: Offset(6, 0))],
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _controller,
                  autoDisposeControllers: false,
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
                    activeFillColor: context.palette.surfaceLight,
                    inactiveFillColor: context.palette.surface,
                    selectedFillColor: context.palette.surfaceLight,
                    activeColor: context.palette.primary,
                    inactiveColor: context.palette.border,
                    selectedColor: context.palette.primary,
                  ),
                  enableActiveFill: true,
                  onChanged: (_) => setState(() => _error = null),
                  onCompleted: _onPINComplete,
                ),
              ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: context.palette.error, size: 14),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _error!,
                        style: TextStyle(
                            color: context.palette.error, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
              if (_loading) ...[
                const SizedBox(height: 20),
                CircularProgressIndicator(
                    color: context.palette.primary, strokeWidth: 2),
              ],
              const Spacer(flex: 2),
              TextButton(
                onPressed: () => context.go(AppRoutes.recoveryEntry),
                child: Text('Forgot PIN? Recover vault',
                    style: TextStyle(
                        color: context.palette.textSecondary, fontSize: 13)),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
