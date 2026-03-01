import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.primary, size: 52),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
              const SizedBox(height: 32),
              const Text(
                'CipherBox',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              const Text(
                'Your fully offline, zero-knowledge\npersonal vault. Your data stays on your device.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 15, height: 1.5),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 48),
              _FeatureRow(icon: Icons.folder_outlined, text: 'Store documents, cards & IDs'),
              const SizedBox(height: 16),
              _FeatureRow(icon: Icons.key_outlined, text: 'Manage passwords securely'),
              const SizedBox(height: 16),
              _FeatureRow(icon: Icons.note_outlined, text: 'Keep private notes & links'),
              const SizedBox(height: 16),
              _FeatureRow(icon: Icons.cloud_outlined, text: 'Encrypted Google Drive backup'),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.setupPin),
                child: const Text('Get Started'),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Text(text,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
      ],
    );
  }
}
