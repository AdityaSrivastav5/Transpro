import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../theme/app_theme.dart';

class SearchFilterBarWidget extends StatefulWidget {
  final String hint;
  final List<String> filters;
  final ValueChanged<String>? onSearch;
  final ValueChanged<Set<String>>? onFiltersChanged;

  const SearchFilterBarWidget({
    super.key,
    required this.hint,
    required this.filters,
    this.onSearch,
    this.onFiltersChanged,
  });

  @override
  State<SearchFilterBarWidget> createState() => _SearchFilterBarWidgetState();
}

class _SearchFilterBarWidgetState extends State<SearchFilterBarWidget> {
  final Set<String> _selected = {};
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(String f) {
    setState(() {
      if (!_selected.add(f)) _selected.remove(f);
    });
    widget.onFiltersChanged?.call(Set.of(_selected));
  }

  void _openSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Filters',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(_selected.clear);
                          setSheet(() {});
                          widget.onFiltersChanged?.call({});
                        },
                        child: const Text('Clear all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final f in widget.filters)
                        FilterChip(
                          label: Text(f),
                          selected: _selected.contains(f),
                          onSelected: (_) {
                            _toggle(f);
                            setSheet(() {});
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: Text(
                        _selected.isEmpty
                            ? 'Show all'
                            : 'Apply ${_selected.length} filter${_selected.length > 1 ? 's' : ''}',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onSearch,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controller.clear();
                            widget.onSearch?.call('');
                            setState(() {});
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              button: true,
              label: 'Open filters',
              child: Material(
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  side: BorderSide(color: theme.colorScheme.outline),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  onTap: _openSheet,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.tune, color: theme.colorScheme.onSurface),
                        if (_selected.isNotEmpty)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final f = widget.filters[i];
              return FilterChip(
                label: Text(f),
                selected: _selected.contains(f),
                onSelected: (_) => _toggle(f),
                showCheckmark: true,
              );
            },
          ),
        ),
      ],
    );
  }
}
