import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_export.dart';
import '../../core/data/mock_repositories.dart';
import '../../core/data/models.dart';

class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  List<Trip> _trips = [];
  List<Vehicle> _vehicles = [];
  List<Bid> _bids = [];
  List<LoadItem> _loads = [];
  List<TimelineItem> _timeline = [];
  bool _loading = true;
  double _uploadProgress = 0.45;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // TODO: Replace with Riverpod providers
    final repo = Repos.samples;
    final results = await Future.wait([
      repo.sampleTrips(),
      repo.sampleVehicles(),
      repo.sampleBids(),
      repo.sampleLoads(),
      repo.sampleTimeline(),
    ]);
    if (!mounted) return;
    setState(() {
      _trips = results[0] as List<Trip>;
      _vehicles = results[1] as List<Vehicle>;
      _bids = results[2] as List<Bid>;
      _loads = results[3] as List<LoadItem>;
      _timeline = results[4] as List<TimelineItem>;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 840;

    return Scaffold(
      appBar: AppBarWidget(
        title: Strings.componentGallery,
        subtitle: 'Developer only',
        onBack: () => context.pop(),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _group(context, 'KPI cards', _kpis(context), wide),
                _group(context, 'Status badges', _badges(), wide),
                _group(context, 'GPS freshness', _gps(), wide),
                _group(context, 'Trip cards', _tripCards(context), wide),
                _group(context, 'Vehicle cards', _vehicleCards(), wide),
                _group(context, 'Bid cards', _bidCards(context), wide),
                _group(context, 'Load cards', _loadCards(context), wide),
                _group(context, 'Search and filters', _search(), wide),
                _group(context, 'Timeline', _timelineSection(), wide),
                _group(context, 'Document upload', _documents(context), wide),
                _group(context, 'Map overlay card', _mapCard(), wide),
                _group(
                  context,
                  'Empty, error, offline',
                  _states(context),
                  wide,
                ),
                _group(context, 'Skeleton loader', _skeletons(), wide),
                _group(context, 'Confirm dialogs', _dialogs(context), wide),
              ],
            ),
    );
  }

  Widget _group(
    BuildContext context,
    String title,
    List<Widget> children,
    bool wide,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          if (wide)
            LayoutBuilder(
              builder: (context, c) {
                final w = (c.maxWidth - 16) / 2;
                return Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    for (final child in children)
                      SizedBox(width: w, child: child),
                  ],
                );
              },
            )
          else
            Column(
              children: [
                for (final child in children) ...[
                  child,
                  const SizedBox(height: 12),
                ],
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _kpis(BuildContext context) => [
    KpiCardWidget(
      label: Strings.kpiActiveTrips,
      value: '23',
      trend: '+4 vs yesterday',
      onTap: () {},
    ),
    const KpiCardWidget(
      label: Strings.kpiPendingPods,
      value: '6',
      trend: '2 rejected',
      trendPositive: false,
      alert: true,
    ),
    const KpiCardWidget(label: Strings.kpiAvailableVehicles, value: '9'),
  ];

  List<Widget> _badges() => const [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        StatusBadgeWidget(label: 'Delivered', variant: StatusVariant.success),
        StatusBadgeWidget(
          label: 'Awaiting POD',
          variant: StatusVariant.warning,
        ),
        StatusBadgeWidget(label: 'Running late', variant: StatusVariant.danger),
        StatusBadgeWidget(label: 'In transit', variant: StatusVariant.info),
        StatusBadgeWidget(label: 'Planned', variant: StatusVariant.neutral),
      ],
    ),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        StatusBadgeWidget(
          label: 'Delivered',
          variant: StatusVariant.success,
          compact: true,
        ),
        StatusBadgeWidget(
          label: 'Awaiting POD',
          variant: StatusVariant.warning,
          compact: true,
        ),
        StatusBadgeWidget(
          label: 'Running late',
          variant: StatusVariant.danger,
          compact: true,
        ),
        StatusBadgeWidget(
          label: 'In transit',
          variant: StatusVariant.info,
          compact: true,
        ),
        StatusBadgeWidget(
          label: 'Planned',
          variant: StatusVariant.neutral,
          compact: true,
        ),
      ],
    ),
  ];

  List<Widget> _gps() => const [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GpsFreshnessBadgeWidget(freshness: GpsFreshness.live),
        GpsFreshnessBadgeWidget(freshness: GpsFreshness.delayed),
        GpsFreshnessBadgeWidget(freshness: GpsFreshness.stale),
        GpsFreshnessBadgeWidget(freshness: GpsFreshness.noDevice),
      ],
    ),
  ];

  List<Widget> _tripCards(BuildContext context) => [
    TripCardWidget(trip: _trips[0], showFinancials: true, onTap: () {}),
    TripCardWidget(trip: _trips[2]),
  ];

  List<Widget> _vehicleCards() => [
    for (final v in _vehicles) VehicleCardWidget(vehicle: v, onTap: () {}),
  ];

  List<Widget> _bidCards(BuildContext context) => [
    BidCardWidget(bid: _bids[0], onRebid: () {}, onTap: () {}),
    BidCardWidget(bid: _bids[1], canBid: false),
  ];

  List<Widget> _loadCards(BuildContext context) => [
    LoadCardWidget(load: _loads[0], onBid: () {}, onTap: () {}),
    LoadCardWidget(load: _loads[1], showBudget: true, canBid: false),
  ];

  List<Widget> _search() => [
    const SearchFilterBarWidget(
      hint: 'Search by route, customer or vehicle',
      filters: [
        'Open',
        'Closing soon',
        'Own fleet',
        'Market',
        'Delayed',
        'POD pending',
      ],
    ),
  ];

  List<Widget> _timelineSection() => [
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: TimelineEventWidget(items: _timeline),
    ),
  ];

  List<Widget> _documents(BuildContext context) => [
    const DocumentUploadCardWidget(
      title: 'Lorry Receipt (LR)',
      subtitle: 'TRP-24871  •  PDF or photo',
      status: DocStatus.idle,
    ),
    StatefulBuilder(
      builder: (context, setLocal) {
        return Column(
          children: [
            DocumentUploadCardWidget(
              title: 'Proof of Delivery',
              subtitle: 'TRP-24869  •  pod_scan.jpg',
              status: DocStatus.uploading,
              progress: _uploadProgress,
            ),
            Slider(
              value: _uploadProgress,
              onChanged: (v) {
                setLocal(() => _uploadProgress = v);
                setState(() {});
              },
            ),
          ],
        );
      },
    ),
    const DocumentUploadCardWidget(
      title: 'E-way bill',
      subtitle: 'TRP-24862  •  ewb_2210.pdf',
      status: DocStatus.success,
    ),
    DocumentUploadCardWidget(
      title: 'Toll receipt',
      subtitle: 'TRP-24866  •  toll_1.jpg',
      status: DocStatus.failed,
      onRetry: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Retrying upload'))),
    ),
    const DocumentUploadCardWidget(
      title: 'Lorry Receipt (LR)',
      subtitle: 'TRP-24840  •  lr_scan.jpg',
      status: DocStatus.rejected,
      rejectionReason: 'Image is blurry. LR number is not readable.',
    ),
  ];

  List<Widget> _mapCard() => const [
    MapOverlayCardWidget(
      vehicleNo: 'MH 04 KF 8821',
      location: 'NH 48, near Udaipur, RJ',
      speed: '58 km/h',
      lastPing: '2 min ago',
      freshness: GpsFreshness.live,
    ),
    MapOverlayCardWidget(
      vehicleNo: 'PB 10 GH 7392',
      location: 'NH 52, near Kota, RJ',
      speed: '0 km/h',
      lastPing: '3 hr 12 min ago',
      freshness: GpsFreshness.stale,
    ),
  ];

  List<Widget> _states(BuildContext context) => [
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: EmptyStateWidget(
        icon: Icons.local_shipping_outlined,
        title: 'No trips yet',
        message: 'Allocate a vehicle to a load to start your first trip.',
        actionLabel: 'Allocate Vehicle',
        onAction: () {},
      ),
    ),
    ErrorStateWidget(
      message: 'Could not load deliveries. Pull down to try again.',
      onRetry: () {},
    ),
    const ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(AppTheme.radius)),
      child: OfflineBannerWidget(),
    ),
  ];

  List<Widget> _skeletons() => [
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingSkeletonWidget(width: 120, height: 12),
          SizedBox(height: 12),
          LoadingSkeletonWidget(height: 16),
          SizedBox(height: 10),
          LoadingSkeletonWidget(width: 220, height: 12),
          SizedBox(height: 16),
          LoadingSkeletonWidget(height: 6),
        ],
      ),
    ),
  ];

  List<Widget> _dialogs(BuildContext context) => [
    Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final ok = await ConfirmDialogWidget.show(
                context,
                title: 'Allocate vehicle?',
                message:
                    'MH 04 KF 8821 will be assigned to TRP-24871 and removed from the available pool.',
                confirmLabel: 'Allocate',
              );
              if (!mounted) return;
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(content: Text(ok ? 'Confirmed' : 'Cancelled')),
              );
            },
            child: const Text('Normal dialog'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final ok = await ConfirmDialogWidget.show(
                context,
                title: 'Cancel this trip?',
                message:
                    'TRP-24866 will be cancelled and the customer will be notified. This cannot be undone.',
                confirmLabel: 'Cancel trip',
                cancelLabel: 'Keep trip',
                destructive: true,
              );
              if (!mounted) return;
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(content: Text(ok ? 'Trip cancelled' : 'Kept')),
              );
            },
            child: const Text('Destructive dialog'),
          ),
        ),
      ],
    ),
  ];
}
