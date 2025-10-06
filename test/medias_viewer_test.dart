import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medias_viewer/medias_viewer.dart';

void main() {
  group('MediaItem', () {
    test('imageUrl constructor creates correct MediaItem', () {
      const item = MediaItem.imageUrl('https://example.com/image.jpg');
      
      expect(item.type, MediaType.image);
      expect(item.url, 'https://example.com/image.jpg');
      expect(item.isImage, true);
      expect(item.isVideo, false);
    });

    test('videoUrl constructor creates correct MediaItem', () {
      const item = MediaItem.videoUrl('https://example.com/video.mp4');
      
      expect(item.type, MediaType.video);
      expect(item.url, 'https://example.com/video.mp4');
      expect(item.isVideo, true);
      expect(item.isImage, false);
    });

    test('imagePath constructor creates correct MediaItem', () {
      const item = MediaItem.imagePath('/path/to/image.jpg');
      
      expect(item.type, MediaType.image);
      expect(item.path, '/path/to/image.jpg');
      expect(item.isImage, true);
    });

    test('imageAsset constructor creates correct MediaItem', () {
      const item = MediaItem.imageAsset('assets/image.png');
      
      expect(item.type, MediaType.image);
      expect(item.assetPath, 'assets/image.png');
      expect(item.isImage, true);
    });

    test('source getter returns correct value', () {
      const urlItem = MediaItem.imageUrl('https://example.com/image.jpg');
      const pathItem = MediaItem.imagePath('/path/to/image.jpg');
      const assetItem = MediaItem.imageAsset('assets/image.png');
      
      expect(urlItem.source, 'https://example.com/image.jpg');
      expect(pathItem.source, '/path/to/image.jpg');
      expect(assetItem.source, 'assets/image.png');
    });

    test('equality operator works correctly', () {
      const item1 = MediaItem.imageUrl('https://example.com/image.jpg');
      const item2 = MediaItem.imageUrl('https://example.com/image.jpg');
      const item3 = MediaItem.imageUrl('https://example.com/other.jpg');
      
      expect(item1, item2);
      expect(item1 == item3, false);
    });

    test('hashCode is consistent', () {
      const item1 = MediaItem.imageUrl('https://example.com/image.jpg');
      const item2 = MediaItem.imageUrl('https://example.com/image.jpg');
      
      expect(item1.hashCode, item2.hashCode);
    });
  });

  group('MediaItem Auto-Detection', () {
    test('url constructor detects image from jpg extension', () {
      final item = MediaItem.url('https://example.com/photo.jpg');
      
      expect(item.type, MediaType.image);
      expect(item.url, 'https://example.com/photo.jpg');
      expect(item.isImage, true);
      expect(item.isVideo, false);
    });

    test('url constructor detects image from jpeg extension', () {
      final item = MediaItem.url('https://example.com/photo.jpeg');
      
      expect(item.type, MediaType.image);
      expect(item.isImage, true);
    });

    test('url constructor detects image from png extension', () {
      final item = MediaItem.url('https://example.com/photo.png');
      
      expect(item.type, MediaType.image);
      expect(item.isImage, true);
    });

    test('url constructor detects image from gif extension', () {
      final item = MediaItem.url('https://example.com/animation.gif');
      
      expect(item.type, MediaType.image);
      expect(item.isImage, true);
    });

    test('url constructor detects image from webp extension', () {
      final item = MediaItem.url('https://example.com/photo.webp');
      
      expect(item.type, MediaType.image);
      expect(item.isImage, true);
    });

    test('url constructor detects video from mp4 extension', () {
      final item = MediaItem.url('https://example.com/video.mp4');
      
      expect(item.type, MediaType.video);
      expect(item.url, 'https://example.com/video.mp4');
      expect(item.isVideo, true);
      expect(item.isImage, false);
    });

    test('url constructor detects video from mov extension', () {
      final item = MediaItem.url('https://example.com/clip.mov');
      
      expect(item.type, MediaType.video);
      expect(item.isVideo, true);
    });

    test('url constructor detects video from avi extension', () {
      final item = MediaItem.url('https://example.com/video.avi');
      
      expect(item.type, MediaType.video);
      expect(item.isVideo, true);
    });

    test('url constructor detects video from mkv extension', () {
      final item = MediaItem.url('https://example.com/video.mkv');
      
      expect(item.type, MediaType.video);
      expect(item.isVideo, true);
    });

    test('url constructor detects video from webm extension', () {
      final item = MediaItem.url('https://example.com/video.webm');
      
      expect(item.type, MediaType.video);
      expect(item.isVideo, true);
    });

    test('url constructor handles query parameters', () {
      final item = MediaItem.url('https://example.com/photo.jpg?size=large&quality=high');
      
      expect(item.type, MediaType.image);
      expect(item.isImage, true);
    });

    test('url constructor handles query parameters with extension in value', () {
      final item1 = MediaItem.url('https://picsum.photos/800/600?random=1.jpg');
      final item2 = MediaItem.url('https://example.com/api?file=image.png&size=large');
      final item3 = MediaItem.url('https://cdn.com/media?id=123&name=video.mp4');
      
      expect(item1.type, MediaType.image);
      expect(item2.type, MediaType.image);
      expect(item3.type, MediaType.video);
    });

    test('url constructor handles URL fragments', () {
      final item = MediaItem.url('https://example.com/video.mp4#timestamp=10');
      
      expect(item.type, MediaType.video);
      expect(item.isVideo, true);
    });

    test('url constructor throws on unsupported extension', () {
      expect(
        () => MediaItem.url('https://example.com/file.txt'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('url constructor throws on missing extension', () {
      expect(
        () => MediaItem.url('https://example.com/file'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('url constructor with hero tag', () {
      final item = MediaItem.url('https://example.com/photo.jpg', tag: 'hero1');
      
      expect(item.type, MediaType.image);
      expect(item.tag, 'hero1');
    });

    test('path constructor detects image from local path', () {
      final item = MediaItem.path('/storage/photos/image.png');
      
      expect(item.type, MediaType.image);
      expect(item.path, '/storage/photos/image.png');
      expect(item.isImage, true);
    });

    test('path constructor detects video from local path', () {
      final item = MediaItem.path('/storage/videos/clip.mp4');
      
      expect(item.type, MediaType.video);
      expect(item.path, '/storage/videos/clip.mp4');
      expect(item.isVideo, true);
    });

    test('asset constructor detects image from asset path', () {
      final item = MediaItem.asset('assets/images/photo.jpg');
      
      expect(item.type, MediaType.image);
      expect(item.assetPath, 'assets/images/photo.jpg');
      expect(item.isImage, true);
    });

    test('asset constructor detects video from asset path', () {
      final item = MediaItem.asset('assets/videos/intro.mp4');
      
      expect(item.type, MediaType.video);
      expect(item.assetPath, 'assets/videos/intro.mp4');
      expect(item.isVideo, true);
    });

    test('url constructor is case-insensitive', () {
      final item1 = MediaItem.url('https://example.com/photo.JPG');
      final item2 = MediaItem.url('https://example.com/video.MP4');
      
      expect(item1.type, MediaType.image);
      expect(item2.type, MediaType.video);
    });
  });

  group('MediaViewerConfig', () {
    test('default values are correct', () {
      const config = MediaViewerConfig();
      
      expect(config.showIndicator, true);
      expect(config.enableLoop, false);
      expect(config.enableImageZoom, true);
      expect(config.enableDoubleTapZoom, true);
      expect(config.minScale, 1.0);
      expect(config.maxScale, 3.0);
      expect(config.autoPlayVideo, false);
      expect(config.showVideoControls, true);
      expect(config.allowFullScreen, true);
      expect(config.pageSnapping, true);
      expect(config.showNavigationArrows, false);
      expect(config.showBackButton, false);
      expect(config.enableDismissOnSwipeDown, false);
      expect(config.swipeToPageThreshold, 0.6);
      expect(config.enableAutoDetectMediaType, false);
    });

    test('copyWith creates correct copy', () {
      const config = MediaViewerConfig();
      final newConfig = config.copyWith(
        showIndicator: false,
        enableLoop: true,
        maxScale: 5.0,
        showNavigationArrows: true,
        showBackButton: true,
        enableDismissOnSwipeDown: true,
        enableAutoDetectMediaType: true,
      );
      
      expect(newConfig.showIndicator, false);
      expect(newConfig.enableLoop, true);
      expect(newConfig.maxScale, 5.0);
      expect(newConfig.showNavigationArrows, true);
      expect(newConfig.showBackButton, true);
      expect(newConfig.enableDismissOnSwipeDown, true);
      expect(newConfig.enableAutoDetectMediaType, true);
      expect(newConfig.enableImageZoom, config.enableImageZoom);
    });
  });

  group('MediaType', () {
    test('enum values are correct', () {
      expect(MediaType.image.name, 'image');
      expect(MediaType.video.name, 'video');
    });
  });

  group('IndicatorPosition', () {
    test('all positions are defined', () {
      expect(IndicatorPosition.values.length, 6);
      expect(IndicatorPosition.values.contains(IndicatorPosition.topLeft), true);
      expect(IndicatorPosition.values.contains(IndicatorPosition.topCenter), true);
      expect(IndicatorPosition.values.contains(IndicatorPosition.topRight), true);
      expect(IndicatorPosition.values.contains(IndicatorPosition.bottomLeft), true);
      expect(IndicatorPosition.values.contains(IndicatorPosition.bottomCenter), true);
      expect(IndicatorPosition.values.contains(IndicatorPosition.bottomRight), true);
    });
  });

  group('NavigationArrowsPosition', () {
    test('all positions are defined', () {
      expect(NavigationArrowsPosition.values.length, 3);
      expect(NavigationArrowsPosition.values.contains(NavigationArrowsPosition.centerVertical), true);
      expect(NavigationArrowsPosition.values.contains(NavigationArrowsPosition.top), true);
      expect(NavigationArrowsPosition.values.contains(NavigationArrowsPosition.bottom), true);
    });
  });

  group('MediaViewerConfig - Video UX Features', () {
    test('hideArrowsWhenVideoPlays has correct default value', () {
      const config = MediaViewerConfig();
      expect(config.hideArrowsWhenVideoPlays, true);
    });

    test('hideArrowsWhenVideoPlays can be set to false', () {
      const config = MediaViewerConfig(hideArrowsWhenVideoPlays: false);
      expect(config.hideArrowsWhenVideoPlays, false);
    });

    test('backButtonPadding has correct default value', () {
      const config = MediaViewerConfig();
      expect(config.backButtonPadding, const EdgeInsets.only(top: 16, left: 8));
    });

    test('backButtonPadding can be customized', () {
      const customPadding = EdgeInsets.only(top: 20, left: 12);
      const config = MediaViewerConfig(backButtonPadding: customPadding);
      expect(config.backButtonPadding, customPadding);
    });

    test('copyWith preserves hideArrowsWhenVideoPlays', () {
      const config = MediaViewerConfig(hideArrowsWhenVideoPlays: false);
      final copied = config.copyWith();
      expect(copied.hideArrowsWhenVideoPlays, false);
    });

    test('copyWith can update hideArrowsWhenVideoPlays', () {
      const config = MediaViewerConfig(hideArrowsWhenVideoPlays: true);
      final copied = config.copyWith(hideArrowsWhenVideoPlays: false);
      expect(copied.hideArrowsWhenVideoPlays, false);
    });

    test('copyWith preserves backButtonPadding', () {
      const customPadding = EdgeInsets.only(top: 20, left: 12);
      const config = MediaViewerConfig(backButtonPadding: customPadding);
      final copied = config.copyWith();
      expect(copied.backButtonPadding, customPadding);
    });

    test('copyWith can update backButtonPadding', () {
      const config = MediaViewerConfig();
      const newPadding = EdgeInsets.only(top: 24, left: 16);
      final copied = config.copyWith(backButtonPadding: newPadding);
      expect(copied.backButtonPadding, newPadding);
    });
  });
}
