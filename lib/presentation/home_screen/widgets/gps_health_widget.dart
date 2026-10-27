import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/data/models.dart';

class GpsHealthWidget extends StatelessWidget {
  final GpsSummary summary;
  const GpsHealthWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total =
        summary.live + summary.delayed + summary.stale + summary.noDevice;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$total vehicles reporting', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  _seg(summary.live, AppTheme.successSolid),
                  _seg(summary.delayed, AppTheme.warningSolid),
                  _seg(summary.stale, AppTheme.dangerSolid),
                  _seg(summary.noDevice, AppTheme.neutralSolid),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _stat(context, GpsFreshness.live, summary.live),
              _stat(context, GpsFreshness.delayed, summary.delayed),
              _stat(context, GpsFreshness.stale, summary.stale),
              _stat(context, GpsFreshness.noDevice, summary.noDevice),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seg(int count, Color color) {
    if (count == 0) return const SizedBox.shrink();
    return Expanded(
      flex: count,
      child: Container(color: color),
    );
  }

  Widget _stat(BuildContext context, GpsFreshness f, int count) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GpsFreshnessBadgeWidget(freshness: f),
        const SizedBox(width: 6),
        Text(
          '$count',
          style: theme.textTheme.titleSmall?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
