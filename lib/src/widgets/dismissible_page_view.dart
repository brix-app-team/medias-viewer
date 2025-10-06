import 'package:flutter/material.dart';

/// A wrapper that allows dismissing the content by swiping down.
class DismissiblePageView extends StatefulWidget {
  /// Creates a [DismissiblePageView].
  const DismissiblePageView({
    super.key,
    required this.child,
    required this.onDismissed,
    this.enabled = true,
    this.backgroundColor = Colors.black,
  });

  /// The child widget to wrap.
  final Widget child;

  /// Callback when dismissed.
  final VoidCallback onDismissed;

  /// Whether dismissible is enabled.
  final bool enabled;

  /// Background color.
  final Color backgroundColor;

  @override
  State<DismissiblePageView> createState() => _DismissiblePageViewState();
}

class _DismissiblePageViewState extends State<DismissiblePageView>
    with SingleTickerProviderStateMixin {
  double _dragExtent = 0;
  bool _isDragging = false;

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled) return;
    setState(() {
      _isDragging = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled || !_isDragging) return;

    setState(() {
      _dragExtent += details.primaryDelta ?? 0;
      // Only allow downward dragging
      if (_dragExtent < 0) {
        _dragExtent = 0;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled || !_isDragging) return;

    final threshold = MediaQuery.of(context).size.height * 0.3;

    if (_dragExtent > threshold) {
      // Dismiss
      widget.onDismissed();
    } else {
      // Reset
      setState(() {
        _dragExtent = 0;
      });
    }

    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final opacity = (1.0 - (_dragExtent / MediaQuery.of(context).size.height))
        .clamp(0.0, 1.0);

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Container(
        color: widget.backgroundColor.withValues(alpha: opacity),
        child: Transform.translate(
          offset: Offset(0, _dragExtent),
          child: widget.child,
        ),
      ),
    );
  }
}
