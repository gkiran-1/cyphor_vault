import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/biometric_service.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/encryption/key_manager.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';

class SetupBiometricScreen extends ConsumerStatefulWidget {
  const SetupBiometricScreen({super.key});

  @override
  ConsumerState<SetupBiometricScreen> createState() =>
      _SetupBiometricScreenState();
}

class _SetupBiometricScreenState extends ConsumerState<SetupBiometricScreen> {
  bool _biometricEnabled = false;
  bool _loading = false;

  Future<void> _enableBiometric() async {
    setState(() => _loading = true);
    final ok = await BiometricService.instance.authenticate(
      reason: 'Set up biometric unlock for CipherBox',
    );
    if (!ok) {
      setState(() => _loading = false);
      return;
    }
    await KeyManager.instance.enableBiometric();
    final profile = await IsarService.instance.getUserProfile();
    if (profile != null) {
      profile.biometricEnabled = true;
      await IsarService.instance.saveUserProfile(profile);
    }
    setState(() {
      _biometricEnabled = true;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Biometric Setup'),
        automaticallyImplyLeading: true,
        // Optionally, you can provide a custom back button:
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).maybePop(),
        // ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enable biometric unlock for fast, secure access to your vault.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),
              _OptionCard(
                icon: Icons.fingerprint,
                title: 'Fingerprint / Face ID',
                subtitle: 'Unlock instantly using your biometrics',
                enabled: _biometricEnabled,
                onTap: _biometricEnabled
                    ? null
                    : (_loading ? null : _enableBiometric),
                loading: _loading,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.setupBackup),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.setupBackup),
                  child: const Text('Skip for now',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;
  final bool loading;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? AppColors.success : AppColors.border,
            width: enabled ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: enabled ? AppColors.success : AppColors.primary,
                size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            if (loading)
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary))
            else if (enabled)
              const Icon(Icons.check_circle, color: AppColors.success)
            else
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
