import 'package:flutter/material.dart';

import '../core/app_export.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBell;
  final VoidCallback? onBack;
  final List<Widget> actions;

  const AppBarWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.showBell = false,
    this.onBack,
    this.actions = const [],
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 64 : 76);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            if (onBack != null)
              IconButton(
                tooltip: 'Back',
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
              )
            else
              const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            ...actions,
            if (showBell)
              ListenableBuilder(
                listenable: appState,
                builder: (context, _) => _BellButton(
                  count: appState.unreadNotifications,
                  onTap: () {
                    appState.clearNotifications();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Notifications screen arrives in a later phase',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _BellButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Notifications, $count unread',
      button: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              if (count > 0)
                Positioned(
                  top: 8,
                  right: 6,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.dangerSolid,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
