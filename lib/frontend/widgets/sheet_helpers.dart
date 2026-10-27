import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/config/app_shape.dart';
import '../../core/utils/haptics.dart';
import 'springy_tap.dart';

const RoundedRectangleBorder kSheetShape = AppShape.sheetBorder;

class SheetButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;
  final Color? color;

  const SheetButton({
    super.key,
    required this.label,
    required this.filled,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final disabled = onTap == null;
    final fill = color ?? cs.primary;
    final labelColor = filled ? cs.onPrimary : (color ?? cs.onSurface);
    return SpringyTap(
      enabled: !disabled,
      pressedScale: 0.97,
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            Haptics.tap();
            onTap!();
          }
        },
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled
                ? (disabled ? fill.withValues(alpha: 0.4) : fill)
                : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: disabled
                  ? labelColor.withValues(alpha: filled ? 0.85 : 0.4)
                  : labelColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class SheetGrabber extends StatelessWidget {
  final EdgeInsetsGeometry margin;

  const SheetGrabber({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 36,
      height: 5,
      margin: margin,
      decoration: BoxDecoration(
        color: cs.onSurfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}
