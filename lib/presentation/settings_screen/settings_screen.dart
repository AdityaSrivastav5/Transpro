import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_export.dart';
import '../../core/data/mock_repositories.dart';
import '../../core/data/models.dart';
import './widgets/profile_card_widget.dart';
import './widgets/role_switcher_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  CompanyProfile? _profile;
  bool _notifBids = true;
  bool _notifTrips = true;
  bool _notifDocs = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // TODO: Replace with Riverpod provider
    final p = await Repos.profile.loadProfile();
    if (!mounted) return;
    setState(() => _profile = p);
  }

  Future<void> _logout() async {
    final ok = await ConfirmDialogWidget.show(
      context,
      title: Strings.logoutConfirmTitle,
      message: Strings.logoutConfirmBody,
      confirmLabel: Strings.logout,
      destructive: true,
    );
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signed out (demo only)')));
    context.go(AppRoutes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 840;

    final account = _Block(
      label: Strings.sectionAccount,
      child: _profile == null
          ? const LoadingSkeletonWidget(height: 96, radius: 12)
          : ProfileCardWidget(profile: _profile!),
    );

    final developer = _Block(
      label: Strings.sectionDeveloper,
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) => RoleSwitcherWidget(
          current: appState.role,
          onChanged: appState.setRole,
          hint: Strings.roleSwitcherHint,
        ),
      ),
    );

    final prefs = _Block(
      label: Strings.sectionPreferences,
      child: _Card(
        children: [
          _Row(
            icon: Icons.translate,
            title: Strings.language,
            trailing: const Text(Strings.languageEnglish),
          ),
          const Divider(),
          _Row(
            icon: Icons.translate,
            title: Strings.languageHindi,
            trailing: const StatusBadgeWidget(
              label: Strings.comingSoon,
              variant: StatusVariant.neutral,
              compact: true,
            ),
          ),
          const Divider(),
          _Row(
            icon: Icons.wifi_off_outlined,
            title: 'Simulate offline mode',
            trailing: ListenableBuilder(
              listenable: appState,
              builder: (context, _) => Switch(
                value: appState.offline,
                onChanged: appState.setOffline,
              ),
            ),
          ),
          const Divider(),
          _Row(
            icon: Icons.storage_outlined,
            title: Strings.mockDataFlag,
            trailing: StatusBadgeWidget(
              label: USE_MOCK_DATA ? 'true' : 'false',
              variant: USE_MOCK_DATA
                  ? StatusVariant.warning
                  : StatusVariant.success,
              compact: true,
            ),
          ),
          const Divider(),
          _Row(
            icon: Icons.widgets_outlined,
            title: Strings.componentGallery,
            subtitle: Strings.componentGalleryHint,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.componentGalleryScreen),
          ),
        ],
      ),
    );

    final notifications = _Block(
      label: Strings.sectionNotifications,
      child: _Card(
        children: [
          _Row(
            icon: Icons.gavel_outlined,
            title: Strings.notifBids,
            trailing: Switch(
              value: _notifBids,
              onChanged: (v) => setState(() => _notifBids = v),
            ),
          ),
          const Divider(),
          _Row(
            icon: Icons.alt_route_outlined,
            title: Strings.notifTrips,
            trailing: Switch(
              value: _notifTrips,
              onChanged: (v) => setState(() => _notifTrips = v),
            ),
          ),
          const Divider(),
          _Row(
            icon: Icons.description_outlined,
            title: Strings.notifDocs,
            trailing: Switch(
              value: _notifDocs,
              onChanged: (v) => setState(() => _notifDocs = v),
            ),
          ),
        ],
      ),
    );

    final danger = _Block(
      label: Strings.sectionDanger,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF3D1414)
              : AppTheme.dangerSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: AppTheme.dangerSolid.withAlpha(102)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _logout,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.dangerSolid,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.logout),
            label: const Text(Strings.logout),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBarWidget(
        title: Strings.settingsTitle,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(children: [account, developer, danger]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Column(children: [prefs, notifications])),
                ],
              )
            else ...[
              account,
              developer,
              prefs,
              notifications,
              danger,
            ],
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final String label;
  final Widget child;
  const _Block({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(letterSpacing: 0.8),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _Row({
    required this.icon,
    required this.title,
    required this.trailing,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: theme.textTheme.bodyLarge),
                    if (subtitle != null)
                      Text(subtitle!, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
