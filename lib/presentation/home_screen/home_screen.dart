import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_export.dart';
import '../../core/data/mock_repositories.dart';
import '../../core/data/models.dart';
import './widgets/attention_hero_widget.dart';
import './widgets/bids_closing_widget.dart';
import './widgets/gps_health_widget.dart';
import './widgets/kpi_grid_widget.dart';
import './widgets/weekly_trips_chart_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DashboardData? _data;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      // TODO: Replace with Riverpod AsyncNotifier backed by the real API
      final data = await Repos.dashboard.loadDashboard();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final role = appState.role;
        final width = MediaQuery.of(context).size.width;
        final wide = width >= 600;

        return Scaffold(
          appBar: AppBarWidget(
            title: _data?.companyName ?? Strings.appName,
            subtitle: '${Strings.homeTitle}  •  ${role.label}',
            showBell: true,
            actions: [
              IconButton(
                tooltip: Strings.moreSettings,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push(AppRoutes.settingsScreen),
              ),
            ],
          ),
          floatingActionButton: role.canAllocateAndBid
              ? FloatingActionButton.extended(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post Load arrives in Phase 1'),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(Strings.postLoad),
                )
              : null,
          body: Column(
            children: [
              if (appState.offline) const OfflineBannerWidget(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: _buildBody(context, role, wide),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, UserRole role, bool wide) {
    if (_loading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: const [HomeSkeletonWidget()],
      );
    }
    if (_error || _data == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [ErrorStateWidget(onRetry: _load)],
      );
    }

    final data = _data!;
    final kpis = data.kpis
        .where((k) => !(k.financial && !role.canSeeFinancials))
        .toList();

    final hero = AttentionHeroWidget(items: data.attention);
    final kpiGrid = KpiGridWidget(
      kpis: kpis,
      columns: wide ? 3 : 2,
      onTap: (k) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${k.label} drill-down arrives in a later phase'),
        ),
      ),
    );
    final updated = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.update,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            '${Strings.lastUpdated} ${Fmt.time(data.updatedAt)} IST',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );

    final tripsSection = _Section(
      title: Strings.activeTrips,
      action: Strings.seeAll,
      onAction: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trips tab arrives in a later phase')),
      ),
      child: Column(
        children: [
          for (int i = 0; i < data.activeTrips.length; i++) ...[
            _StaggerIn(
              index: i,
              child: TripCardWidget(
                trip: data.activeTrips[i],
                showFinancials: role.canSeeFinancials,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${data.activeTrips[i].id} detail arrives in a later phase',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );

    final bidsSection = _Section(
      title: Strings.bidsClosingSoon,
      child: BidsClosingWidget(
        bids: data.closingBids,
        showAmounts: role.canSeeFinancials || role == UserRole.manager,
        canBid: role.canAllocateAndBid,
      ),
    );

    final gpsSection = _Section(
      title: Strings.gpsHealth,
      child: GpsHealthWidget(summary: data.gps),
    );

    final chartSection = _Section(
      title: Strings.weeklyTrips,
      child: WeeklyTripsChartWidget(days: data.weekly),
    );

    if (wide) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          hero,
          const SizedBox(height: 16),
          kpiGrid,
          updated,
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: tripsSection),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: Column(
                  children: [bidsSection, gpsSection, chartSection],
                ),
              ),
            ],
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        hero,
        const SizedBox(height: 16),
        kpiGrid,
        updated,
        const SizedBox(height: 8),
        tripsSection,
        bidsSection,
        gpsSection,
        chartSection,
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final Widget child;

  const _Section({
    required this.title,
    this.action,
    this.onAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
              if (action != null)
                TextButton(onPressed: onAction, child: Text(action!)),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// Staggered entrance: index x 50ms delay, capped at 400ms.
class _StaggerIn extends StatefulWidget {
  final int index;
  final Widget child;
  const _StaggerIn({required this.index, required this.child});

  @override
  State<_StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<_StaggerIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    final delay = (widget.index * 50).clamp(0, 400);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _a,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(_a),
        child: widget.child,
      ),
    );
  }
}
