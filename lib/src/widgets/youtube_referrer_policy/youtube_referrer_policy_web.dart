// ignore_for_file: implementation_imports
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:youtube_player_iframe_web/src/web_youtube_player_iframe_controller.dart';
import 'package:youtube_player_iframe_web/src/web_youtube_player_iframe_platform.dart';

/// On web, `youtube_player_iframe` renders its player page in a `srcdoc`
/// iframe, which inherits the referrer policy of the host page. When that
/// page serves a strict policy such as `Referrer-Policy: same-origin`, the
/// YouTube embed request leaves without a Referer: Safari then refuses to
/// play (YouTube error 153) and the player stays blank behind the package's
/// loading overlay.
///
/// A `<meta name="referrer">` in the player page restores the browser
/// default (origin only, cross-origin) for everything loaded from it.
///
/// Only the stock platform is replaced, so an app that already installed
/// its own subclass keeps it.
void ensureYoutubeReferrerPolicy() {
  final platform = WebViewPlatform.instance;
  if (platform == null ||
      platform.runtimeType != WebYoutubePlayerIframePlatform) {
    return;
  }
  WebViewPlatform.instance = _ReferrerPolicyPlatform();
}

const _referrerMeta =
    '<meta name="referrer" content="strict-origin-when-cross-origin" />';

class _ReferrerPolicyPlatform extends WebYoutubePlayerIframePlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return _ReferrerPolicyController(params);
  }
}

class _ReferrerPolicyController extends WebYoutubePlayerIframeController {
  _ReferrerPolicyController(super.params);

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) {
    return super.loadHtmlString(
      html.contains('name="referrer"')
          ? html
          : html.replaceFirst('<head>', '<head>$_referrerMeta'),
      baseUrl: baseUrl,
    );
  }
}
