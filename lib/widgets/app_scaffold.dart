import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './app_navigation.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final useRail = width >= 600;

    if (useRail) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              AppNavigation(navigationShell: navigationShell, rail: true),
              const VerticalDivider(width: 1),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigation(navigationShell: navigationShell),
    );
  }
}
