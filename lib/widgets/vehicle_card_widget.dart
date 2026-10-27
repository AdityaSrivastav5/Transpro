import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';
import './pressable_scale_widget.dart';

class VehicleCardWidget extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;

  const VehicleCardWidget({super.key, required this.vehicle, this.onTap});

  StatusVariant get _variant {
    switch (vehicle.status) {
      case 'Available':
        return StatusVariant.success;
      case 'On trip':
        return StatusVariant.info;
      default:
        return StatusVariant.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PressableScaleWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.network(
                  vehicle.imageUrl ?? '',
                  fit: BoxFit.cover,
                  semanticLabel: vehicle.imageLabel,
                  errorBuilder: (context, error, stack) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
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
                          vehicle.regNo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      StatusBadgeWidget(
                        label: vehicle.status,
                        variant: _variant,
                        compact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${vehicle.type}  •  ${vehicle.capacity}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          vehicle.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      StatusBadgeWidget(
                        label: vehicle.ownFleet
                            ? 'Own fleet'
                            : (vehicle.vendor ?? 'Market'),
                        variant: vehicle.ownFleet
                            ? StatusVariant.info
                            : StatusVariant.neutral,
                        icon: vehicle.ownFleet
                            ? Icons.verified_outlined
                            : Icons.handshake_outlined,
                        compact: true,
                      ),
                      const SizedBox(width: 6),
                      GpsFreshnessBadgeWidget(freshness: vehicle.gps),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
