import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';
import './pressable_scale_widget.dart';

class LoadCardWidget extends StatelessWidget {
  final LoadItem load;
  final bool showBudget;
  final bool canBid;
  final VoidCallback? onTap;
  final VoidCallback? onBid;

  const LoadCardWidget({
    super.key,
    required this.load,
    this.showBudget = true,
    this.canBid = true,
    this.onTap,
    this.onBid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PressableScaleWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(load.id, style: theme.textTheme.labelMedium),
                ),
                StatusBadgeWidget(
                  label: load.vehicleType,
                  variant: StatusVariant.neutral,
                  icon: Icons.local_shipping_outlined,
                  compact: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.trip_origin,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                    Container(
                      width: 2,
                      height: 18,
                      color: theme.colorScheme.outline,
                    ),
                    Icon(Icons.place, size: 16, color: theme.colorScheme.error),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        load.origin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        load.destination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${load.customer}  •  ${load.material}  •  ${load.weight}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Pickup ${Fmt.dateTime(load.pickup)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    !showBudget
                        ? ''
                        : (load.budget == null
                              ? 'Budget: open to quotes'
                              : 'Budget ${Fmt.rupees(load.budget!)}'),
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                if (canBid && onBid != null)
                  FilledButton(
                    onPressed: onBid,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 40),
                    ),
                    child: const Text('Place bid'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
