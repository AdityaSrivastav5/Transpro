import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/data/models.dart';

class BidsClosingWidget extends StatelessWidget {
  final List<Bid> bids;
  final bool showAmounts;
  final bool canBid;

  const BidsClosingWidget({
    super.key,
    required this.bids,
    required this.showAmounts,
    required this.canBid,
  });

  @override
  Widget build(BuildContext context) {
    if (bids.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.gavel_outlined,
        title: 'No bids closing soon',
        message: 'Open bids with less than 6 hours left will show up here.',
      );
    }
    return Column(
      children: [
        for (final b in bids) ...[
          BidCardWidget(
            bid: b,
            showAmounts: showAmounts,
            canBid: canBid,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${b.id} detail arrives in a later phase'),
              ),
            ),
            onRebid: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Revise bid arrives in Phase 1')),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
