import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/config/app_visual_style.dart';
import '../../core/utils/haptics.dart';
import 'liquid_glass.dart';

const Duration _defaultNotificationDuration = Duration(milliseconds: 2600);

void showCustomNotification(
  BuildContext context,
  String message, {
  Duration? duration,
}) {
  showCustomNotificationOnOverlay(
    Overlay.of(context),
    message,
    duration: duration,
  );
}

void showCustomNotificationOnOverlay(
  OverlayState overlay,
  String message, {
  Duration? duration,
}) {
  Haptics.selection();
  final total = duration ?? _defaultNotificationDuration;
  final entry = OverlayEntry(
    builder: (context) => CustomNotification(message: message, duration: total),
  );
  overlay.insert(entry);
  Future.delayed(total, () {
    if (entry.mounted) entry.remove();
  });
}

class CustomNotification extends StatefulWidget {
  final String message;
  final Duration duration;

  const CustomNotification({
    required this.message,
    this.duration = _defaultNotificationDuration,
    super.key,
  });

  @override
  State<CustomNotification> createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 240),
    );
    _scale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
    final fadeOutDelay = widget.duration - const Duration(milliseconds: 260);
    Future.delayed(
      fadeOutDelay > Duration.zero ? fadeOutDelay : Duration.zero,
      () {
        if (mounted) _controller.reverse();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIosGlass = defaultTargetPlatform == TargetPlatform.iOS ||
        AppVisualStyle.current.value == VisualStyle.liquidGlass;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final childWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
      child: Text(
        widget.message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cs.onSurface,
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          letterSpacing: isIosGlass ? -0.2 : 0,
        ),
      ),
    );

    return Positioned(
      bottom: 64,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: ScaleTransition(
              scale: _scale,
              child: isIosGlass
                  ? GlassSurface(
                      liquid: LiquidGlass.isSupported,
                      borderRadius: BorderRadius.circular(28),
                      frostTint: isDark
                          ? const Color(0x991E1E28)
                          : const Color(0xCCFFFFFF),
                      liquidTint: isDark
                          ? const Color(0x4D1E1E28)
                          : const Color(0x80FFFFFF),
                      frostSigma: 24,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.14)
                            : Colors.black.withValues(alpha: 0.08),
                        width: 0.8,
                      ),
                      child: childWidget,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: childWidget,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
