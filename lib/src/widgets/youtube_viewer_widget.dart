import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: widget.autoPlay || widget.config.autoPlayVideo,
          mute: false,
          loop: false,
          enableCaption: true,
          hideControls: !widget.config.showVideoControls,
          controlsVisibleAtStart: widget.config.showVideoControls,
          disableDragSeek: false,
          isLive: false,
          forceHD: false,
          hideThumbnail: false,
        ),
      );

      // Listen to player state changes
      _controller!.addListener(_onPlayerStateChanged);

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

  void _onPlayerStateChanged() {
    if (_controller == null) return;

    final isCurrentlyPlaying = _controller!.value.isPlaying;
    if (_isPlaying != isCurrentlyPlaying) {
      setState(() {
        _isPlaying = isCurrentlyPlaying;
      });
      widget.onPlayingStateChanged?.call(isCurrentlyPlaying);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onPlayerStateChanged);
    _controller?.dispose();
    super.dispose();
  }

  /// Pauses the video if it's playing.
  void pause() {
    _controller?.pause();
  }

  /// Plays the video if it's paused.
  void play() {
    _controller?.play();
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
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
            onReady: () {
              // Video is ready to play
            },
            onEnded: (metadata) {
              // Video has ended
            },
          ),
        ),
      ),
    );
  }
}
