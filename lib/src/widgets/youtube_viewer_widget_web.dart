import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/media_item.dart';
import '../models/media_viewer_config.dart';
import '../utils/media_type_detector.dart';

/// Web implementation of [YouTubeViewerWidget] using
/// `youtube_player_iframe`. The mobile variant relies on
/// `youtube_player_flutter` + `flutter_inappwebview` platform views, which
/// do not work in the browser.
class YouTubeViewerWidget extends StatefulWidget {
  const YouTubeViewerWidget({
    super.key,
    required this.item,
    required this.config,
    this.autoPlay = false,
    this.onPlayingStateChanged,
  });

  final MediaItem item;
  final MediaViewerConfig config;
  final bool autoPlay;
  final ValueChanged<bool>? onPlayingStateChanged;

  @override
  State<YouTubeViewerWidget> createState() => _YouTubeViewerWidgetState();
}

class _YouTubeViewerWidgetState extends State<YouTubeViewerWidget> {
  YoutubePlayerController? _controller;
  String? _errorMessage;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = widget.item.youtubeVideoId ??
        MediaTypeDetector.extractYouTubeVideoId(widget.item.url ?? '');
    if (videoId == null) {
      setState(() {
        _errorMessage = 'Invalid YouTube URL: ${widget.item.url}';
      });
      return;
    }

    final startTime = widget.item.youtubeStartTime ??
        (widget.item.url != null
            ? MediaTypeDetector.extractYouTubeStartTime(widget.item.url!)
            : null);

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: widget.autoPlay || widget.config.autoPlayVideo,
      startSeconds: startTime?.toDouble(),
      params: YoutubePlayerParams(
        showFullscreenButton: true,
        showControls: widget.config.showVideoControls,
        enableCaption: true,
        strictRelatedVideos: true,
      ),
    )..listen(_onPlayerValue);
  }

  void _onPlayerValue(YoutubePlayerValue value) {
    final isCurrentlyPlaying = value.playerState == PlayerState.playing;
    if (_isPlaying != isCurrentlyPlaying) {
      setState(() {
        _isPlaying = isCurrentlyPlaying;
      });
      widget.onPlayingStateChanged?.call(isCurrentlyPlaying);
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void pause() => _controller?.pauseVideo();
  void play() => _controller?.playVideo();
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

    if (_controller == null) {
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
          ),
        ),
      ),
    );
  }
}
