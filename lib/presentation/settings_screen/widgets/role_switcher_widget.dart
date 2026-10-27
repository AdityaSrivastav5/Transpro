import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RoleSwitcherWidget extends StatelessWidget {
  final UserRole current;
  final ValueChanged<UserRole> onChanged;
  final String hint;

  const RoleSwitcherWidget({
    super.key,
    required this.current,
    required this.onChanged,
    required this.hint,
  });

  static const Map<UserRole, String> _descriptions = {
    UserRole.owner: 'Sees everything, including revenue, cost and margin.',
    UserRole.manager: 'No revenue, cost or margin. Can allocate and bid.',
    UserRole.accounts:
        'Receivables, payables and expenses. Cannot allocate or bid.',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
          color: dark ? const Color(0xFF8A6A1F) : AppTheme.warningSolid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report_outlined,
                size: 18,
                color: dark ? const Color(0xFFFFE2A3) : AppTheme.warningText,
              ),
              const SizedBox(width: 8),
              Text(Strings.roleSwitcher, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(hint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<UserRole>(
              showSelectedIcon: false,
              segments: [
                for (final r in UserRole.values)
                  ButtonSegment<UserRole>(value: r, label: Text(r.label)),
              ],
              selected: {current},
              onSelectionChanged: (s) => onChanged(s.first),
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(48, 48)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _descriptions[current]!,
              key: ValueKey(current),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
