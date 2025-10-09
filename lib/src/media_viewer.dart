import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models/media_item.dart';
import 'models/media_viewer_config.dart';
import 'widgets/image_viewer_widget.dart';
import 'widgets/video_viewer_widget.dart';
import 'widgets/youtube_viewer_widget.dart';
import 'widgets/page_indicator_widget.dart';
import 'widgets/navigation_arrows_widget.dart';
import 'widgets/back_button_widget.dart';
import 'widgets/dismissible_page_view.dart';

/// A powerful and customizable media viewer for images and videos.
///
/// This widget provides a gallery-like experience with:
/// - Swipe navigation between media items
/// - Image zoom with pinch and double-tap
/// - Video playback with controls
/// - Customizable appearance and behavior
///
/// Example:
/// ```dart
/// MediaViewer(
///   items: [
///     MediaItem.imageUrl('https://example.com/image1.jpg'),
///     MediaItem.videoUrl('https://example.com/video1.mp4'),
///   ],
/// )
/// ```
class MediaViewer extends StatefulWidget {
  /// Creates a [MediaViewer].
  ///
  /// The [items] parameter must not be empty.
  const MediaViewer({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.config = const MediaViewerConfig(),
    this.onDismissed,
  }) : assert(items.length > 0, 'Items list cannot be empty');

  /// The list of media items to display.
  final List<MediaItem> items;

  /// The initial index to display (0-based).
  final int initialIndex;

  /// Configuration for the viewer's appearance and behavior.
  final MediaViewerConfig config;

  /// Callback when the viewer is dismissed (e.g., by tapping).
  final VoidCallback? onDismissed;

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Preload adjacent images for smooth transitions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAdjacentImages();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Precache adjacent images to prevent glitches during swipe
  void _precacheAdjacentImages() {
    if (!mounted) return;

    // Precache previous image
    if (_currentIndex > 0) {
      final prevItem = widget.items[_currentIndex - 1];
      if (prevItem.isImage && prevItem.url != null) {
        precacheImage(CachedNetworkImageProvider(prevItem.url!), context);
      }
    }

    // Precache next image
    if (_currentIndex < widget.items.length - 1) {
      final nextItem = widget.items[_currentIndex + 1];
      if (nextItem.isImage && nextItem.url != null) {
        precacheImage(CachedNetworkImageProvider(nextItem.url!), context);
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _precacheAdjacentImages();

    // Call the callback if provided
    widget.config.onPageChanged?.call(index);
  }

  void _handleTap() {
    // Dismiss if callback is provided
    widget.onDismissed?.call();
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (widget.config.enableLoop) {
      _pageController.jumpToPage(widget.items.length - 1);
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (widget.config.enableLoop) {
      _pageController.jumpToPage(0);
    }
  }

  void _handleDismiss() {
    widget.onDismissed?.call();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        // PageView for media items
        PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: widget.config.enableLoop ? null : widget.items.length,
          pageSnapping: widget.config.pageSnapping,
          itemBuilder: (context, index) {
            final actualIndex = widget.config.enableLoop
                ? index % widget.items.length
                : index;
            final item = widget.items[actualIndex];

            if (item.isImage) {
              return ImageViewerWidget(
                item: item,
                config: widget.config,
                onTap: _handleTap,
              );
            } else if (item.isYouTube) {
              return GestureDetector(
                onTap: _handleTap,
                child: YouTubeViewerWidget(
                  key: ValueKey('youtube_$actualIndex'),
                  item: item,
                  config: widget.config,
                  autoPlay: actualIndex == _currentIndex,
                  onPlayingStateChanged: (isPlaying) {
                    if (widget.config.hideArrowsWhenVideoPlays) {
                      setState(() {
                        _isVideoPlaying = isPlaying;
                      });
                    }
                  },
                ),
              );
            } else {
              return GestureDetector(
                onTap: _handleTap,
                child: VideoViewerWidget(
                  key: ValueKey('video_$actualIndex'),
                  item: item,
                  config: widget.config,
                  autoPlay: actualIndex == _currentIndex,
                  onPlayingStateChanged: (isPlaying) {
                    if (widget.config.hideArrowsWhenVideoPlays) {
                      setState(() {
                        _isVideoPlaying = isPlaying;
                      });
                    }
                  },
                ),
              );
            }
          },
        ),

        // Navigation arrows
        if (widget.config.showNavigationArrows)
          Positioned.fill(
            child: NavigationArrowsWidget(
              currentIndex: _currentIndex,
              totalCount: widget.items.length,
              position: widget.config.navigationArrowsPosition,
              color: widget.config.arrowsColor,
              size: widget.config.arrowsSize,
              onPrevious: _goToPrevious,
              onNext: _goToNext,
              enableLoop: widget.config.enableLoop,
              isVisible: !_isVideoPlaying,
            ),
          ),

        // Page indicator
        if (widget.config.showIndicator && widget.items.length > 1)
          SafeArea(
            child: PageIndicatorWidget(
              currentIndex: _currentIndex,
              totalCount: widget.items.length,
              position: widget.config.indicatorPosition,
              style: widget.config.indicatorStyle,
            ),
          ),

        // Back button
        if (widget.config.showBackButton)
          Positioned(
            top: widget.config.backButtonPadding.top,
            left: widget.config.backButtonPadding.left,
            child: BackButtonWidget(
              color: widget.config.backButtonColor,
              onPressed: _handleDismiss,
            ),
          ),
      ],
    );

    // Wrap with dismissible if enabled
    if (widget.config.enableDismissOnSwipeDown) {
      content = DismissiblePageView(
        onDismissed: _handleDismiss,
        backgroundColor: widget.config.backgroundColor,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: widget.config.backgroundColor,
      body: content,
    );
  }
}
