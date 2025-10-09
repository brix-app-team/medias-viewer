# Medias Viewer

[![pub package](https://img.shields.io/pub/v/medias_viewer.svg)](https://pub.dev/packages/medias_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A powerful and customizable Flutter media viewer for images, videos and Youtube videos with zoom, swipe navigation, and video controls.
<p align="center">
<img src="https://github.com/brix-app-team/medias-viewer/blob/main/video.gif?raw=true"  width="40%" height="40%"/>
</p>

## Features

✨ **Image Support**
- Zoom with pinch-to-zoom and double-tap
- Pan and navigate zoomed images
- Support for network, local files, and assets
- High-resolution image support with caching
- Hero animations

🎬 **Video Support**
- Auto-pause when swiping away
- Full playback controls (play, pause, seek)
- Fullscreen support
- Support for network, local files, and assets
- Custom video player with Chewie
- SafeArea-aware controls (notch-friendly)
- Smart navigation arrows (auto-hide during video playback)
- Configurable back button positioning

📺 **YouTube Support**
- Play YouTube videos directly in the viewer
- Auto-detection of YouTube URLs (youtube.com, youtu.be)
- Integrated player without external browser
- Full support for autoPlay, controls, and fullscreen
- Compatible with Android, iOS, Web, and Desktop
- Seamless navigation with other media types

🎨 **Customization**
- Custom background colors
- Configurable page indicator (position, style, colors)
- Navigation arrows (left/right) with customizable position
- Back/Close button
- Enable/disable zoom
- Enable/disable loop navigation
- Auto-play videos option
- Custom indicator styles
- Swipe down to dismiss

⚡ **Performance**
- Optimized memory management
- Efficient video controller disposal
- Smooth page transitions
- Network image caching
- Improved swipe detection (horizontal vs vertical)

🎯 **User Experience**
- SafeArea support for all controls (notch-friendly)
- Swipe down gesture to close viewer
- Optional navigation arrows for manual control
- Configurable swipe sensitivity
- Smooth transitions between zoomed images

📱 **Platform Support**
- ✅ Android
- ✅ iOS
- ✅ Desktop (macOS)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  medias_viewer: ^0.4.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:medias_viewer/medias_viewer.dart';

class MyGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaViewer(
      items: [
        MediaItem.imageUrl('https://example.com/image1.jpg'),
        MediaItem.imageUrl('https://example.com/image2.jpg'),
        MediaItem.videoUrl('https://example.com/video.mp4'),
      ],
      onDismissed: () => Navigator.pop(context),
    );
  }
}
```

### Example with Auto-Detection

```dart
import 'package:flutter/material.dart';
import 'package:medias_viewer/medias_viewer.dart';

class MyGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaViewer(
      items: [
        // Type is automatically detected from file extension
        MediaItem.url('https://example.com/photo1.jpg'),
        MediaItem.url('https://example.com/photo2.png'),
        MediaItem.url('https://example.com/video.mp4'),
        MediaItem.url('https://example.com/clip.mov'),
      ],
      config: MediaViewerConfig(
        enableAutoDetectMediaType: true,  // Enable auto-detection
      ),
      onDismissed: () => Navigator.pop(context),
    );
  }
}
```

### Advanced Example

```dart
MediaViewer(
  items: [
    MediaItem.imageUrl('https://example.com/image1.jpg', tag: 'hero1'),
    MediaItem.videoUrl('https://example.com/video.mp4'),
    MediaItem.youtubeUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    MediaItem.imagePath('/path/to/local/image.jpg'),
    MediaItem.imageAsset('assets/images/photo.png'),
  ],
  initialIndex: 0,
  config: MediaViewerConfig(
    backgroundColor: Colors.black,
    showIndicator: true,
    indicatorPosition: IndicatorPosition.topCenter,
    indicatorStyle: IndicatorStyle(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.black54,
      borderRadius: 16,
    ),
    enableLoop: false,
    enableImageZoom: true,
    enableDoubleTapZoom: true,
    minScale: 1.0,
    maxScale: 3.0,
    autoPlayVideo: true,
    showVideoControls: true,
    allowFullScreen: true,
    onPageChanged: (index) => print('Page changed to $index'),
  ),
  onDismissed: () => Navigator.pop(context),
);
```

### YouTube Video Example

```dart
import 'package:flutter/material.dart';
import 'package:medias_viewer/medias_viewer.dart';

class YouTubeGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaViewer(
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
  }
}
```

### New Features Examples

#### Video UX Optimizations

The package now includes several video-specific UX improvements:

```dart
MediaViewer(
  items: [
    MediaItem.videoUrl('https://example.com/video.mp4'),
    // ... other items
  ],
  config: MediaViewerConfig(
    // Automatically hide navigation arrows when video is playing
    hideArrowsWhenVideoPlays: true,  // Default: true
    
    // Adjust back button position to avoid overlap with fullscreen button
    backButtonPadding: EdgeInsets.only(top: 16, left: 8),  // Default
    
    // Video controls automatically respect SafeArea (notch-friendly)
    showVideoControls: true,
  ),
);
```

**What's improved:**
- ✅ Video controls respect device SafeArea (no more controls hidden behind notches)
- ✅ Navigation arrows automatically fade out during video playback for unobstructed viewing
- ✅ Back button position is configurable to prevent overlap with Chewie's fullscreen button
- ✅ Smooth fade animations (300ms) for better user experience

#### With Navigation Arrows

```dart
MediaViewer(
  items: [...],
  config: MediaViewerConfig(
    showNavigationArrows: true,
    navigationArrowsPosition: NavigationArrowsPosition.centerVertical,
    arrowsColor: Colors.white,
    arrowsSize: 40,
  ),
);
```

#### With Back Button

```dart
MediaViewer(
  items: [...],
  config: MediaViewerConfig(
    showBackButton: true,
    backButtonColor: Colors.white,
  ),
  onDismissed: () => Navigator.pop(context),
);
```

#### Swipe Down to Dismiss

```dart
MediaViewer(
  items: [...],
  config: MediaViewerConfig(
    enableDismissOnSwipeDown: true,
  ),
  onDismissed: () => Navigator.pop(context),
);
```

#### Full Featured Gallery

```dart
MediaViewer(
  items: [...],
  config: MediaViewerConfig(
    // Navigation controls
    showNavigationArrows: true,
    navigationArrowsPosition: NavigationArrowsPosition.centerVertical,
    showBackButton: true,
    
    // Dismiss gesture
    enableDismissOnSwipeDown: true,
    
    // Indicator
    showIndicator: true,
    indicatorPosition: IndicatorPosition.topCenter,
    indicatorStyle: IndicatorStyle(
      backgroundColor: Colors.black54,
      borderRadius: 16,
    ),
    
    // Behavior
    autoPlayVideo: true,
    enableLoop: false,
  ),
  onDismissed: () => Navigator.pop(context),
);
```

### Creating Media Items

#### Auto-Detection (Recommended)

The simplest way to create media items is to use automatic type detection based on file extensions:

```dart
// Automatic detection from URL
MediaItem.url('https://example.com/photo.jpg')      // Detected as image
MediaItem.url('https://example.com/video.mp4')      // Detected as video

// Automatic detection from local path
MediaItem.path('/storage/photos/image.png')         // Detected as image
MediaItem.path('/storage/videos/clip.mov')          // Detected as video

// Automatic detection from asset
MediaItem.asset('assets/images/photo.jpg')          // Detected as image
MediaItem.asset('assets/videos/intro.mp4')          // Detected as video
```

**Supported Extensions:**
- **Images:** jpg, jpeg, png, gif, webp, bmp, svg
- **Videos:** mp4, mov, avi, mkv, webm, flv, m4v, wmv

**Note:** If the extension is not recognized, an `UnsupportedError` will be thrown with a helpful message listing all supported formats. For future versions, we plan to add HTTP Content-Type detection for even better reliability with network URLs.

#### Manual Type Specification

You can also explicitly specify the media type (useful when auto-detection isn't suitable):

#### Images

```dart
// Network image
MediaItem.imageUrl('https://example.com/image.jpg')

// Network image with hero tag
MediaItem.imageUrl('https://example.com/image.jpg', tag: 'hero_tag')

// Local file
MediaItem.imagePath('/path/to/image.jpg')

// Asset
MediaItem.imageAsset('assets/images/photo.png')
```

#### Videos

```dart
// Network video
MediaItem.videoUrl('https://example.com/video.mp4')

// Local file video
MediaItem.videoPath('/path/to/video.mp4')

// Asset video
MediaItem.videoAsset('assets/videos/intro.mp4')
```

#### YouTube Videos

```dart
// YouTube video from standard URL
MediaItem.youtubeUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ')

// YouTube video from short URL
MediaItem.youtubeUrl('https://youtu.be/dQw4w9WgXcQ')

// YouTube video with auto-detection
MediaItem.url('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
```

**Supported YouTube URL formats:**
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtube.com/watch?v=VIDEO_ID`
- `https://m.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `youtube.com/watch?v=VIDEO_ID` (without protocol)

**Note:** Make sure to add `youtube_player_iframe` to your dependencies. The package is compatible with Android, iOS, Web, and Desktop platforms.

### Configuration Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backgroundColor` | `Color` | `Colors.black` | Background color of the viewer |
| `showIndicator` | `bool` | `true` | Show page indicator (e.g., "1 of 5") |
| `indicatorPosition` | `IndicatorPosition` | `topCenter` | Position of the indicator |
| `indicatorStyle` | `IndicatorStyle?` | `null` | Custom style for the indicator |
| `enableLoop` | `bool` | `false` | Enable infinite loop navigation |
| `enableImageZoom` | `bool` | `true` | Enable zoom for images |
| `enableDoubleTapZoom` | `bool` | `true` | Enable double-tap to zoom |
| `minScale` | `double` | `1.0` | Minimum zoom scale |
| `maxScale` | `double` | `3.0` | Maximum zoom scale |
| `autoPlayVideo` | `bool` | `false` | Auto-play videos when displayed |
| `showVideoControls` | `bool` | `true` | Show video playback controls |
| `allowFullScreen` | `bool` | `true` | Allow fullscreen video |
| `pageSnapping` | `bool` | `true` | Enable page snapping |
| `onPageChanged` | `Function(int)?` | `null` | Callback when page changes |
| `showNavigationArrows` | `bool` | `false` | Show left/right navigation arrows |
| `navigationArrowsPosition` | `NavigationArrowsPosition` | `centerVertical` | Position of navigation arrows |
| `arrowsColor` | `Color` | `Colors.white` | Color of navigation arrows |
| `arrowsSize` | `double` | `40` | Size of navigation arrows |
| `showBackButton` | `bool` | `false` | Show back/close button |
| `backButtonColor` | `Color` | `Colors.white` | Color of back button |
| `backButtonPadding` | `EdgeInsets` | `EdgeInsets.only(top: 16, left: 8)` | Padding for back button positioning |
| `enableDismissOnSwipeDown` | `bool` | `false` | Enable swipe down to dismiss |
| `swipeToPageThreshold` | `double` | `0.6` | Swipe sensitivity (0.0 to 1.0) |
| `enableAutoDetectMediaType` | `bool` | `false` | Enable automatic media type detection from file extensions |
| `hideArrowsWhenVideoPlays` | `bool` | `true` | Automatically hide navigation arrows during video playback |
| `enableAutoDetectMediaType` | `bool` | `true` | Automatically detect the media type |

### Indicator Positions

- `IndicatorPosition.topLeft`
- `IndicatorPosition.topCenter`
- `IndicatorPosition.topRight`
- `IndicatorPosition.bottomLeft`
- `IndicatorPosition.bottomCenter`
- `IndicatorPosition.bottomRight`

### Navigation Arrows Positions

- `NavigationArrowsPosition.centerVertical`
- `NavigationArrowsPosition.top`
- `NavigationArrowsPosition.bottom`

## Example App

Check out the [example](example/) directory for a complete demo app with various use cases:

- Basic image gallery
- Mixed media (images and videos)
- Custom configurations
- Gallery with zoom disabled
- Video gallery with autoplay
- Grid gallery with hero animations
- Gallery with navigation arrows
- Gallery with back button
- Swipe down to dismiss gallery
- Full featured gallery (all options enabled)

To run the example:

```bash
cd example
flutter pub get
flutter run
```

## API Reference

### MediaViewer

The main widget for displaying media.

**Constructor Parameters:**
- `items` (required): List of `MediaItem` objects to display
- `initialIndex`: Starting index (default: 0)
- `config`: Configuration object for customization
- `onDismissed`: Callback when viewer is dismissed

### MediaItem

Represents a media item (image or video).

**Constructors:**
- `MediaItem.imageUrl(String url, {String? tag})`
- `MediaItem.imagePath(String path, {String? tag})`
- `MediaItem.imageAsset(String assetPath, {String? tag})`
- `MediaItem.videoUrl(String url)`
- `MediaItem.videoPath(String path)`
- `MediaItem.videoAsset(String assetPath)`
- `MediaItem.youtubeUrl(String url)` - **NEW in v0.4.0**
- `MediaItem.url(String url, {String? tag})` - Auto-detection (includes YouTube support)
- `MediaItem.path(String path, {String? tag})` - Auto-detection for local files
- `MediaItem.asset(String assetPath, {String? tag})` - Auto-detection for assets

### MediaViewerConfig

Configuration for the media viewer.

See the Configuration Options table above for all available properties.

### IndicatorStyle

Style configuration for the page indicator.

**Properties:**
- `textStyle`: Text style for the indicator
- `padding`: Padding around the indicator
- `backgroundColor`: Optional background color
- `borderRadius`: Border radius for the background

## Performance Tips

1. **Image Caching**: Network images are automatically cached using `cached_network_image`
2. **Video Memory**: Video controllers are properly disposed when swiping away
3. **Large Galleries**: The package efficiently handles large numbers of media items
4. **Lazy Loading**: Media items are loaded on-demand as you swipe

## Requirements

- Flutter >= 3.24.0
- Dart >= 3.9.2

## Dependencies

- `photo_view`: ^0.15.0 - Image zoom and pan
- `video_player`: ^2.9.2 - Video playback
- `chewie`: ^1.8.5 - Custom video player with controls
- `youtube_player_iframe`: ^5.2.1 - YouTube video playback (Web/Desktop compatible)
- `cached_network_image`: ^3.4.1 - Network image caching

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Issues

If you encounter any issues or have feature requests, please file them in the [issue tracker](https://github.com/brix-app-team//medias_viewer/issues).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

BRIX - [GitHub](https://github.com/brix-app-team)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Uses [photo_view](https://pub.dev/packages/photo_view) for image zoom
- Uses [video_player](https://pub.dev/packages/video_player) and [chewie](https://pub.dev/packages/chewie) for video playback
- Uses [cached_network_image](https://pub.dev/packages/cached_network_image) for efficient image caching

