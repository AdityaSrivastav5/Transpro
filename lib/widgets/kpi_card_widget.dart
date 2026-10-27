import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../theme/app_theme.dart';
import './pressable_scale_widget.dart';

class KpiCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool trendPositive;
  final bool alert;
  final VoidCallback? onTap;

  const KpiCardWidget({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive = true,
    this.alert = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final trendColor = trendPositive
        ? (dark ? const Color(0xFFB7F0C9) : AppTheme.successText)
        : (dark ? const Color(0xFFFFE2A3) : AppTheme.warningText);

    return PressableScaleWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(
            color: alert
                ? (dark ? const Color(0xFF8A6A1F) : AppTheme.warningSolid)
                : theme.colorScheme.outline,
            width: alert ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                if (alert)
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: dark
                        ? const Color(0xFFFFE2A3)
                        : AppTheme.warningText,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    trendPositive ? Icons.trending_up : Icons.trending_down,
                    size: 14,
                    color: trendColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trend!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: trendColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
