import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_palette.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Just show a loading indicator. Auth logic is handled by the router/provider.
    return Scaffold(
      backgroundColor: context.palette.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: context.palette.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: context.palette.primary.withOpacity(0.3), width: 1.5),
              ),
              child: Icon(Icons.lock_outline_rounded,
                  color: context.palette.primary, size: 48),
            ).animate().fadeIn(duration: 600.ms).scale(
                begin: const Offset(0.8, 0.8),
                duration: 600.ms,
                curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(
              'CipherBox',
              style: TextStyle(
                color: context.palette.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
            const SizedBox(height: 8),
            Text(
              'Your secure personal vault',
              style: TextStyle(color: context.palette.textSecondary, fontSize: 14),
            ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
