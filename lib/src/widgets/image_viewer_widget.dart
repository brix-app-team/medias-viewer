import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/media_item.dart';
import '../models/media_viewer_config.dart';

/// Widget for displaying an image with zoom and pan capabilities.
class ImageViewerWidget extends StatelessWidget {
  /// Creates an [ImageViewerWidget].
  const ImageViewerWidget({
    super.key,
    required this.item,
    required this.config,
    this.onTap,
  });

  /// The image item to display.
  final MediaItem item;

  /// Configuration for the viewer.
  final MediaViewerConfig config;

  /// Callback when the image is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (item.url != null) {
      // Network image
      imageProvider = CachedNetworkImageProvider(item.url!);
    } else if (item.path != null) {
      // File image
      imageProvider = FileImage(File(item.path!));
    } else if (item.assetPath != null) {
      // Asset image
      imageProvider = AssetImage(item.assetPath!);
    } else {
      // Fallback
      return const Center(
        child: Icon(Icons.broken_image, size: 64, color: Colors.white54),
      );
    }

    Widget photoView = PhotoView(
      imageProvider: imageProvider,
      minScale: PhotoViewComputedScale.contained,
      maxScale: config.maxScale,
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: item.tag != null
          ? PhotoViewHeroAttributes(tag: '${item.tag}_${config.heroTagSuffix}')
          : null,
      backgroundDecoration: BoxDecoration(color: config.backgroundColor),
      enableRotation: false,
      enablePanAlways: true,
      onTapUp: onTap != null
          ? (context, details, controllerValue) => onTap?.call()
          : null,
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(
          value: event == null
              ? 0
              : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          color: Colors.white,
        ),
      ),
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(Icons.error_outline, size: 64, color: Colors.white54),
      ),
    );

    // Disable zoom if configured
    if (!config.enableImageZoom) {
      photoView = PhotoView(
        imageProvider: imageProvider,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained,
        initialScale: PhotoViewComputedScale.contained,
        heroAttributes: item.tag != null
            ? PhotoViewHeroAttributes(
                tag: '${item.tag}_${config.heroTagSuffix}',
              )
            : null,
        backgroundDecoration: BoxDecoration(color: config.backgroundColor),
        disableGestures: true,
        onTapUp: onTap != null
            ? (context, details, controllerValue) => onTap?.call()
            : null,
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
            color: Colors.white,
          ),
        ),
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.error_outline, size: 64, color: Colors.white54),
        ),
      );
    }

    return photoView;
  }
}
