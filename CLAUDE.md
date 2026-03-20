# CLAUDE.md - Medias Viewer

## Project Overview

Flutter package for displaying images, videos, YouTube, and Vimeo content in a gallery-like viewer. Published on pub.dev as `medias_viewer`.

**Version:** 0.6.1
**Platforms:** Android, iOS, macOS
**Environment:** Dart >=3.9.2, Flutter >=3.24.0

## Commands

```bash
# Dependencies
flutter pub get

# Run tests
flutter test

# Lint / analyze
flutter analyze

# Format code
dart format lib/ test/ example/lib/

# Run example app
cd example && flutter pub get && flutter run
```

## Architecture

```
lib/
  medias_viewer.dart          # Public API exports
  src/
    media_viewer.dart         # Main MediaViewer StatefulWidget (orchestrator)
    models/
      media_item.dart         # MediaItem model with factory constructors
      media_type.dart         # MediaType enum (image, video, youtube, vimeo)
      media_viewer_config.dart # Configuration object with copyWith
    widgets/
      image_viewer_widget.dart      # PhotoView wrapper
      video_viewer_widget.dart      # Chewie/video_player wrapper
      youtube_viewer_widget.dart    # youtube_player_flutter wrapper
      vimeo_viewer_widget.dart      # vimeo_video_player wrapper
      page_indicator_widget.dart    # "X of Y" counter
      navigation_arrows_widget.dart # Left/right arrows
      back_button_widget.dart       # Close button
      dismissible_page_view.dart    # PageView with swipe-down dismiss
    utils/
      media_type_detector.dart # URL parsing & media type detection
test/
  medias_viewer_test.dart     # Unit tests for models and utilities
example/
  lib/main.dart               # Demo app showcasing all features
```

## Code Conventions

- **Linting:** `flutter_lints` (Effective Dart rules) via `analysis_options.yaml`
- **Files:** snake_case (`media_viewer.dart`)
- **Classes/Enums:** PascalCase (`MediaViewer`, `MediaType`)
- **Variables/Params:** camelCase (`initialIndex`, `onDismissed`)
- **Private members:** underscore prefix (`_currentIndex`, `_pageController`)
- **Strings:** single quotes (`'string'`)
- **Constructors:** use `const` where possible, `required` for non-optional params, `super.key`
- **Documentation:** triple-slash `///` DartDoc on all public APIs
- **Factory constructors** for type detection (e.g., `MediaItem.url()`, `MediaItem.imageUrl()`)
- **copyWith pattern** on configuration objects for immutability
- **Callbacks:** `Function?` for optional callbacks (`VoidCallback? onDismissed`)

## Key Patterns

- **Widget composition:** MediaViewer orchestrates smaller viewer widgets per media type
- **State is minimal:** only `_currentIndex` and `_isVideoPlaying`
- **Image precaching** for adjacent pages on swipe
- **Auto-detection** of media type from URL (YouTube, Vimeo, video extensions, image extensions)
- This is a library — `pubspec.lock` is NOT committed (per Dart conventions)

## PR Checklist

1. `flutter test` passes
2. `flutter analyze` clean
3. `dart format .` applied
4. DartDoc on new public APIs
5. Update `CHANGELOG.md` with semantic versioning
6. Update `README.md` if adding features
7. Add examples to `example/lib/main.dart` for new features
