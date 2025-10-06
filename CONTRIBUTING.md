# Contributing to Medias Viewer

Thank you for your interest in contributing to Medias Viewer! This document provides guidelines and information for contributors.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- A clear title and description
- Steps to reproduce
- Expected vs actual behavior
- Flutter and Dart versions
- Device/platform information
- Screenshots if applicable

### Suggesting Features

Feature requests are welcome! Please create an issue with:
- Clear description of the feature
- Use case and benefits
- Possible implementation approach

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests: `flutter test`
5. Run analysis: `flutter analyze`
6. Format code: `dart format .`
7. Commit your changes (`git commit -m 'Add amazing feature'`)
8. Push to the branch (`git push origin feature/amazing-feature`)
9. Open a Pull Request

## Development Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/medias_viewer.git
cd medias_viewer

# Get dependencies
flutter pub get

# Run tests
flutter test

# Run the example app
cd example
flutter pub get
flutter run
```

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter_lints` rules (already configured)
- Format code with `dart format`
- Add documentation comments for public APIs
- Write tests for new features

## Testing

- Write unit tests for models and utilities
- Write widget tests for UI components
- Ensure all tests pass before submitting PR
- Aim for good code coverage

## Documentation

- Update README.md for new features
- Add examples to example/lib/main.dart
- Document public APIs with DartDoc comments
- Update CHANGELOG.md

## Project Structure

```
lib/
  ├── src/
  │   ├── models/          # Data models
  │   ├── widgets/         # UI widgets
  │   └── media_viewer.dart # Main widget
  └── medias_viewer.dart   # Public exports

test/                      # Unit tests
example/                   # Example app
```

## Questions?

Feel free to open an issue for any questions or clarifications.

Thank you for contributing! 🎉
