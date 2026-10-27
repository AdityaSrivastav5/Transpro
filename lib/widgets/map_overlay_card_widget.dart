import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';

/// Card that floats over a map: vehicle identity, speed, last ping.
class MapOverlayCardWidget extends StatelessWidget {
  final String vehicleNo;
  final String location;
  final String speed;
  final String lastPing;
  final GpsFreshness freshness;
  final VoidCallback? onTap;

  const MapOverlayCardWidget({
    super.key,
    required this.vehicleNo,
    required this.location,
    required this.speed,
    required this.lastPing,
    required this.freshness,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 3,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(vehicleNo, style: theme.textTheme.titleSmall),
                  ),
                  GpsFreshnessBadgeWidget(freshness: freshness),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.speed,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(speed, style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.update,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      lastPing,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
