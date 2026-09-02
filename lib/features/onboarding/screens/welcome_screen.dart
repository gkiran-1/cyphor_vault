import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _features = [
    (icon: Icons.folder_outlined, text: 'Store documents, cards & IDs'),
    (icon: Icons.key_outlined, text: 'Manage passwords securely'),
    (icon: Icons.note_outlined, text: 'Keep private notes & links'),
    (icon: Icons.cloud_outlined, text: 'Encrypted backup & restore'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Logo — entrance scale + persistent subtle pulse
              const _PulseLogo(),
              const SizedBox(height: 24),
              Text(
                'CipherBox',
                style: TextStyle(
                    color: context.palette.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                'Your fully offline, zero-knowledge\npersonal vault. Your data stays on your device.',
                style: TextStyle(
                    color: context.palette.textSecondary, fontSize: 15, height: 1.5),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 350.ms),
              const SizedBox(height: 32),
              for (var i = 0; i < _features.length; i++) ...[
                _FeatureRow(
                  icon: _features[i].icon,
                  text: _features[i].text,
                )
                    .animate(delay: (400 + i * 120).ms)
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: -0.1, duration: 300.ms, curve: Curves.easeOut),
                if (i < _features.length - 1) const SizedBox(height: 14),
              ],
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.setupPin),
                  child: const Text('Get Started'),
                ),
              ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.restoreBackup),
                  icon: const Icon(Icons.restore_outlined, size: 18),
                  label: const Text('Restore from Backup'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.palette.textPrimary,
                    side: BorderSide(color: context.palette.border),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

// Entrance scale-in, then loops with a soft pulse
class _PulseLogo extends StatefulWidget {
  const _PulseLogo();

  @override
  State<_PulseLogo> createState() => _PulseLogoState();
}

class _PulseLogoState extends State<_PulseLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: context.palette.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: context.palette.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Icon(Icons.lock_outline_rounded,
            color: context.palette.primary, size: 46),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
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
            color: context.palette.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.palette.border),
          ),
          child: Icon(icon, color: context.palette.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Text(text,
            style:
                TextStyle(color: context.palette.textPrimary, fontSize: 15)),
      ],
    );
  }
}
