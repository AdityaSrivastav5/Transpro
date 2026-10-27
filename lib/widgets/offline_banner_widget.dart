import 'package:flutter/material.dart';

import '../core/app_export.dart';

class OfflineBannerWidget extends StatelessWidget {
  final String message;
  const OfflineBannerWidget({super.key, this.message = Strings.offlineBanner});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF3D2C05) : AppTheme.warningSurface;
    final fg = dark ? const Color(0xFFFFE2A3) : AppTheme.warningText;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: bg,
        child: Row(
          children: [
            Icon(Icons.wifi_off, size: 18, color: fg),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
