import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
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
    widget.onPlayingStateChanged?.call(true);
  }

  void _onPause() {
    widget.onPlayingStateChanged?.call(false);
  }

  void _onFinish() {
    widget.onPlayingStateChanged?.call(false);
  }

  String _colorToHex(Color color) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }

  String _buildIframeUrl() {
    final autoPlay = widget.autoPlay || widget.config.autoPlayVideo;
    return 'https://player.vimeo.com/video/$_videoId?'
        'autoplay=$autoPlay'
        '&loop=false'
        '&muted=false'
        '&title=false'
        '&byline=false'
        '&controls=true'
        '&dnt=true';
  }

  String _buildHtmlContent() {
    return '''
    <!DOCTYPE html>
    <html>
      <head>
        <style>
          body {
            margin: 0;
            padding: 0;
            background-color: ${_colorToHex(widget.config.backgroundColor)};
          }
          .video-container {
            position: relative;
            width: 100%;
            height: 100vh;
          }
          iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
          }
        </style>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <script src="https://player.vimeo.com/api/player.js"></script>
      </head>
      <body>
        <div class="video-container">
          <iframe
            id="player"
            src="${_buildIframeUrl()}"
            frameborder="0"
            allow="autoplay; fullscreen; picture-in-picture"
            allowfullscreen
            webkitallowfullscreen
            mozallowfullscreen>
          </iframe>
        </div>
        <script>
          const player = new Vimeo.Player('player');
          player.ready().then(() => console.log('vimeo:onReady'));
          player.on('play', () => console.log('vimeo:onPlay'));
          player.on('pause', () => console.log('vimeo:onPause'));
          player.on('ended', () => console.log('vimeo:onFinish'));
          player.on('seeked', () => console.log('vimeo:onSeek'));
        </script>
      </body>
    </html>
    ''';
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
          child: InAppWebView(
            initialSettings: InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              useHybridComposition: true,
              allowsBackForwardNavigationGestures: false,
              javaScriptEnabled: true,
            ),
            initialData: InAppWebViewInitialData(
              data: _buildHtmlContent(),
              baseUrl: WebUri('https://player.vimeo.com'),
            ),
            onConsoleMessage: (controller, consoleMessage) {
              final message = consoleMessage.message;
              if (message.startsWith('vimeo:')) {
                final event = message.substring(6);
                switch (event) {
                  case 'onPlay':
                    _onPlay();
                    break;
                  case 'onPause':
                    _onPause();
                    break;
                  case 'onFinish':
                    _onFinish();
                    break;
                }
              }
            },
            onEnterFullscreen: (controller) {
              // Fullscreen is handled natively by InAppWebView
            },
            onExitFullscreen: (controller) {
              // Fullscreen exit is handled natively by InAppWebView
            },
          ),
        ),
      ),
    );
  }
}
