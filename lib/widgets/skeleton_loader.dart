import 'package:flutter/material.dart';

/// Provides loading state and optional brightness override to descendant [Skelly] widgets.
///
/// Wrap a subtree with [SkellyWrapper] to control loading state
/// for all [Skelly] widgets within that subtree.
class SkellyWrapper extends InheritedWidget {
  const SkellyWrapper({
    required this.isLoading,
    required super.child,
    this.brightness,
    super.key,
  });

  final bool isLoading;

  /// Optional brightness override for shimmer colors.
  /// - [Brightness.dark]: Use light/white shimmer (for dark or colored backgrounds)
  /// - [Brightness.light]: Use dark shimmer (for light backgrounds)
  /// - null: Auto-detect from theme
  final Brightness? brightness;

  static SkellyWrapper? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkellyWrapper>();
  }

  @override
  bool updateShouldNotify(SkellyWrapper oldWidget) {
    return isLoading != oldWidget.isLoading || brightness != oldWidget.brightness;
  }
}

/// A widget that shows a shimmer loading placeholder when loading.
///
/// Can be controlled via [isLoading] prop or by wrapping with [SkellyWrapper].
class Skelly extends StatefulWidget {
  const Skelly({
    required this.builder,
    this.placeholder,
    this.borderRadius,
    this.isLoading = false,
    super.key,
  });

  /// Builds the actual content when not loading.
  final WidgetBuilder builder;

  /// Optional custom placeholder. If null, uses [builder] output with shimmer.
  final WidgetBuilder? placeholder;

  /// Border radius for the shimmer clip. Defaults to stadium (pill) shape.
  final BorderRadius? borderRadius;

  /// Whether to show loading state. Can also be controlled via [SkellyWrapper].
  final bool isLoading;

  @override
  State<Skelly> createState() => _SkellyState();
}

class _SkellyState extends State<Skelly> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLoading {
    final wrapperLoading = SkellyWrapper.of(context)?.isLoading ?? false;
    return widget.isLoading || wrapperLoading;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Start animation when loading
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
      return _buildShimmer(context);
    }

    // Stop animation when not loading
    if (_controller.isAnimating) {
      _controller.stop();
    }
    return widget.builder(context);
  }

  Widget _buildShimmer(BuildContext context) {
    final wrapper = SkellyWrapper.of(context);
    final brightness = wrapper?.brightness ?? Theme.of(context).brightness;

    // Use colors based on brightness
    // Dark brightness (dark/colored background) -> light shimmer
    // Light brightness (light background) -> dark shimmer
    final colorScheme = Theme.of(context).colorScheme;
    final Color baseColor;
    final Color highlightColor;

    if (brightness == Brightness.dark) {
      baseColor = colorScheme.surfaceContainerHigh;
      highlightColor = colorScheme.surfaceContainerHighest;
    } else {
      baseColor = colorScheme.onSurface.withValues(alpha: 0.1);
      highlightColor = colorScheme.onSurface.withValues(alpha: 0.2);
    }

    final content = widget.placeholder?.call(context) ?? widget.builder(context);
    final radius = widget.borderRadius ?? BorderRadius.circular(1000);

    return ClipRRect(
      borderRadius: radius,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [baseColor, highlightColor, baseColor],
                stops: [
                  (_animation.value - 0.3).clamp(0.0, 1.0),
                  _animation.value.clamp(0.0, 1.0),
                  (_animation.value + 0.3).clamp(0.0, 1.0),
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          );
        },
        child: ColoredBox(
          color: Colors.transparent,
          child: content,
        ),
      ),
    );
  }
}

/// Extension for easily adding skeleton loading to Text widgets.
extension SkellyTextExtension on Text {
  /// Wraps this Text in a [Skelly] that shows a placeholder during loading.
  ///
  /// The [placeholderText] determines the size of the skeleton.
  Widget withSkeleton({required String placeholderText}) {
    return Skelly(
      borderRadius: BorderRadius.circular(4),
      builder: (context) => this,
      placeholder: (context) {
        final textStyle = style ?? DefaultTextStyle.of(context).style;
        final wrapper = SkellyWrapper.of(context);
        final brightness = wrapper?.brightness ?? Theme.of(context).brightness;

        // Use appropriate fill color based on brightness
        final colorScheme = Theme.of(context).colorScheme;
        final fillColor = brightness == Brightness.dark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainer;

        return Stack(
          children: [
            Positioned.fill(
              top: 1,
              bottom: 1,
              child: Container(
                decoration: ShapeDecoration(
                  color: fillColor,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            Text(
              placeholderText,
              style: textStyle.copyWith(
                color: Colors.transparent,
              ),
            ),
          ],
        );
      },
    );
  }
}
