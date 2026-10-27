import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_export.dart';
import '../core/l10n/app_strings.dart';
import '../presentation/more_menu_sheet.dart';

/// One visual tab. branchIndex is null for stub tabs that have no planned screen.
class _TabSpec {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int? branchIndex;

  const _TabSpec(this.label, this.icon, this.selectedIcon, this.branchIndex);
}

const List<_TabSpec> _tabs = [
  _TabSpec(
    Strings.navHome,
    Icons.space_dashboard_outlined,
    Icons.space_dashboard,
    0,
  ),
  _TabSpec(Strings.navLoads, Icons.gavel_outlined, Icons.gavel, null),
  _TabSpec(Strings.navTrips, Icons.alt_route_outlined, Icons.alt_route, null),
  _TabSpec(
    Strings.navFleet,
    Icons.local_shipping_outlined,
    Icons.local_shipping,
    null,
  ),
  _TabSpec(Strings.navMore, Icons.menu, Icons.menu_open, null),
];

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final bool rail;

  const AppNavigation({
    super.key,
    required this.navigationShell,
    this.rail = false,
  });

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  void _onTap(int visualIndex) {
    final spec = _tabs[visualIndex];

    // The More tab opens the overflow sheet (Settings, Component Gallery).
    if (spec.label == Strings.navMore) {
      showMoreMenuSheet(context);
      return;
    }

    // Stub tabs have no screen yet: no navigation, no selection change.
    if (spec.branchIndex == null) return;

    setState(() => _selectedVisualIndex = visualIndex);
    widget.navigationShell.goBranch(
      spec.branchIndex!,
      initialLocation: spec.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  Widget _icon(int i, bool selected) {
    final spec = _tabs[i];
    final disabled = spec.branchIndex == null && spec.label != Strings.navMore;
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.onSecondaryContainer
        : theme.colorScheme.onSurfaceVariant;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Icon(selected ? spec.selectedIcon : spec.icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rail) {
      return NavigationRail(
        selectedIndex: _selectedVisualIndex,
        labelType: NavigationRailLabelType.all,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
        onDestinationSelected: _onTap,
        destinations: [
          for (int i = 0; i < _tabs.length; i++)
            NavigationRailDestination(
              icon: _icon(i, false),
              selectedIcon: _icon(i, true),
              label: Opacity(
                opacity:
                    _tabs[i].branchIndex == null &&
                        _tabs[i].label != Strings.navMore
                    ? 0.4
                    : 1,
                child: Text(_tabs[i].label),
              ),
            ),
        ],
      );
    }

    return NavigationBar(
      selectedIndex: _selectedVisualIndex,
      onDestinationSelected: _onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        for (int i = 0; i < _tabs.length; i++)
          NavigationDestination(
            icon: _icon(i, false),
            selectedIcon: _icon(i, true),
            label: _tabs[i].label,
          ),
      ],
    );
  }
}
