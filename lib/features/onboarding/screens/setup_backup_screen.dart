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
        title: const Text('Google Drive Backup'),
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
                'Connect Google Drive to automatically back up your encrypted vault.',
                style: TextStyle(
                    color: context.palette.textSecondary, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.palette.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.palette.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: context.palette.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Only encrypted .cipherbox files are uploaded. Google cannot read your data.',
                        style: TextStyle(
                            color: context.palette.textSecondary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () {
                  // Google Sign-In handled in backup settings after setup
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'You can connect Google Drive in Settings → Backup')),
                  );
                },
                icon: const Icon(Icons.cloud_outlined),
                label: const Text('Connect Google Drive'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.palette.primary,
                  side: BorderSide(color: context.palette.primary),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.setupComplete),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.setupComplete),
                  child: Text('Skip for now',
                      style: TextStyle(color: context.palette.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
