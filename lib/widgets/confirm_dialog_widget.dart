import 'package:flutter/material.dart';

import '../core/app_export.dart';

class ConfirmDialogWidget {
  ConfirmDialogWidget._();

  /// Returns true when the user confirms.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = Strings.confirm,
    String cancelLabel = Strings.cancel,
    bool destructive = false,
  }) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius + 4),
          ),
          title: Row(
            children: [
              Icon(
                destructive ? Icons.warning_amber_rounded : Icons.help_outline,
                color: destructive
                    ? theme.colorScheme.error
                    : theme.colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            ],
          ),
          content: Text(message, style: theme.textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                cancelLabel,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: AppTheme.dangerSolid,
                      foregroundColor: Colors.white,
                    )
                  : null,
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
