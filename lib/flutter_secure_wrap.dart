import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

/// A Flutter widget that masks its child content with a blur effect.
/// It allows toggling visibility manually or automatically hides after a set duration.
/// Optionally supports future authentication integration.
class SecureContent extends StatefulWidget {
  /// Creates a [SecureContent] widget.
  ///
  /// - [child]: The widget to be conditionally masked or revealed.
  /// - [iconColor]: Custom color for the visibility icon overlay.
  /// - [autoHide]: Whether content should auto-hide after 30 seconds.
  /// - [isAuthEnabled]: Placeholder for future authentication gating.
  const SecureContent({
    super.key,

    /// The widget to display securely, either blurred or visible.
    required this.child,

    /// Color of the visibility toggle icon when content is hidden.
    this.iconColor,

    /// Enables automatic hiding after a fixed duration (default is `false`).
    this.autoHide = false,

    /// Enables authentication requirement before revealing content (not active yet).
    this.isAuthEnabled = false,
  });

  /// The content widget to protect and render conditionally.
  final Widget child;

  /// Optional color for the overlay icon that toggles visibility.
  final Color? iconColor;

  /// Flag to enable auto-hide feature after a 30-second interval.
  final bool autoHide;

  /// Optional future flag to trigger authentication-based reveal.
  final bool isAuthEnabled;

  @override
  State<SecureContent> createState() => _SecureContentState();
}

class _SecureContentState extends State<SecureContent> {
  /// Tracks the current visibility status of the content.
  bool isTextVisible = false;

  @override
  void initState() {
    super.initState();

    /// If autoHide is enabled, sets a 30-second timer to toggle visibility.
    if (widget.autoHide) {
      Timer.periodic(Duration(seconds: 30), (Timer t) {
        if (isTextVisible) {
          _setTextVisibility(); // Hides content after interval.
        }
      });
    }
  }

  /// Toggles content visibility state on user interaction or auto-hide.
  void _setTextVisibility() {
    setState(() {
      isTextVisible = !isTextVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// When content is visible, show it with tap-to-hide functionality.
    return isTextVisible
        ? InkWell(child: widget.child, onTap: () => _setTextVisibility())
    /// When content is hidden, blur it and show an icon overlay.
        : ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Stack(
        children: [
          widget.child, // Render the original content underneath.
          Positioned.fill(
            child: BackdropFilter(
              /// Applies a blur filter across the masked content.
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                /// Transparent overlay to darken and obscure content.
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.01),
                ),
                alignment: Alignment.center,
                child: InkWell(
                  /// Tap icon to reveal the blurred content.
                  onTap: () => _setTextVisibility(),
                  child: Icon(
                    Icons.visibility_off,
                    size: 18.0,
                    color: widget.iconColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
