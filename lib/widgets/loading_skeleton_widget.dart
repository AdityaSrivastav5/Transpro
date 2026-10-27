import 'package:flutter/material.dart';

/// Shimmer block driven by an AnimationController (no extra package).
class LoadingSkeletonWidget extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;

  const LoadingSkeletonWidget({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = dark ? const Color(0xFF1B2640) : const Color(0xFFE8EDF4);
    final highlight = dark ? const Color(0xFF2A3A5C) : const Color(0xFFF4F7FB);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * t, 0),
              end: Alignment(1.0 + 2.0 * t, 0),
              colors: [base, highlight, base],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton shaped like the Home dashboard (KPI grid, list rows, chart).
class HomeSkeletonWidget extends StatelessWidget {
  const HomeSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.surface;
    final border = Theme.of(context).colorScheme.outline;

    Widget card(Widget child) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: child,
    );

    return Column(
      children: [
        const LoadingSkeletonWidget(height: 120, radius: 12),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: card(const _KpiBone())),
            const SizedBox(width: 12),
            Expanded(child: card(const _KpiBone())),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: card(const _KpiBone())),
            const SizedBox(width: 12),
            Expanded(child: card(const _KpiBone())),
          ],
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < 3; i++) ...[
          card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LoadingSkeletonWidget(width: 160, height: 14),
                SizedBox(height: 10),
                LoadingSkeletonWidget(height: 10),
                SizedBox(height: 10),
                LoadingSkeletonWidget(width: 220, height: 10),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        const LoadingSkeletonWidget(height: 200, radius: 12),
      ],
    );
  }
}

class _KpiBone extends StatelessWidget {
  const _KpiBone();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadingSkeletonWidget(width: 80, height: 12),
        SizedBox(height: 12),
        LoadingSkeletonWidget(width: 60, height: 26),
        SizedBox(height: 10),
        LoadingSkeletonWidget(width: 100, height: 10),
      ],
    );
  }
}
