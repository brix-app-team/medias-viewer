import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/media_item.dart';
import '../models/media_viewer_config.dart';

/// Widget for displaying a video with playback controls.
class VideoViewerWidget extends StatefulWidget {
  /// Creates a [VideoViewerWidget].
  const VideoViewerWidget({
    super.key,
    required this.item,
    required this.config,
    this.autoPlay = false,
    this.onPlayingStateChanged,
  });

  /// The video item to display.
  final MediaItem item;

  /// Configuration for the viewer.
  final MediaViewerConfig config;

  /// Whether to auto-play the video.
  final bool autoPlay;

  /// Callback when video playing state changes.
  final ValueChanged<bool>? onPlayingStateChanged;

  @override
  State<VideoViewerWidget> createState() => _VideoViewerWidgetState();
}

class _VideoViewerWidgetState extends State<VideoViewerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Create video player controller based on source
      if (widget.item.url != null) {
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.item.url!));
      } else if (widget.item.path != null) {
        _videoPlayerController =
            VideoPlayerController.file(File(widget.item.path!));
      } else if (widget.item.assetPath != null) {
        _videoPlayerController =
            VideoPlayerController.asset(widget.item.assetPath!);
      }

      if (_videoPlayerController == null) {
        setState(() {
          _errorMessage = 'No valid video source';
        });
        return;
      }

      await _videoPlayerController!.initialize();

      // Add listener to notify playing state changes
      _videoPlayerController!.addListener(_onVideoStateChanged);

      // Create chewie controller
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: widget.autoPlay || widget.config.autoPlayVideo,
        looping: false,
        showControls: widget.config.showVideoControls,
        allowFullScreen: widget.config.allowFullScreen,
        allowMuting: true,
        allowPlaybackSpeedChanging: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white,
          handleColor: Colors.white,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.white54,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading video',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

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
    _videoPlayerController?.removeListener(_onVideoStateChanged);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _onVideoStateChanged() {
    if (_videoPlayerController != null && widget.onPlayingStateChanged != null) {
      widget.onPlayingStateChanged!(_videoPlayerController!.value.isPlaying);
    }
  }

  /// Pauses the video if it's playing.
  void pause() {
    _videoPlayerController?.pause();
  }

  /// Plays the video if it's paused.
  void play() {
    _videoPlayerController?.play();
  }

  /// Returns true if the video is currently playing.
  bool get isPlaying => _videoPlayerController?.value.isPlaying ?? false;

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading video',
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

    if (!_isInitialized || _chewieController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      color: widget.config.backgroundColor,
      child: SafeArea(
        child: Center(
          child: Chewie(
            controller: _chewieController!,
          ),
        ),
      ),
    );
  }
}
