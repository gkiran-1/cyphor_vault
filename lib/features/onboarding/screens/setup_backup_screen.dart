import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';

class SetupBackupScreen extends StatelessWidget {
  const SetupBackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: const Text('Vault Backup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zero-Knowledge Encrypted Backups',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can export your complete vault into a secure .cipherbox backup anytime from Settings → Backup & Restore.',
                style: TextStyle(
                  color: context.palette.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.palette.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.palette.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock_outline, color: context.palette.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your backup is encrypted with AES-256-GCM. It can be decrypted using either your PIN or your 32-character Cipher Key.',
                        style: TextStyle(
                          color: context.palette.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.setupComplete),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
