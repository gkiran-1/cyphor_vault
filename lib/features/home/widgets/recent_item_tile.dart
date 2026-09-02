import 'package:flutter/material.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/theme/app_palette.dart';

class RecentItemTile extends StatelessWidget {
  final VaultItemSummary item;
  final VoidCallback onTap;

  const RecentItemTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  Color _accentColor(BuildContext context) {
    switch (item.type) {
      case VaultItemType.document:
        return context.palette.accentDocuments;
      case VaultItemType.note:
        return context.palette.accentNotes;
      case VaultItemType.password:
        return context.palette.accentPasswords;
      case VaultItemType.page:
        return context.palette.accentPages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(context);
    final relativeTime = DateFormatter.formatRelative(item.updatedAt);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: context.palette.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.22),
                    width: 1,
                  ),
                ),
                child: Icon(item.icon, color: accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: context.palette.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.palette.surfaceLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: context.palette.border,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            relativeTime,
                            style: TextStyle(
                              color: context.palette.textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.type.displayName,
                          style: TextStyle(
                            color: accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item.subtitle.isNotEmpty) ...[
                          Text(
                            '  ·  ',
                            style: TextStyle(
                              color: context.palette.textSecondary
                                  .withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.subtitle,
                              style: TextStyle(
                                color: context.palette.textSecondary,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: context.palette.textSecondary.withValues(alpha: 0.4),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
