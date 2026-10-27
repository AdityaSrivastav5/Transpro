import 'package:flutter/material.dart';

import '../core/app_export.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    this.title = Strings.errorTitle,
    this.message = Strings.errorBody,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF3D1414) : AppTheme.dangerSurface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
          color: dark ? const Color(0xFF6B2A2A) : const Color(0xFFF5C2C2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 36,
            color: dark ? const Color(0xFFFFC9C9) : AppTheme.dangerText,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: dark ? const Color(0xFFFFC9C9) : AppTheme.dangerText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: dark ? const Color(0xFFFFC9C9) : AppTheme.dangerText,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(Strings.retry),
          ),
        ],
      ),
    );
  }
}
