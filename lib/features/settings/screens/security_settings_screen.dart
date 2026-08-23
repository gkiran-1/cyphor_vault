import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/auth/biometric_service.dart';
import '../../../core/auth/pin_service.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/encryption/key_manager.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../shared/theme/app_palette.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  bool _changingPIN = false;
  final _newPinCtrl = TextEditingController();

  @override
  void dispose() {
    _newPinCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleBiometric(bool enable) async {
    final profile = await IsarService.instance.getUserProfile();
    if (profile == null) return;

    if (enable) {
      final ok = await BiometricService.instance.authenticate(
          reason: 'Enable biometric unlock for CipherBox');
      if (!ok) return;
      await KeyManager.instance.enableBiometric();
      profile.biometricEnabled = true;
    } else {
      await KeyManager.instance.disableBiometric();
      profile.biometricEnabled = false;
    }
    await IsarService.instance.saveUserProfile(profile);
    await ref.read(authStateProvider.notifier).reloadProfile();
    setState(() {});
  }

  Future<void> _savePIN(String pin) async {
    await PINService.instance.updatePIN(pin);
    setState(() => _changingPIN = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(authStateProvider).profile;
    final biometricEnabled = profile?.biometricEnabled ?? false;

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card([
            SwitchListTile(
              title: Text('Biometric Unlock',
                  style: TextStyle(color: context.palette.textPrimary)),
              subtitle: Text('Use fingerprint or Face ID to unlock',
                  style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
              value: biometricEnabled,
              onChanged: _toggleBiometric,
              activeThumbColor: context.palette.primary,
            ),
          ]),
          const SizedBox(height: 16),
          _card([
            ListTile(
              title: Text('Change PIN',
                  style: TextStyle(color: context.palette.textPrimary)),
              subtitle: Text('Update your vault unlock PIN',
                  style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
              trailing: Icon(Icons.chevron_right, color: context.palette.textSecondary),
              onTap: () => setState(() => _changingPIN = !_changingPIN),
            ),
            if (_changingPIN) ...[
              Divider(color: context.palette.border),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter new PIN (4–6 digits)',
                        style: TextStyle(color: context.palette.textSecondary, fontSize: 13)),
                    const SizedBox(height: 12),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _newPinCtrl,
                      autoDisposeControllers: false,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 44,
                        fieldWidth: 38,
                        activeFillColor: context.palette.surfaceLight,
                        inactiveFillColor: context.palette.background,
                        selectedFillColor: context.palette.surfaceLight,
                        activeColor: context.palette.primary,
                        inactiveColor: context.palette.border,
                        selectedColor: context.palette.primary,
                      ),
                      enableActiveFill: true,
                      onChanged: (_) {},
                      onCompleted: _savePIN,
                    ),
                  ],
                ),
              ),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(children: children),
    );
  }
}
