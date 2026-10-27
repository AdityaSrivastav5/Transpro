import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_export.dart';

class _MoreItem {
  final String label;
  final IconData icon;
  final String? route;
  final bool comingSoon;
  final bool restrictedForManager;

  const _MoreItem(
    this.label,
    this.icon, {
    this.route,
    this.comingSoon = false,
    this.restrictedForManager = false,
  });
}

const List<_MoreItem> _items = [
  _MoreItem(Strings.moreSubcontractors, Icons.handshake_outlined),
  _MoreItem(Strings.moreDocuments, Icons.folder_open_outlined),
  _MoreItem(
    Strings.moreReceivables,
    Icons.account_balance_wallet_outlined,
    comingSoon: true,
  ),
  _MoreItem(
    Strings.moreExpenses,
    Icons.receipt_long_outlined,
    comingSoon: true,
  ),
  _MoreItem(Strings.moreReports, Icons.bar_chart_outlined, comingSoon: true),
  _MoreItem(Strings.moreNotifications, Icons.notifications_none),
  _MoreItem(Strings.moreProfile, Icons.business_outlined),
  _MoreItem(
    Strings.moreSettings,
    Icons.settings_outlined,
    route: AppRoutes.settingsScreen,
  ),
  _MoreItem(Strings.moreHelp, Icons.help_outline),
  _MoreItem(Strings.moreLogout, Icons.logout),
];

void showMoreMenuSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => const _MoreSheet(),
  );
}

class _MoreSheet extends StatelessWidget {
  const _MoreSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(Strings.navMore, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final item in _items) _MoreRow(item: item),
          ],
        );
      },
    );
  }
}

class _MoreRow extends StatelessWidget {
  final _MoreItem item;
  const _MoreRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLogout = item.label == Strings.moreLogout;
    final iconColor = isLogout
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;
    final textColor = isLogout
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).pop();
        if (item.route != null) {
          context.push(item.route!);
        } else if (item.comingSoon) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${item.label} is coming soon')),
          );
        }
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(item.icon, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.label,
                  style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
                ),
              ),
              if (item.comingSoon)
                const StatusBadgeWidget(
                  label: Strings.comingSoon,
                  variant: StatusVariant.neutral,
                  compact: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}