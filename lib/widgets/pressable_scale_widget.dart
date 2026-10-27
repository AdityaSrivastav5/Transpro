import 'package:flutter/material.dart';

/// 1.0 -> 0.96 -> 1.0 press feedback shared by tappable cards.
class PressableScaleWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;

  const PressableScaleWidget({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<PressableScaleWidget> createState() => _PressableScaleWidgetState();
}

class _PressableScaleWidgetState extends State<PressableScaleWidget> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;
    return AnimatedScale(
      scale: _down ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        borderRadius: widget.borderRadius,
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _down = v),
          child: widget.child,
        ),
      ),
    );
  }
}
