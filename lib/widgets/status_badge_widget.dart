import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../theme/app_theme.dart';

enum StatusVariant { success, warning, danger, info, neutral }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final StatusVariant variant;
  final IconData? icon;
  final bool compact;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    required this.variant,
    this.icon,
    this.compact = false,
  });

  static IconData defaultIcon(StatusVariant v) {
    switch (v) {
      case StatusVariant.success:
        return Icons.check_circle_outline;
      case StatusVariant.warning:
        return Icons.schedule;
      case StatusVariant.danger:
        return Icons.error_outline;
      case StatusVariant.info:
        return Icons.info_outline;
      case StatusVariant.neutral:
        return Icons.remove_circle_outline;
    }
  }

  ({Color bg, Color fg}) _colors(bool dark) {
    if (dark) {
      switch (variant) {
        case StatusVariant.success:
          return (bg: const Color(0xFF123524), fg: const Color(0xFFB7F0C9));
        case StatusVariant.warning:
          return (bg: const Color(0xFF3D2C05), fg: const Color(0xFFFFE2A3));
        case StatusVariant.danger:
          return (bg: const Color(0xFF3D1414), fg: const Color(0xFFFFC9C9));
        case StatusVariant.info:
          return (bg: const Color(0xFF1B2D5C), fg: const Color(0xFFD6E4FF));
        case StatusVariant.neutral:
          return (bg: const Color(0xFF243049), fg: const Color(0xFFD5DCE8));
      }
    }
    switch (variant) {
      case StatusVariant.success:
        return (bg: AppTheme.successSurface, fg: AppTheme.successText);
      case StatusVariant.warning:
        return (bg: AppTheme.warningSurface, fg: AppTheme.warningText);
      case StatusVariant.danger:
        return (bg: AppTheme.dangerSurface, fg: AppTheme.dangerText);
      case StatusVariant.info:
        return (bg: AppTheme.infoSurface, fg: AppTheme.infoText);
      case StatusVariant.neutral:
        return (bg: AppTheme.neutralSurface, fg: AppTheme.neutralText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final c = _colors(dark);
    final iconData = icon ?? defaultIcon(variant);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: compact ? 12 : 14, color: c.fg),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c.fg,
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
