import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';

class GpsFreshnessBadgeWidget extends StatelessWidget {
  final GpsFreshness freshness;
  final bool compact;

  const GpsFreshnessBadgeWidget({
    super.key,
    required this.freshness,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (freshness) {
      case GpsFreshness.live:
        return StatusBadgeWidget(
          label: Strings.gpsLive,
          variant: StatusVariant.success,
          icon: Icons.sensors,
          compact: compact,
        );
      case GpsFreshness.delayed:
        return StatusBadgeWidget(
          label: Strings.gpsDelayed,
          variant: StatusVariant.warning,
          icon: Icons.schedule,
          compact: compact,
        );
      case GpsFreshness.stale:
        return StatusBadgeWidget(
          label: Strings.gpsStale,
          variant: StatusVariant.danger,
          icon: Icons.signal_wifi_statusbar_connected_no_internet_4,
          compact: compact,
        );
      case GpsFreshness.noDevice:
        return StatusBadgeWidget(
          label: Strings.gpsNoDevice,
          variant: StatusVariant.neutral,
          icon: Icons.location_disabled,
          compact: compact,
        );
    }
  }
}
