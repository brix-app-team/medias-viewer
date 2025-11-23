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
  /// The [headers] is a dictionary of http headers (for external media).
  /// The [tag] is an optional hero animation tag.
  /// The [youtubeStartTime] is the start time in seconds for YouTube videos.
  const MediaItem({
    required this.type,
    this.url,
    this.path,
    this.assetPath,
    this.headers,
    this.tag,
    this.youtubeStartTime,
  }) : assert(
         url != null || path != null || assetPath != null,
         'At least one of url, path, or assetPath must be provided',
       );

  /// Creates an image media item from a network URL.
  const MediaItem.imageUrl(String url, {String? tag, Map<String, String>? headers})
    : this(type: MediaType.image, url: url, tag: tag, headers: headers);

  /// Creates an image media item from a local file path.
  const MediaItem.imagePath(String path, {String? tag})
    : this(type: MediaType.image, path: path, tag: tag);

  /// Creates an image media item from an asset path.
  const MediaItem.imageAsset(String assetPath, {String? tag})
    : this(type: MediaType.image, assetPath: assetPath, tag: tag);

  /// Creates a video media item from a network URL.
  const MediaItem.videoUrl(String url, {Map<String, String>? headers}) : this(type: MediaType.video, url: url, headers: headers);

  /// Creates a video media item from a local file path.
  const MediaItem.videoPath(String path)
    : this(type: MediaType.video, path: path);

  /// Creates a video media item from an asset path.
  const MediaItem.videoAsset(String assetPath)
    : this(type: MediaType.video, assetPath: assetPath);

  /// Creates a YouTube video media item from a YouTube URL.
  ///
  /// Supports the following URL formats:
  /// - https://www.youtube.com/watch?v=VIDEO_ID
  /// - https://youtube.com/watch?v=VIDEO_ID
  /// - https://m.youtube.com/watch?v=VIDEO_ID
  /// - https://youtu.be/VIDEO_ID
  /// - youtube.com/watch?v=VIDEO_ID (without protocol)
  ///
  /// The start time parameter (t=) will be automatically extracted from the URL
  /// if present. For example:
  /// - https://www.youtube.com/watch?v=VIDEO_ID&t=90 (starts at 1min30s)
  ///
  /// Example:
  /// ```dart
  /// MediaItem.youtubeUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
  /// MediaItem.youtubeUrl('https://youtu.be/dQw4w9WgXcQ')
  /// MediaItem.youtubeUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=90')
  /// ```
  factory MediaItem.youtubeUrl(String url) {
    final startTime = MediaTypeDetector.extractYouTubeStartTime(url);
    return MediaItem(
      type: MediaType.youtube,
      url: url,
      youtubeStartTime: startTime,
    );
  }

  /// Creates a Vimeo video media item from a Vimeo URL.
  ///
  /// Supports the following URL formats:
  /// - https://vimeo.com/VIDEO_ID
  /// - https://www.vimeo.com/VIDEO_ID
  /// - https://player.vimeo.com/video/VIDEO_ID
  /// - vimeo.com/VIDEO_ID (without protocol)
  ///
  /// Example:
  /// ```dart
  /// MediaItem.vimeoUrl('https://vimeo.com/123456789')
  /// MediaItem.vimeoUrl('https://player.vimeo.com/video/123456789')
  /// ```
  const MediaItem.vimeoUrl(String url) : this(type: MediaType.vimeo, url: url);

  /// Creates a media item from a URL with automatic type detection.
  ///
  /// The media type (image or video) is automatically detected based on the
  /// file extension in the URL.
  ///
  /// Supported image extensions: jpg, jpeg, png, gif, webp, bmp, svg
  /// Supported video extensions: mp4, mov, avi, mkv, webm, flv, m4v, wmv
  ///
  /// For YouTube URLs, the start time parameter (t=) will be automatically
  /// extracted if present.
  ///
  /// Throws [UnsupportedError] if:
  /// - The file extension is not recognized
  ///
  /// Example:
  /// ```dart
  /// MediaItem.url('https://example.com/photo.jpg')  // Detected as image
  /// MediaItem.url('https://example.com/video.mp4')  // Detected as video
  /// MediaItem.url('https://www.youtube.com/watch?v=VIDEO_ID&t=90')  // YouTube with start time
  /// ```
  factory MediaItem.url(String url, {String? tag, Map<String, String>? headers}) {
    final detectedType = MediaTypeDetector.detectFromUrl(url);

    // Extract YouTube start time if it's a YouTube URL
    final startTime = detectedType == MediaType.youtube
        ? MediaTypeDetector.extractYouTubeStartTime(url)
        : null;

    return MediaItem(
      type: detectedType,
      url: url,
      headers: headers,
      tag: tag,
      youtubeStartTime: startTime,
    );
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

  /// The http headers sent when accessing an external media resource.
  final Map<String, String>? headers;

  /// Optional hero animation tag.
  final String? tag;

  /// The start time in seconds for YouTube videos.
  /// If null or 0, the video starts from the beginning.
  final int? youtubeStartTime;

  /// Returns true if this is an image.
  bool get isImage => type == MediaType.image;

  /// Returns true if this is a video.
  bool get isVideo => type == MediaType.video;

  /// Returns true if this is a YouTube video.
  bool get isYouTube => type == MediaType.youtube;

  /// Returns true if this is a Vimeo video.
  bool get isVimeo => type == MediaType.vimeo;

  /// Returns the source of the media (url, path, or assetPath).
  String get source => url ?? path ?? assetPath ?? '';

  /// Returns the YouTube video ID if this is a YouTube media item.
  ///
  /// Returns null if this is not a YouTube media item or if the ID cannot be extracted.
  String? get youtubeVideoId {
    if (!isYouTube || url == null) return null;
    return MediaTypeDetector.extractYouTubeVideoId(url!);
  }

  /// Returns the Vimeo video ID if this is a Vimeo media item.
  ///
  /// Returns null if this is not a Vimeo media item or if the ID cannot be extracted.
  String? get vimeoVideoId {
    if (!isVimeo || url == null) return null;
    return MediaTypeDetector.extractVimeoVideoId(url!);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItem &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          url == other.url &&
          path == other.path &&
          assetPath == other.assetPath &&
          headers == other.headers &&
          tag == other.tag &&
          youtubeStartTime == other.youtubeStartTime;

  @override
  int get hashCode =>
      type.hashCode ^
      url.hashCode ^
      path.hashCode ^
      assetPath.hashCode ^
      headers.hashCode ^
      tag.hashCode ^
      youtubeStartTime.hashCode;
}
