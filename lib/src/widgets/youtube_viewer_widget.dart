// Facade that selects the right [YouTubeViewerWidget] implementation.
//   - Mobile/desktop (dart.library.io available): `youtube_player_flutter`
//   - Web: `youtube_player_iframe` — `youtube_player_flutter` relies on
//     platform views via flutter_inappwebview which don't work in browsers.
export 'youtube_viewer_widget_web.dart'
    if (dart.library.io) 'youtube_viewer_widget_mobile.dart';
