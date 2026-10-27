import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';
import './pressable_scale_widget.dart';

class BidCardWidget extends StatelessWidget {
  final Bid bid;
  final bool showAmounts;
  final bool canBid;
  final VoidCallback? onTap;
  final VoidCallback? onRebid;

  const BidCardWidget({
    super.key,
    required this.bid,
    this.showAmounts = true,
    this.canBid = true,
    this.onTap,
    this.onRebid,
  });

  StatusVariant get _variant {
    switch (bid.status) {
      case BidStatus.open:
        return StatusVariant.info;
      case BidStatus.expiring:
        return StatusVariant.warning;
      case BidStatus.won:
        return StatusVariant.success;
      case BidStatus.lost:
        return StatusVariant.danger;
    }
  }

  String get _label {
    switch (bid.status) {
      case BidStatus.open:
        return 'Open';
      case BidStatus.expiring:
        return 'Closing soon';
      case BidStatus.won:
        return 'Won';
      case BidStatus.lost:
        return 'Lost';
    }
  }

  String _remaining() {
    final diff = bid.closesAt.difference(DateTime.now());
    if (diff.isNegative) return 'Closed';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min left';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '${h}h ${m}m left';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outbid = bid.leadingBid != null && bid.leadingBid! < bid.ourBid;
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
                  child: Text(bid.id, style: theme.textTheme.labelMedium),
                ),
                StatusBadgeWidget(
                  label: _label,
                  variant: _variant,
                  compact: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              bid.lane,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 2),
            Text(
              '${bid.material}  •  ${bid.weight}  •  ${bid.bidders} bidders',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AmountColumn(
                    label: 'Our bid',
                    value: showAmounts ? Fmt.rupees(bid.ourBid) : '••••••',
                  ),
                ),
                Expanded(
                  child: _AmountColumn(
                    label: 'Leading bid',
                    value: showAmounts && bid.leadingBid != null
                        ? Fmt.rupees(bid.leadingBid!)
                        : '••••••',
                    flag: outbid ? 'Lower than ours' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _remaining(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: bid.status == BidStatus.expiring
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (canBid && onRebid != null)
                  OutlinedButton(
                    onPressed: onRebid,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 40),
                    ),
                    child: const Text('Revise bid'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountColumn extends StatelessWidget {
  final String label;
  final String value;
  final String? flag;
  const _AmountColumn({required this.label, required this.value, this.flag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (flag != null)
          Text(
            flag!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFFFFE2A3)
                  : AppTheme.warningText,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
