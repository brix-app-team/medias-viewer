import 'package:flutter/material.dart';
import '../models/media_viewer_config.dart';

/// Widget that displays the current page indicator (e.g., "1 of 5").
class PageIndicatorWidget extends StatelessWidget {
  /// Creates a [PageIndicatorWidget].
  const PageIndicatorWidget({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.position,
    this.style,
  });

  /// The current page index (0-based).
  final int currentIndex;

  /// The total number of pages.
  final int totalCount;

  /// The position of the indicator on the screen.
  final IndicatorPosition position;

  /// Custom style for the indicator.
  final IndicatorStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        style ??
        const IndicatorStyle(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          padding: EdgeInsets.all(16),
          borderRadius: 8,
        );

    final indicator = Container(
      padding: effectiveStyle.padding,
      decoration: effectiveStyle.backgroundColor != null
          ? BoxDecoration(
              color: effectiveStyle.backgroundColor,
              borderRadius: BorderRadius.circular(effectiveStyle.borderRadius),
            )
          : null,
      child: Text(
        '${currentIndex + 1} of $totalCount',
        style: effectiveStyle.textStyle,
      ),
    );

    return SafeArea(
      child: Align(alignment: _getAlignment(position), child: indicator),
    );
  }

  Alignment _getAlignment(IndicatorPosition position) {
    switch (position) {
      case IndicatorPosition.topLeft:
        return Alignment.topLeft;
      case IndicatorPosition.topCenter:
        return Alignment.topCenter;
      case IndicatorPosition.topRight:
        return Alignment.topRight;
      case IndicatorPosition.bottomLeft:
        return Alignment.bottomLeft;
      case IndicatorPosition.bottomCenter:
        return Alignment.bottomCenter;
      case IndicatorPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }
}
