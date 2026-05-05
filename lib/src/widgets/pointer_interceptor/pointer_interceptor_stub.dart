import 'package:flutter/widgets.dart';

/// No-op shim used on platforms where the real `pointer_interceptor`
/// plugin is not available. The package upstream only declares plugin
/// support for iOS and Web, so on every other platform this stub keeps
/// the import chain clean and simply renders the child.
class PointerInterceptor extends StatelessWidget {
  /// Creates a no-op [PointerInterceptor].
  const PointerInterceptor({super.key, required this.child});

  /// The widget below this one in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
