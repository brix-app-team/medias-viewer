import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

ImageProvider fileImageProvider(String path) {
  throw UnsupportedError(
    'Local file paths are not supported on web. Use MediaItem.url or '
    'MediaItem.assetPath instead.',
  );
}

VideoPlayerController fileVideoController(String path) {
  throw UnsupportedError(
    'Local file paths are not supported on web. Use MediaItem.url or '
    'MediaItem.assetPath instead.',
  );
}
