import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';

class DocumentUploadCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final DocStatus status;
  final double progress;
  final String? rejectionReason;
  final VoidCallback? onTap;
  final VoidCallback? onRetry;

  const DocumentUploadCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    this.progress = 0,
    this.rejectionReason,
    this.onTap,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    Color border = theme.colorScheme.outline;
    if (status == DocStatus.failed || status == DocStatus.rejected) {
      border = AppTheme.dangerSolid;
    } else if (status == DocStatus.success) {
      border = AppTheme.successSolid;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
          color: border,
          width: status == DocStatus.idle ? 1 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon(), color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _badge(),
            ],
          ),
          if (status == DocStatus.uploading) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(progress * 100).round()}% uploaded',
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (status == DocStatus.failed) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Network dropped while uploading. Your file is saved.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: dark
                          ? const Color(0xFFFFC9C9)
                          : AppTheme.dangerText,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ],
          if (status == DocStatus.rejected) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF3D1414) : AppTheme.dangerSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                rejectionReason ?? 'Document rejected',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: dark ? const Color(0xFFFFC9C9) : AppTheme.dangerText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(minimumSize: const Size(48, 40)),
                child: const Text('Upload again'),
              ),
            ),
          ],
          if (status == DocStatus.idle) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.upload_file),
                label: const Text(Strings.uploadIdle),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _icon() {
    switch (status) {
      case DocStatus.success:
        return Icons.task_alt;
      case DocStatus.rejected:
      case DocStatus.failed:
        return Icons.error_outline;
      case DocStatus.uploading:
        return Icons.cloud_upload_outlined;
      case DocStatus.idle:
        return Icons.description_outlined;
    }
  }

  Widget _badge() {
    switch (status) {
      case DocStatus.idle:
        return const StatusBadgeWidget(
          label: 'Pending',
          variant: StatusVariant.neutral,
          compact: true,
        );
      case DocStatus.uploading:
        return const StatusBadgeWidget(
          label: Strings.uploading,
          variant: StatusVariant.info,
          icon: Icons.cloud_upload_outlined,
          compact: true,
        );
      case DocStatus.success:
        return const StatusBadgeWidget(
          label: Strings.uploadSuccess,
          variant: StatusVariant.success,
          compact: true,
        );
      case DocStatus.failed:
        return const StatusBadgeWidget(
          label: Strings.uploadFailed,
          variant: StatusVariant.danger,
          compact: true,
        );
      case DocStatus.rejected:
        return const StatusBadgeWidget(
          label: Strings.uploadRejected,
          variant: StatusVariant.danger,
          icon: Icons.block,
          compact: true,
        );
    }
  }
}
