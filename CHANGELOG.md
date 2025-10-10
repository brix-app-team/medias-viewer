# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2025-10-10

### Changed
- **BREAKING CHANGE**: Replaced `youtube_player_iframe` with `youtube_player_flutter` version 9.1.3
  - Better mobile compatibility (Android & iOS)
  - Simpler integration and more fluid user experience
  - Improved fullscreen handling and video controls
  - Optimized for mobile platforms with native performance
  
### Technical Changes
- Updated `YouTubeViewerWidget` to use `youtube_player_flutter` API
  - Controller initialization simplified with `YoutubePlayerController`
  - Flags-based configuration for better control
  - Direct listener pattern for state changes
  - Improved dispose lifecycle management
  
### Migration Guide
If you're upgrading from v0.4.x:
1. Run `flutter pub get` to install the new `youtube_player_flutter` dependency
2. Remove any platform-specific web configurations if you had them for `youtube_player_iframe`
3. All existing YouTube functionality remains the same from a user perspective
4. Note: Web and Desktop platform support for YouTube is no longer available (mobile-focused)

### Dependencies
- Removed `youtube_player_iframe: ^5.2.1`
- Added `youtube_player_flutter: 9.1.3` - Optimized YouTube player for mobile platforms

## [0.4.2] - 2025-10-10

### Enhanced
- add formatHint HLS when video is an m3u8

## [0.4.1] - 2025-10-10

### Enhanced
- `MediaTypeDetector` now detect `m3u8` and `ts` extensions for videos

## [0.4.0] - 2025-10-09

### Added
- **YouTube Video Support**: Play YouTube videos directly in the media viewer
  - New `MediaItem.youtubeUrl()` constructor for YouTube videos
  - Automatic YouTube URL detection (supports youtube.com and youtu.be formats)
  - Integrated YouTube player using `youtube_player_flutter` (optimized for mobile)
  - Full support for `autoPlayVideo`, `showVideoControls`, and `allowFullScreen` config options
  - Seamless navigation between YouTube videos, regular videos, and images
  - Auto-pause when swiping away from YouTube videos
  - Navigation arrows automatically hide during YouTube video playback
  - Compatible with Android and iOS platforms with excellent performance
  
- **YouTube URL Detection**: 
  - `MediaTypeDetector.isYouTubeUrl()` - Check if a URL is a YouTube URL
  - `MediaTypeDetector.extractYouTubeVideoId()` - Extract video ID from YouTube URL
  - `MediaItem.isYouTube` getter - Check if a media item is a YouTube video
  - `MediaItem.youtubeVideoId` getter - Get the YouTube video ID
  
- **Supported YouTube URL formats**:
  - `https://www.youtube.com/watch?v=VIDEO_ID`
  - `https://youtube.com/watch?v=VIDEO_ID`
  - `https://m.youtube.com/watch?v=VIDEO_ID`
  - `https://youtu.be/VIDEO_ID`
  - `youtube.com/watch?v=VIDEO_ID` (without protocol)

### Enhanced
- `MediaType` enum now includes `youtube` type
- Auto-detection now recognizes YouTube URLs when using `MediaItem.url()`
- `YouTubeViewerWidget` follows the same architecture as `VideoViewerWidget` for consistency
- YouTube player respects SafeArea for better UX on devices with notches
- Proper controller cleanup to prevent memory leaks

### Dependencies
- Added `youtube_player_flutter: 9.1.3` - Modern YouTube player optimized for mobile

### Example
```dart
MediaViewer(
  items: [
    MediaItem.youtubeUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    MediaItem.imageUrl('https://example.com/photo.jpg'),
    MediaItem.youtubeUrl('https://youtu.be/9bZkp7q19f0'),
  ],
  config: MediaViewerConfig(
    autoPlayVideo: true,
    allowFullScreen: true,
    showBackButton: true,
    enableDismissOnSwipeDown: true,
  ),
  onDismissed: () => Navigator.pop(context),
);
```

### Migration Guide
If you're upgrading from v0.3.x:
1. Run `flutter pub get` to install the new `youtube_player_flutter` dependency
2. No breaking changes - all existing code will continue to work
3. Optionally, add YouTube videos using `MediaItem.youtubeUrl()` or `MediaItem.url()` with auto-detection
4. Note: YouTube support is now optimized for mobile (Android & iOS) platforms

## [0.3.4] 2025-10-06

- Update readme

## [0.3.3] 2025-10-06

- Update video on readme

## [0.3.2] 2025-10-06

- Update format and readme

## [0.3.1] - 2025-10-03

### Added
- **Video UX Optimizations**: Enhanced video playback experience with smart UI controls
  - `hideArrowsWhenVideoPlays` config option (default: true) - Navigation arrows automatically fade out during video playback and fade back in when paused
  - `backButtonPadding` config option (default: EdgeInsets.only(top: 16, left: 8)) - Configurable back button positioning to prevent overlap with Chewie's fullscreen button
  - SafeArea wrapper for video controls - Ensures video controls respect device notches and safe areas on all devices

### Enhanced
- **Smooth animations**: Navigation arrows now use AnimatedOpacity with 300ms fade transitions for better UX
- **Video state tracking**: Implemented callback system to track video playing/paused state
- **Better ergonomics**: Back button position now customizable to avoid UI element conflicts

### Technical
- Video playing state propagates from VideoPlayerController → VideoViewerWidget → MediaViewer
- AnimatedOpacity with IgnorePointer ensures arrows don't interfere with touch events when hidden
- Proper video state listener cleanup in dispose() method

### Example
```dart
MediaViewer(
  items: [MediaItem.videoUrl('https://example.com/video.mp4')],
  config: MediaViewerConfig(
    // Arrows automatically hide during video playback
    hideArrowsWhenVideoPlays: true,
    
    // Custom back button position to avoid overlap
    backButtonPadding: EdgeInsets.only(top: 20, left: 12),
    
    // Video controls respect SafeArea automatically
    showVideoControls: true,
  ),
);
```

## [0.3.0] - 2025-10-03

### Added
- **Automatic media type detection**: New feature to automatically detect whether a media item is an image or video based on file extension
  - New constructors: `MediaItem.url()`, `MediaItem.path()`, `MediaItem.asset()`
  - Simplifies API usage - no need to specify `.imageUrl()` or `.videoUrl()` anymore
  - `enableAutoDetectMediaType` config option (default: false for backward compatibility)
  - Supports common image formats: jpg, jpeg, png, gif, webp, bmp, svg
  - Supports common video formats: mp4, mov, avi, mkv, webm, flv, m4v, wmv
  - Clear error messages when extension is not recognized
  - Case-insensitive extension matching
  - Handles URLs with query parameters and fragments

### Technical
- New `MediaTypeDetector` utility class for extension-based detection
- Comprehensive unit tests for auto-detection (25+ test cases)
- Updated documentation with auto-detection examples and supported formats
- Future-proof design for HTTP Content-Type detection

### Example
```dart
// Before (explicit type specification)
MediaItem.imageUrl('https://example.com/photo.jpg')
MediaItem.videoUrl('https://example.com/video.mp4')

// After (automatic detection)
MediaItem.url('https://example.com/photo.jpg')  // Detected as image
MediaItem.url('https://example.com/video.mp4')  // Detected as video
```

## [0.2.0] - 2025-10-03

### Added
- **Navigation arrows**: Optional left/right arrows for manual navigation between media items
  - Configurable position (center, top, bottom)
  - Customizable color and size
  - `showNavigationArrows`, `navigationArrowsPosition`, `arrowsColor`, `arrowsSize` config options
- **Back button**: Optional close button in top-left corner
  - Configurable color
  - `showBackButton`, `backButtonColor` config options
- **Swipe down to dismiss**: Gesture to close the viewer by swiping down
  - Smooth animation with fade-out effect
  - `enableDismissOnSwipeDown` config option
- **SafeArea support**: All UI controls now respect device notches and safe areas
- **Swipe threshold configuration**: `swipeToPageThreshold` to control horizontal swipe sensitivity

### Fixed
- **Improved swipe detection**: Better distinction between horizontal page swipes and image pan gestures
- **Smooth transitions**: Eliminated visual glitches when swiping between zoomed images
- **Image caching**: Better preloading for smoother transitions

### Enhanced
- Example app now includes 10 different demos showcasing all features
- Updated tests to cover new functionality (12 tests passing)
- Improved documentation with detailed examples

## [0.1.0] - 2025-10-03

### Added
- Initial release of medias_viewer package
- Image viewer with zoom capabilities (pinch-to-zoom and double-tap)
- Video viewer with playback controls using Chewie
- Swipe navigation between media items using PageView
- Customizable page indicator showing current position (e.g., "1 of 5")
- Support for network URLs, local files, and asset paths
- Configurable appearance (colors, indicator position, styles)
- Hero animations support for images
- Auto-play option for videos
- Loop navigation option
- Fullscreen support for videos
- Cached network images for better performance
- Comprehensive configuration options via MediaViewerConfig
- Complete example app with multiple use cases
- Unit tests for models and core functionality
- Full documentation with API reference
- Multi-platform support (Android, iOS, Web, Desktop)

### Features
- **Image Support**: 
  - Zoom with pinch and double-tap gestures
  - Pan zoomed images
  - Network, file, and asset sources
  - Hero animations
  
- **Video Support**: 
  - Auto-pause when swiping away
  - Playback controls (play, pause, seek)
  - Fullscreen mode
  - Network, file, and asset sources
  
- **Customization**: 
  - Background colors
  - Indicator position (6 positions available)
  - Custom indicator styles
  - Enable/disable zoom
  - Enable/disable loop
  - Auto-play videos
  
- **Performance**: 
  - Efficient memory management
  - Proper video controller disposal
  - Network image caching
  - Smooth transitions

[0.1.0]: https://github.com/yourusername/medias_viewer/releases/tag/v0.1.0
