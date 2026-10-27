import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/data/models.dart';
import '../../../widgets/kpi_card_widget.dart';

class KpiGridWidget extends StatelessWidget {
  final List<Kpi> kpis;
  final int columns;
  final ValueChanged<Kpi>? onTap;

  const KpiGridWidget({
    super.key,
    required this.kpis,
    this.columns = 2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final itemWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final k in kpis)
              SizedBox(
                width: itemWidth,
                child: KpiCardWidget(
                  label: k.label,
                  value: k.value,
                  trend: k.trend,
                  trendPositive: k.trendPositive,
                  alert: k.alert,
                  onTap: onTap == null ? null : () => onTap!(k),
                ),
              ),
          ],
        );
      },
    );
  }
}
