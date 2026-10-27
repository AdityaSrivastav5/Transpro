import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';
import './pressable_scale_widget.dart';

class TripCardWidget extends StatelessWidget {
  final Trip trip;
  final bool showFinancials;
  final VoidCallback? onTap;

  const TripCardWidget({
    super.key,
    required this.trip,
    this.showFinancials = false,
    this.onTap,
  });

  StatusVariant get _variant {
    switch (trip.status) {
      case TripStatus.running:
        return StatusVariant.info;
      case TripStatus.delayed:
        return StatusVariant.danger;
      case TripStatus.completed:
        return StatusVariant.success;
      case TripStatus.planned:
        return StatusVariant.neutral;
      case TripStatus.cancelled:
        return StatusVariant.neutral;
    }
  }

  String get _statusLabel {
    switch (trip.status) {
      case TripStatus.running:
        return 'Running';
      case TripStatus.delayed:
        return 'Running late';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.planned:
        return 'Planned';
      case TripStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final late = trip.status == TripStatus.delayed;
    return PressableScaleWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border(
            left: BorderSide(
              color: late ? AppTheme.dangerSolid : theme.colorScheme.outline,
              width: late ? 4 : 1,
            ),
            top: BorderSide(color: theme.colorScheme.outline),
            right: BorderSide(color: theme.colorScheme.outline),
            bottom: BorderSide(color: theme.colorScheme.outline),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(trip.id, style: theme.textTheme.labelMedium),
                ),
                StatusBadgeWidget(
                  label: _statusLabel,
                  variant: _variant,
                  compact: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: Text(
                    trip.origin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Flexible(
                  child: Text(
                    trip.destination,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${trip.customer}  •  ${trip.stops} stop${trip.stops > 1 ? 's' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: trip.progress,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: late
                    ? AppTheme.dangerSolid
                    : theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${trip.vehicleNo}  •  ${trip.driverName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                GpsFreshnessBadgeWidget(freshness: trip.gps),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'ETA ${Fmt.dateTime(trip.eta)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (showFinancials)
                  Text(
                    Fmt.rupees(trip.freight),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
