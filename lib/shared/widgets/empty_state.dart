import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_palette.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: context.palette.surface,
                shape: BoxShape.circle,
                border: Border.all(color: context.palette.border, width: 1),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 48, color: context.palette.textSecondary),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                    begin: 0,
                    end: -8,
                    duration: 2200.ms,
                    curve: Curves.easeInOut),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                color: context.palette.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                  color: context.palette.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 28), action!],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.08, duration: 400.ms, curve: Curves.easeOut);
  }
}
