import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';
import '../models/media_item.dart';
import '../models/media_viewer_config.dart';
import '../utils/media_type_detector.dart';

/// Widget for displaying a Vimeo video with playback controls.
class VimeoViewerWidget extends StatefulWidget {
  /// Creates a [VimeoViewerWidget].
  const VimeoViewerWidget({
    super.key,
    required this.item,
    required this.config,
    this.autoPlay = false,
    this.onPlayingStateChanged,
  });

  /// The Vimeo video item to display.
  final MediaItem item;

  /// Configuration for the viewer.
  final MediaViewerConfig config;

  /// Whether to auto-play the video.
  final bool autoPlay;

  /// Callback when video playing state changes.
  final ValueChanged<bool>? onPlayingStateChanged;

  @override
  State<VimeoViewerWidget> createState() => _VimeoViewerWidgetState();
}

class _VimeoViewerWidgetState extends State<VimeoViewerWidget> {
  String? _videoId;
  String? _errorMessage;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      // Extract video ID from URL
      final videoId =
          widget.item.vimeoVideoId ??
          MediaTypeDetector.extractVimeoVideoId(widget.item.url ?? '');

      if (videoId == null) {
        setState(() {
          _errorMessage = 'Invalid Vimeo URL: ${widget.item.url}';
        });
        return;
      }

      setState(() {
        _videoId = videoId;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _onPlay() {
    setState(() {
      _isPlaying = true;
    });
    widget.onPlayingStateChanged?.call(true);
  }

  void _onPause() {
    setState(() {
      _isPlaying = false;
    });
    widget.onPlayingStateChanged?.call(false);
  }

  void _onFinish() {
    setState(() {
      _isPlaying = false;
    });
    widget.onPlayingStateChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            const Text(
              'Error loading Vimeo video',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    if (_videoId == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Container(
      color: widget.config.backgroundColor,
      child: SafeArea(
        child: Center(
          child: VimeoVideoPlayer(
            videoId: _videoId!,
            onPlay: _onPlay,
            onPause: _onPause,
            onFinish: _onFinish,
          ),
        ),
      ),
    );
  }
}
