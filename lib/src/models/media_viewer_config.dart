import 'package:flutter/material.dart';

/// Configuration for the media viewer's appearance and behavior.
class MediaViewerConfig {
  /// Creates a [MediaViewerConfig].
  const MediaViewerConfig({
    this.backgroundColor = Colors.black,
    this.showIndicator = true,
    this.indicatorPosition = IndicatorPosition.topCenter,
    this.indicatorStyle,
    this.enableLoop = false,
    this.enableImageZoom = true,
    this.enableDoubleTapZoom = true,
    this.minScale = 1.0,
    this.maxScale = 3.0,
    this.autoPlayVideo = false,
    this.showVideoControls = true,
    this.allowFullScreen = true,
    this.pageSnapping = true,
    this.onPageChanged,
    this.heroTagSuffix = 'media_viewer',
    this.showNavigationArrows = false,
    this.navigationArrowsPosition = NavigationArrowsPosition.centerVertical,
    this.arrowsColor = Colors.white,
    this.arrowsSize = 40,
    this.showBackButton = false,
    this.backButtonColor = Colors.white,
    this.backButtonPadding = const EdgeInsets.only(top: 16, left: 8),
    this.enableDismissOnSwipeDown = false,
    this.swipeToPageThreshold = 0.6,
    this.enableAutoDetectMediaType = false,
    this.hideArrowsWhenVideoPlays = true,
  });

  /// Background color of the viewer.
  final Color backgroundColor;

  /// Whether to show the page indicator (e.g., "1 of 5").
  final bool showIndicator;

  /// Position of the indicator on the screen.
  final IndicatorPosition indicatorPosition;

  /// Custom style for the indicator.
  final IndicatorStyle? indicatorStyle;

  /// Whether to loop back to the first item after the last item.
  final bool enableLoop;

  /// Whether to enable zoom for images.
  final bool enableImageZoom;

  /// Whether to enable double-tap to zoom.
  final bool enableDoubleTapZoom;

  /// Minimum scale for image zoom.
  final double minScale;

  /// Maximum scale for image zoom.
  final double maxScale;

  /// Whether to auto-play videos when swiped to.
  final bool autoPlayVideo;

  /// Whether to show video playback controls.
  final bool showVideoControls;

  /// Whether to allow fullscreen video playback.
  final bool allowFullScreen;

  /// Whether pages snap to the nearest page.
  final bool pageSnapping;

  /// Callback when the page changes.
  final void Function(int index)? onPageChanged;

  /// Suffix for hero animation tags.
  final String heroTagSuffix;

  /// Whether to show navigation arrows (left/right).
  final bool showNavigationArrows;

  /// Position of the navigation arrows.
  final NavigationArrowsPosition navigationArrowsPosition;

  /// Color of the navigation arrows.
  final Color arrowsColor;

  /// Size of the navigation arrows.
  final double arrowsSize;

  /// Whether to show a back button.
  final bool showBackButton;

  /// Color of the back button.
  final Color backButtonColor;

  /// Padding for the back button to avoid overlapping with fullscreen button.
  final EdgeInsets backButtonPadding;

  /// Whether to enable dismiss on swipe down gesture.
  final bool enableDismissOnSwipeDown;

  /// Threshold for detecting horizontal swipe vs image pan (0.0 to 1.0).
  /// Higher values make it easier to pan, lower values prioritize page swipe.
  final double swipeToPageThreshold;

  /// Whether to enable automatic media type detection from file extension.
  /// When enabled, you can use MediaItem.url() instead of MediaItem.imageUrl() or MediaItem.videoUrl().
  /// The type will be detected based on the file extension.
  final bool enableAutoDetectMediaType;

  /// Whether to hide navigation arrows when a video is playing.
  /// When true, arrows will fade out during video playback and reappear when paused.
  final bool hideArrowsWhenVideoPlays;

  /// Creates a copy of this config with the given fields replaced.
  MediaViewerConfig copyWith({
    Color? backgroundColor,
    bool? showIndicator,
    IndicatorPosition? indicatorPosition,
    IndicatorStyle? indicatorStyle,
    bool? enableLoop,
    bool? enableImageZoom,
    bool? enableDoubleTapZoom,
    double? minScale,
    double? maxScale,
    bool? autoPlayVideo,
    bool? showVideoControls,
    bool? allowFullScreen,
    bool? pageSnapping,
    void Function(int index)? onPageChanged,
    String? heroTagSuffix,
    bool? showNavigationArrows,
    NavigationArrowsPosition? navigationArrowsPosition,
    Color? arrowsColor,
    double? arrowsSize,
    bool? showBackButton,
    Color? backButtonColor,
    EdgeInsets? backButtonPadding,
    bool? enableDismissOnSwipeDown,
    double? swipeToPageThreshold,
    bool? enableAutoDetectMediaType,
    bool? hideArrowsWhenVideoPlays,
  }) {
    return MediaViewerConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showIndicator: showIndicator ?? this.showIndicator,
      indicatorPosition: indicatorPosition ?? this.indicatorPosition,
      indicatorStyle: indicatorStyle ?? this.indicatorStyle,
      enableLoop: enableLoop ?? this.enableLoop,
      enableImageZoom: enableImageZoom ?? this.enableImageZoom,
      enableDoubleTapZoom: enableDoubleTapZoom ?? this.enableDoubleTapZoom,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      autoPlayVideo: autoPlayVideo ?? this.autoPlayVideo,
      showVideoControls: showVideoControls ?? this.showVideoControls,
      allowFullScreen: allowFullScreen ?? this.allowFullScreen,
      pageSnapping: pageSnapping ?? this.pageSnapping,
      onPageChanged: onPageChanged ?? this.onPageChanged,
      heroTagSuffix: heroTagSuffix ?? this.heroTagSuffix,
      showNavigationArrows: showNavigationArrows ?? this.showNavigationArrows,
      navigationArrowsPosition:
          navigationArrowsPosition ?? this.navigationArrowsPosition,
      arrowsColor: arrowsColor ?? this.arrowsColor,
      arrowsSize: arrowsSize ?? this.arrowsSize,
      showBackButton: showBackButton ?? this.showBackButton,
      backButtonColor: backButtonColor ?? this.backButtonColor,
      backButtonPadding: backButtonPadding ?? this.backButtonPadding,
      enableDismissOnSwipeDown:
          enableDismissOnSwipeDown ?? this.enableDismissOnSwipeDown,
      swipeToPageThreshold: swipeToPageThreshold ?? this.swipeToPageThreshold,
      enableAutoDetectMediaType:
          enableAutoDetectMediaType ?? this.enableAutoDetectMediaType,
      hideArrowsWhenVideoPlays:
          hideArrowsWhenVideoPlays ?? this.hideArrowsWhenVideoPlays,
    );
  }
}

/// Position of the page indicator.
enum IndicatorPosition {
  /// Top left corner.
  topLeft,

  /// Top center.
  topCenter,

  /// Top right corner.
  topRight,

  /// Bottom left corner.
  bottomLeft,

  /// Bottom center.
  bottomCenter,

  /// Bottom right corner.
  bottomRight,
}

/// Position of the navigation arrows.
enum NavigationArrowsPosition {
  /// Center vertical position.
  centerVertical,

  /// Top position.
  top,

  /// Bottom position.
  bottom,
}

/// Style configuration for the page indicator.
class IndicatorStyle {
  /// Creates an [IndicatorStyle].
  const IndicatorStyle({
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius = 8,
  });

  /// Text style for the indicator.
  final TextStyle textStyle;

  /// Padding around the indicator.
  final EdgeInsets padding;

  /// Optional background color for the indicator.
  final Color? backgroundColor;

  /// Border radius for the indicator background.
  final double borderRadius;
}
