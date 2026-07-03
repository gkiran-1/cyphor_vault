import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/auth/biometric_service.dart';
import '../../core/utils/constants.dart';
import '../../shared/theme/app_palette.dart';

typedef SensitiveRevealCallback = void Function(bool revealed);

class BlurredText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool requireBiometric;
  final SensitiveRevealCallback? onReveal;

  const BlurredText({
    super.key,
    required this.text,
    this.style,
    this.requireBiometric = true,
    this.onReveal,
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
    widget.onReveal?.call(true);
    _hideTimer?.cancel();
    _hideTimer = Timer(SecurityConstants.revealDuration, () {
      if (mounted) {
        setState(() => _revealed = false);
        widget.onReveal?.call(false);
      }
    });
  }

  void _hide() {
    _hideTimer?.cancel();
    setState(() => _revealed = false);
    widget.onReveal?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _revealed ? _hide : _reveal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: _revealed
                  ? Text(widget.text, style: widget.style)
                  : Text(
                      '•' * widget.text.replaceAll(' ', '').length,
                      style: widget.style?.copyWith(
                            color: context.palette.textSecondary,
                            letterSpacing: 2,
                          ) ??
                          TextStyle(
                            color: context.palette.textSecondary,
                            letterSpacing: 2,
                          ),
                    ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                _revealed
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: context.palette.textSecondary,
              ),
              tooltip: _revealed ? 'Hide' : 'Reveal',
              onPressed: _revealed ? _hide : _reveal,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.copy_outlined,
                  size: 20, color: context.palette.textSecondary),
              tooltip: 'Copy',
              onPressed: _revealed
                  ? () async {
                      await Clipboard.setData(ClipboardData(text: widget.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied!')),
                      );
                    }
                  : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
