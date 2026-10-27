import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/data/models.dart';

class TimelineEventWidget extends StatelessWidget {
  final List<TimelineItem> items;
  const TimelineEventWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          _Row(
            item: items[i],
            first: i == 0,
            last: i == items.length - 1,
            theme: theme,
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final TimelineItem item;
  final bool first;
  final bool last;
  final ThemeData theme;
  const _Row({
    required this.item,
    required this.first,
    required this.last,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = item.current
        ? theme.colorScheme.secondary
        : (item.done ? AppTheme.successSolid : theme.colorScheme.outline);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 8,
                  color: first ? Colors.transparent : theme.colorScheme.outline,
                ),
                Container(
                  width: item.current ? 18 : 14,
                  height: item.current ? 18 : 14,
                  decoration: BoxDecoration(
                    color: item.done || item.current
                        ? dotColor
                        : theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                  child: item.done
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: last
                        ? Colors.transparent
                        : theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: item.current
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(Fmt.dateTime(item.at), style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
