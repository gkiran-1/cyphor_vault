import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';

class SetupRecoveryScreen extends StatefulWidget {
  final String recoveryPhrase;
  const SetupRecoveryScreen({super.key, required this.recoveryPhrase});

  @override
  State<SetupRecoveryScreen> createState() => _SetupRecoveryScreenState();
}

class _SetupRecoveryScreenState extends State<SetupRecoveryScreen> {
  bool _confirmed = false;
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.recoveryPhrase));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = widget.recoveryPhrase.split('-');

    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.palette.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.key_rounded, color: context.palette.warning, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Save Your Recovery Phrase',
                      style: TextStyle(
                        color: context.palette.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.palette.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.palette.warning.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'If you forget your PIN, this phrase is the ONLY way to recover your vault. Write it down and store it somewhere safe.\n\nDo NOT screenshot or store digitally.',
                  style: TextStyle(
                    color: context.palette.warning,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.palette.border),
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: groups.asMap().entries.map((e) => _GroupChip(
                        index: e.key + 1,
                        value: e.value,
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _copy,
                      icon: Icon(
                        _copied ? Icons.check : Icons.copy_outlined,
                        size: 16,
                        color: _copied ? context.palette.success : context.palette.textSecondary,
                      ),
                      label: Text(
                        _copied ? 'Copied!' : 'Copy to clipboard',
                        style: TextStyle(
                          color: _copied ? context.palette.success : context.palette.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _copied
                              ? context.palette.success.withValues(alpha: 0.4)
                              : context.palette.border,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              CheckboxListTile(
                value: _confirmed,
                onChanged: (v) => setState(() => _confirmed = v ?? false),
                activeColor: context.palette.primary,
                checkColor: Colors.black,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'I have written down my recovery phrase and stored it safely.',
                  style: TextStyle(color: context.palette.textPrimary, fontSize: 14, height: 1.4),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmed
                      ? () => context.go(AppRoutes.setupBiometric)
                      : null,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupChip extends StatelessWidget {
  final int index;
  final String value;
  const _GroupChip({required this.index, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.palette.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$index.',
            style: TextStyle(color: context.palette.textSecondary, fontSize: 11),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: context.palette.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
