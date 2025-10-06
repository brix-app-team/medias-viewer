import 'package:flutter/material.dart';

/// Widget that displays a back button.
class BackButtonWidget extends StatelessWidget {
  /// Creates a [BackButtonWidget].
  const BackButtonWidget({
    super.key,
    required this.color,
    required this.onPressed,
  });

  /// Color of the button.
  final Color color;

  /// Callback when button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, color: color, size: 28),
          ),
        ),
      ),
    );
  }
}
