import '../models/media_type.dart';

/// Utility class for detecting media type from file extensions.
class MediaTypeDetector {
  MediaTypeDetector._();

  /// Supported image file extensions.
  static const Set<String> _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'svg',
  };

  /// Supported video file extensions.
  static const Set<String> _videoExtensions = {
    'mp4',
    'mov',
    'avi',
    'mkv',
    'webm',
    'flv',
    'm4v',
    'wmv',
    'm3u8',
    'ts',
  };

  /// Regular expressions for detecting YouTube URLs.
  static final RegExp _youtubeRegex = RegExp(
    r'^(?:https?:\/\/)?(?:www\.|m\.)?(?:youtube\.com\/watch\?v=|youtu\.be\/)([\w-]+)',
    caseSensitive: false,
  );

  /// Checks if a URL is a YouTube URL.
  ///
  /// Supports formats:
  /// - https://www.youtube.com/watch?v=VIDEO_ID
  /// - https://youtube.com/watch?v=VIDEO_ID
  /// - https://m.youtube.com/watch?v=VIDEO_ID
  /// - https://youtu.be/VIDEO_ID
  /// - youtube.com/watch?v=VIDEO_ID (without protocol)
  static bool isYouTubeUrl(String url) {
    return _youtubeRegex.hasMatch(url);
  }

  /// Extracts the YouTube video ID from a URL.
  ///
  /// Returns null if the URL is not a valid YouTube URL.
  static String? extractYouTubeVideoId(String url) {
    final match = _youtubeRegex.firstMatch(url);
    return match?.group(1);
  }

  /// Detects the media type from a URL or file path based on its extension.
  ///
  /// Returns [MediaType.youtube] if the URL is a YouTube URL.
  /// Returns [MediaType.image] if the extension matches an image format.
  /// Returns [MediaType.video] if the extension matches a video format.
  ///
  /// Throws [UnsupportedError] if the extension is not recognized.
  static MediaType detectFromUrl(String url) {
    // Check for YouTube URL first
    if (isYouTubeUrl(url)) {
      return MediaType.youtube;
    }

    final extension = _getExtension(url);

    if (_imageExtensions.contains(extension)) {
      return MediaType.image;
    }

    if (_videoExtensions.contains(extension)) {
      return MediaType.video;
    }

    throw UnsupportedError(
      'Unable to detect media type from URL: $url\n'
      'Supported image extensions: ${_imageExtensions.join(', ')}\n'
      'Supported video extensions: ${_videoExtensions.join(', ')}\n'
      'Supported video platforms: YouTube (youtube.com, youtu.be)\n'
      'Please use MediaItem.imageUrl(), MediaItem.videoUrl(), or MediaItem.youtubeUrl() instead.',
    );
  }

  /// Extracts the file extension from a URL or path.
  ///
  /// Returns the extension in lowercase without the dot.
  /// If no extension is found, returns an empty string.
  static String _getExtension(String url) {
    // Remove fragments
    final cleanUrl = url.split('#').first;

    // Search for file extensions anywhere in the URL
    // Matches patterns like: .jpg, .mp4, etc followed by end of string, ?, &, or #
    // Also matches extensions within query parameters like ?file=image.jpg
    final extensionPattern = RegExp(r'\.([a-zA-Z0-9]+)(?=[?&#\s]|$)');
    final matches = extensionPattern.allMatches(cleanUrl);

    if (matches.isNotEmpty) {
      // Try each match from last to first to find a valid extension
      for (final match in matches.toList().reversed) {
        final extension = match.group(1)!.toLowerCase();
        // Check if it's a known image or video extension
        if (_imageExtensions.contains(extension) ||
            _videoExtensions.contains(extension)) {
          return extension;
        }
      }

      // If no known extension found, return the last one anyway
      final lastMatch = matches.last;
      return lastMatch.group(1)!.toLowerCase();
    }

    // Fallback: try to get extension from the path segment only
    final pathWithoutQuery = cleanUrl.split('?').first;
    final segments = pathWithoutQuery.split('/');
    final fileName = segments.isNotEmpty ? segments.last : pathWithoutQuery;

    // Extract extension from filename
    final parts = fileName.split('.');
    if (parts.length > 1) {
      return parts.last.toLowerCase();
    }

    return '';
  }

  /// Returns true if the URL has a supported image extension.
  static bool isImageUrl(String url) {
    try {
      return detectFromUrl(url) == MediaType.image;
    } catch (_) {
      return false;
    }
  }

  /// Returns true if the URL has a supported video extension.
  static bool isVideoUrl(String url) {
    try {
      return detectFromUrl(url) == MediaType.video;
    } catch (_) {
      return false;
    }
  }

  /// Returns all supported image extensions.
  static Set<String> get supportedImageExtensions =>
      Set.unmodifiable(_imageExtensions);

  /// Returns all supported video extensions.
  static Set<String> get supportedVideoExtensions =>
      Set.unmodifiable(_videoExtensions);
}
