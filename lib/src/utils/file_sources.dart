import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'file_sources_stub.dart'
    if (dart.library.io) 'file_sources_io.dart'
    as impl;

/// Returns an [ImageProvider] backed by a local filesystem path.
///
/// On web, local filesystem paths are not meaningful and this throws an
/// [UnsupportedError]. Callers should only pass a [path]-based [MediaItem]
/// on mobile/desktop platforms.
ImageProvider fileImageProvider(String path) => impl.fileImageProvider(path);

/// Returns a [VideoPlayerController] that reads from a local filesystem path.
///
/// On web, local filesystem paths are not meaningful and this throws an
/// [UnsupportedError]. Callers should use [VideoPlayerController.networkUrl]
/// or [VideoPlayerController.asset] instead.
VideoPlayerController fileVideoController(String path) =>
    impl.fileVideoController(path);
