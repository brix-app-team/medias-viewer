import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/media_item.dart';
import '../models/media_viewer_config.dart';
import '../utils/media_type_detector.dart';

/// Widget for displaying a YouTube video with playback controls.
class YouTubeViewerWidget extends StatefulWidget {
  /// Creates a [YouTubeViewerWidget].
  const YouTubeViewerWidget({
    super.key,
    required this.item,
    required this.config,
    this.autoPlay = false,
    this.onPlayingStateChanged,
  });

  /// The YouTube video item to display.
  final MediaItem item;

  /// Configuration for the viewer.
  final MediaViewerConfig config;

  /// Whether to auto-play the video.
  final bool autoPlay;

  /// Callback when video playing state changes.
  final ValueChanged<bool>? onPlayingStateChanged;

  @override
  State<YouTubeViewerWidget> createState() => _YouTubeViewerWidgetState();
}

class _YouTubeViewerWidgetState extends State<YouTubeViewerWidget> {
  YoutubePlayerController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Extract video ID from URL
      final videoId =
          widget.item.youtubeVideoId ??
          MediaTypeDetector.extractYouTubeVideoId(widget.item.url ?? '');

      if (videoId == null) {
        setState(() {
          _errorMessage = 'Invalid YouTube URL: ${widget.item.url}';
        });
        return;
      }

      // Create YouTube player controller
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: widget.autoPlay || widget.config.autoPlayVideo,
        params: YoutubePlayerParams(
          showControls: widget.config.showVideoControls,
          showFullscreenButton: widget.config.allowFullScreen,
          mute: false,
          loop: false,
          enableCaption: true,
          strictRelatedVideos: true,
          // Color and UI customization
          color: 'white',
        ),
      );

      // Listen to player state changes
      _controller!.listen((event) {
        final isCurrentlyPlaying = event.playerState == PlayerState.playing;
        if (_isPlaying != isCurrentlyPlaying) {
          setState(() {
            _isPlaying = isCurrentlyPlaying;
          });
          widget.onPlayingStateChanged?.call(isCurrentlyPlaying);
        }
      });

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  /// Pauses the video if it's playing.
  void pause() {
    _controller?.pauseVideo();
  }

  /// Plays the video if it's paused.
  void play() {
    _controller?.playVideo();
  }

  /// Returns true if the video is currently playing.
  bool get isPlaying => _isPlaying;

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
              'Error loading YouTube video',
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

    if (!_isInitialized || _controller == null) {
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
          child: YoutubePlayer(
            controller: _controller!,
            aspectRatio: 16 / 9,
            backgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
