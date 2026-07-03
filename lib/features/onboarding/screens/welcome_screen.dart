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
    (icon: Icons.cloud_outlined, text: 'Encrypted Google Drive backup'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(),
              // Logo — entrance scale + persistent subtle pulse
              _PulseLogo(),
              const SizedBox(height: 32),
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
              const SizedBox(height: 48),
              for (var i = 0; i < _features.length; i++) ...[
                _FeatureRow(
                  icon: _features[i].icon,
                  text: _features[i].text,
                )
                    .animate(delay: (400 + i * 120).ms)
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: -0.1, duration: 300.ms, curve: Curves.easeOut),
                if (i < _features.length - 1) const SizedBox(height: 16),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.setupPin),
                child: const Text('Get Started'),
              ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: context.palette.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: context.palette.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Icon(Icons.lock_outline_rounded,
            color: context.palette.primary, size: 52),
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
