import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';

class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: context.palette.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, color: context.palette.success, size: 56),
              ).animate().scale(begin: const Offset(0, 0), curve: Curves.elasticOut, duration: 800.ms),
              const SizedBox(height: 32),
              Text(
                "You're all set!",
                style: TextStyle(
                    color: context.palette.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 12),
              Text(
                'CipherBox is ready to securely store\nyour sensitive data.',
                style: TextStyle(color: context.palette.textSecondary, fontSize: 15, height: 1.5),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go to My Vault'),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
