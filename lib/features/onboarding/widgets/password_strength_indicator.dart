import 'package:flutter/material.dart';
import '../../../shared/theme/app_palette.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int strength; // 0–4

  const PasswordStrengthIndicator({super.key, required this.strength});

  Color _color(BuildContext context) {
    switch (strength) {
      case 0: return context.palette.error;
      case 1: return context.palette.error;
      case 2: return context.palette.warning;
      case 3: return const Color(0xFF8BC34A);
      default: return context.palette.success;
    }
  }

  String get _label {
    switch (strength) {
      case 0: return 'Very weak';
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Strong';
      default: return 'Very strong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: i < strength ? _color(context) : context.palette.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        if (strength > 0) ...[
          const SizedBox(height: 4),
          Text(_label, style: TextStyle(color: _color(context), fontSize: 12)),
        ],
      ],
    );
  }
}
