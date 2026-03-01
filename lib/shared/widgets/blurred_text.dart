import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/auth/biometric_service.dart';
import '../../core/utils/constants.dart';
import '../../shared/theme/app_colors.dart';

class BlurredText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool requireBiometric;

  const BlurredText({
    super.key,
    required this.text,
    this.style,
    this.requireBiometric = true,
  });

  @override
  State<BlurredText> createState() => _BlurredTextState();
}

class _BlurredTextState extends State<BlurredText> {
  bool _revealed = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  Future<void> _reveal() async {
    if (widget.requireBiometric) {
      final ok = await BiometricService.instance.authenticateForReveal();
      if (!ok) return;
    }
    setState(() => _revealed = true);
    _hideTimer?.cancel();
    _hideTimer = Timer(SecurityConstants.revealDuration, () {
      if (mounted) setState(() => _revealed = false);
    });
  }

  void _hide() {
    _hideTimer?.cancel();
    setState(() => _revealed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _revealed ? _hide : _reveal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _revealed
              ? Text(widget.text, style: widget.style)
              : Text(
                  '•' * widget.text.replaceAll(' ', '').length,
                  style: widget.style?.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 2,
                      ) ??
                      const TextStyle(
                        color: AppColors.textSecondary,
                        letterSpacing: 2,
                      ),
                ),
          const SizedBox(width: 8),
          Icon(
            _revealed
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.copy_outlined,
                size: 16, color: AppColors.textSecondary),
            tooltip: 'Copy',
            onPressed: _revealed
                ? () async {
                    await Clipboard.setData(ClipboardData(text: widget.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied!')),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
