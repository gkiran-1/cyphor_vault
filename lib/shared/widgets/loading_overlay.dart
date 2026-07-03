import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.palette.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: context.palette.primary),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(message!,
                    style: TextStyle(color: context.palette.textSecondary, fontSize: 14)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Wraps a widget and shows a loading overlay on top when [loading] is true.
class WithLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool loading;
  final String? message;

  const WithLoadingOverlay({
    super.key,
    required this.child,
    required this.loading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading) LoadingOverlay(message: message),
      ],
    );
  }
}
