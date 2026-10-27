import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/data/models.dart';
import '../../../theme/app_theme.dart';

class WeeklyTripsChartWidget extends StatefulWidget {
  final List<DayTrips> days;
  const WeeklyTripsChartWidget({super.key, required this.days});

  @override
  State<WeeklyTripsChartWidget> createState() => _WeeklyTripsChartWidgetState();
}

class _WeeklyTripsChartWidgetState extends State<WeeklyTripsChartWidget> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = width >= 600 ? 260.0 : 200.0;
    final maxY =
        widget.days
            .map((d) => d.completed + d.delayed)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        4;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
              _legend(context, theme.colorScheme.secondary, 'On time'),
              const SizedBox(width: 16),
              _legend(context, AppTheme.dangerSolid, 'Delayed'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: height,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.colorScheme.outline,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 5,
                      getTitlesWidget: (v, meta) => Text(
                        v.toInt().toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, meta) {
                        final i = v.toInt();
                        if (i < 0 || i >= widget.days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.days[i].day,
                            style: theme.textTheme.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      _touched = response?.spot?.touchedBarGroupIndex ?? -1;
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: theme.colorScheme.inverseSurface,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final d = widget.days[groupIndex];
                      return BarTooltipItem(
                        '${d.day}\n${d.completed} on time, ${d.delayed} delayed',
                        TextStyle(
                          color: theme.colorScheme.onInverseSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                barGroups: [
                  for (int i = 0; i < widget.days.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY:
                              (widget.days[i].completed +
                                      widget.days[i].delayed)
                                  .toDouble(),
                          width: _touched == i ? 22 : 18,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                          rodStackItems: [
                            BarChartRodStackItem(
                              0,
                              widget.days[i].completed.toDouble(),
                              theme.colorScheme.secondary,
                            ),
                            BarChartRodStackItem(
                              widget.days[i].completed.toDouble(),
                              (widget.days[i].completed +
                                      widget.days[i].delayed)
                                  .toDouble(),
                              AppTheme.dangerSolid,
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 280),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
