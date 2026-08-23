import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

/// A privacy indicator banner to show when sensitive data is visible.
class PrivacyIndicatorBanner extends StatelessWidget {
  final VoidCallback? onHide;
  const PrivacyIndicatorBanner({super.key, this.onHide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: context.palette.warning.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip_outlined,
                  color: context.palette.textPrimary),
              const SizedBox(width: 8),
              Text(
                'Sensitive data visible',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (onHide != null)
            TextButton(
              onPressed: onHide,
              child: Text('Hide',
                  style: TextStyle(color: context.palette.textPrimary)),
            ),
        ],
      ),
    );
  }
}
