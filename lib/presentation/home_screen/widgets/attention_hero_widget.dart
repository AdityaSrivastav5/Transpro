import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/data/models.dart';

/// Navy hero card: the single most urgent thing, plus the next items.
class AttentionHeroWidget extends StatelessWidget {
  final List<AttentionItem> items;
  const AttentionHeroWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final top = items.first;
    final rest = items.skip(1).toList();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF16284A) : AppTheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radius + 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.priority_high,
                size: 18,
                color: AppTheme.textOnPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                Strings.needsAttention.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.textOnPrimarySecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${top.count}',
                style: const TextStyle(
                  color: AppTheme.textOnPrimary,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  top.title,
                  style: const TextStyle(
                    color: AppTheme.textOnPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            top.detail,
            style: const TextStyle(
              color: AppTheme.textOnPrimarySecondary,
              fontSize: 14,
            ),
          ),
          if (rest.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: const Color(0xFF2C4468)),
            const SizedBox(height: 12),
            for (final item in rest)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C4468),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.count}',
                        style: const TextStyle(
                          color: AppTheme.textOnPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${item.title}: ${item.detail}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textOnPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
