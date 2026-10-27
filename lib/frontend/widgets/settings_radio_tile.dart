import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/utils/haptics.dart';
import 'springy_tap.dart';

class SettingsRadioTile extends StatelessWidget {
  final Widget leading;
  final double leadingGap;
  final String label;
  final TextStyle? labelStyle;
  final String? description;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<TapDownDetails>? onTapDown;

  const SettingsRadioTile({
    super.key,
    required this.leading,
    this.leadingGap = 14,
    required this.label,
    this.labelStyle,
    this.description,
    required this.selected,
    required this.onTap,
    this.onTapDown,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIosGlass = defaultTargetPlatform == TargetPlatform.iOS;
    final resolvedLabelStyle = labelStyle ??
        TextStyle(
          color: cs.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: isIosGlass ? -0.2 : 0,
        );

    final labelChild = description == null
        ? Text(label, style: resolvedLabelStyle)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: resolvedLabelStyle),
              const SizedBox(height: 2),
              Text(
                description!,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: 12.5,
                  height: 1.3,
                ),
              ),
            ],
          );

    return SpringyTap(
      enabled: isIosGlass,
      pressedScale: 0.99,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: onTapDown,
        onTap: () {
          Haptics.selection();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              leading,
              SizedBox(width: leadingGap),
              Expanded(child: labelChild),
              if (description != null) const SizedBox(width: 8),
              if (isIosGlass)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1.0 : 0.0,
                  child: Icon(
                    Symbols.check,
                    color: cs.primary,
                    size: 20,
                    weight: 600,
                  ),
                )
              else
                Icon(
                  selected
                      ? Symbols.radio_button_checked
                      : Symbols.radio_button_unchecked,
                  color: selected ? cs.primary : cs.outline,
                  size: 22,
                  fill: selected ? 1 : 0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
