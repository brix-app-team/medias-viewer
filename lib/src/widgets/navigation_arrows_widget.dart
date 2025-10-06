import 'package:flutter/material.dart';
import '../models/media_viewer_config.dart';

/// Widget that displays navigation arrows for moving between media items.
class NavigationArrowsWidget extends StatelessWidget {
  /// Creates a [NavigationArrowsWidget].
  const NavigationArrowsWidget({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.position,
    required this.color,
    required this.size,
    required this.onPrevious,
    required this.onNext,
    this.enableLoop = false,
    this.isVisible = true,
  });

  /// The current page index (0-based).
  final int currentIndex;

  /// The total number of pages.
  final int totalCount;

  /// The position of the arrows on the screen.
  final NavigationArrowsPosition position;

  /// Color of the arrows.
  final Color color;

  /// Size of the arrows.
  final double size;

  /// Callback when previous arrow is tapped.
  final VoidCallback onPrevious;

  /// Callback when next arrow is tapped.
  final VoidCallback onNext;

  /// Whether loop navigation is enabled.
  final bool enableLoop;

  /// Whether the arrows should be visible (for animation).
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final showPrevious = enableLoop || currentIndex > 0;
    final showNext = enableLoop || currentIndex < totalCount - 1;

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: !isVisible,
        child: Align(
          alignment: _getAlignment(position),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Previous arrow
                _ArrowButton(
                  icon: Icons.chevron_left,
                  color: color,
                  size: size,
                  onTap: showPrevious ? onPrevious : null,
                ),

                // Next arrow
                _ArrowButton(
                  icon: Icons.chevron_right,
                  color: color,
                  size: size,
                  onTap: showNext ? onNext : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment(NavigationArrowsPosition position) {
    switch (position) {
      case NavigationArrowsPosition.top:
        return Alignment.topCenter;
      case NavigationArrowsPosition.bottom:
        return Alignment.bottomCenter;
      case NavigationArrowsPosition.centerVertical:
        return Alignment.center;
    }
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.color,
    required this.size,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return SizedBox(width: size);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: size),
        ),
      ),
    );
  }
}
