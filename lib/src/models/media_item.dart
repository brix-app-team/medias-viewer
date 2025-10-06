import 'media_type.dart';
import '../utils/media_type_detector.dart';

/// Represents a media item (image or video) to be displayed in the viewer.
class MediaItem {
  /// Creates a [MediaItem].
  ///
  /// The [type] determines whether this is an image or video.
  /// The [url] is the network URL of the media.
  /// The [path] is an optional local file path (for local media).
  /// The [assetPath] is an optional asset path (for bundled media).
  /// The [tag] is an optional hero animation tag.
  const MediaItem({
    required this.type,
    this.url,
    this.path,
    this.assetPath,
    this.tag,
  }) : assert(
         url != null || path != null || assetPath != null,
         'At least one of url, path, or assetPath must be provided',
       );

  /// Creates an image media item from a network URL.
  const MediaItem.imageUrl(String url, {String? tag})
    : this(type: MediaType.image, url: url, tag: tag);

  /// Creates an image media item from a local file path.
  const MediaItem.imagePath(String path, {String? tag})
    : this(type: MediaType.image, path: path, tag: tag);

  /// Creates an image media item from an asset path.
  const MediaItem.imageAsset(String assetPath, {String? tag})
    : this(type: MediaType.image, assetPath: assetPath, tag: tag);

  /// Creates a video media item from a network URL.
  const MediaItem.videoUrl(String url) : this(type: MediaType.video, url: url);

  /// Creates a video media item from a local file path.
  const MediaItem.videoPath(String path)
    : this(type: MediaType.video, path: path);

  /// Creates a video media item from an asset path.
  const MediaItem.videoAsset(String assetPath)
    : this(type: MediaType.video, assetPath: assetPath);

  /// Creates a media item from a URL with automatic type detection.
  ///
  /// The media type (image or video) is automatically detected based on the
  /// file extension in the URL.
  ///
  /// Supported image extensions: jpg, jpeg, png, gif, webp, bmp, svg
  /// Supported video extensions: mp4, mov, avi, mkv, webm, flv, m4v, wmv
  ///
  /// Throws [UnsupportedError] if:
  /// - The file extension is not recognized
  ///
  /// Example:
  /// ```dart
  /// MediaItem.url('https://example.com/photo.jpg')  // Detected as image
  /// MediaItem.url('https://example.com/video.mp4')  // Detected as video
  /// ```
  factory MediaItem.url(String url, {String? tag}) {
    final detectedType = MediaTypeDetector.detectFromUrl(url);

    return MediaItem(type: detectedType, url: url, tag: tag);
  }

  /// Creates a media item from a local file path with automatic type detection.
  ///
  /// The media type (image or video) is automatically detected based on the
  /// file extension in the path.
  ///
  /// See [MediaItem.url] for supported extensions.
  factory MediaItem.path(String path, {String? tag}) {
    final detectedType = MediaTypeDetector.detectFromUrl(path);

    return MediaItem(type: detectedType, path: path, tag: tag);
  }

  /// Creates a media item from an asset path with automatic type detection.
  ///
  /// The media type (image or video) is automatically detected based on the
  /// file extension in the asset path.
  ///
  /// See [MediaItem.url] for supported extensions.
  factory MediaItem.asset(String assetPath, {String? tag}) {
    final detectedType = MediaTypeDetector.detectFromUrl(assetPath);

    return MediaItem(type: detectedType, assetPath: assetPath, tag: tag);
  }

  /// The type of media (image or video).
  final MediaType type;

  /// The network URL of the media.
  final String? url;

  /// The local file path of the media.
  final String? path;

  /// The asset path of the media.
  final String? assetPath;

  /// Optional hero animation tag.
  final String? tag;

  /// Returns true if this is an image.
  bool get isImage => type == MediaType.image;

  /// Returns true if this is a video.
  bool get isVideo => type == MediaType.video;

  /// Returns the source of the media (url, path, or assetPath).
  String get source => url ?? path ?? assetPath ?? '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItem &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          url == other.url &&
          path == other.path &&
          assetPath == other.assetPath &&
          tag == other.tag;

  @override
  int get hashCode =>
      type.hashCode ^
      url.hashCode ^
      path.hashCode ^
      assetPath.hashCode ^
      tag.hashCode;
}
